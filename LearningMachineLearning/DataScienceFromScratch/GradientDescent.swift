//
//  GradientDescent.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/27/15.
//

import Foundation

// easy derivatives:
// http://www.mathsisfun.com/calculus/derivatives-rules.html

typealias ArrayToScalarFunction = ([Double]) -> Double
typealias ArrayToArrayFunction = ([Double]) -> [Double]

func differenceQuotient(x: Double, h: Double, f: (Double) -> Double) -> Double {
    return (f(x + h) - f(x)) / h
}

func partialDifferenceQuotient(vector: [Double], i: Int, h: Double, f: ArrayToScalarFunction) -> Double {
    // compute the partial difference quotient of f at v
    
    var vectorPlusHAtI = vector
    vectorPlusHAtI[i] += h
    return (f(vectorPlusHAtI) - f(vector)) / h
}

func step(vector: [Double], direction: [Double], stepSize: Double) -> [Double] {
    // move stepSize in the direction from v
    return zip(vector, direction).map { (v_i: Double, direction_i: Double) -> Double in
        v_i + stepSize * direction_i
    }
}

func sumOfSquaresGradient(v: [Double]) -> [Double] {
    return v.map { $0 * 2 }
}

func minimizeBatch(var targetFn: ArrayToScalarFunction, gradientFn: ArrayToArrayFunction, theta_0: [Double], tolerance: Double = 0.000001) -> [Double] {
    
    let stepSizes = [100.0, 10.0, 1.0, 0.1, 0.001, 0.0001, 0.00001]
    
    var theta = theta_0
    
    targetFn = safe(targetFn)
    var value = targetFn(theta)
    
    while true {
        let gradient = gradientFn(theta)
        let nextThetas = stepSizes.map {
            step(theta, direction: gradient, stepSize: -$0)
        }
        
        // choose the stepSize that minimizes the error function
        let nextTheta = min(nextThetas, key: targetFn)
        let nextValue = targetFn(nextTheta)
        
        //print("next theta = \(nextTheta).  nextValue = \(nextValue)")
        
        // stop if we are converging
        if abs(value - nextValue) < tolerance {
            //print("done")
            return theta
        }
        else {
            theta = nextTheta
            value = nextValue
        }
    }
}

/*

t = theta
α = learning rate, tiny number (in the other book, referred to as 'h')

newTheta := t − α * (δ / (δ * t)) * J(t)
J(θ) = (1 / 2m) * ∑ (h(xi) − yi)2
h(xi) = t0 + t1 * xi

*/

func gradientDescent2(alpha: Double, x: [Double], y: [Double], ep: Double = 0.0001, max_iter: Int = 10000) -> (Double, Double) {
    var converged = false
    var iter = 0

    let m = x.count // number of samples
    
    // initial theta
    var t0 = Double.randNeg1To1() * 10.0
    var t1 = Double.randNeg1To1() * 10.0
    
    // total error, J(theta)
    var J = 0.0
    for i in 0..<m {
        // (right answer minus predicted answer) squared
        let squaredError = (y[i] - (t0 + t1 * x[i])) ** 2
        J += squaredError
    }
    
    while !converged {
        // for each training sample, compute the gradient
        var grad0 = 0.0
        var grad1 = 0.0
        for i in 0..<m {
            let error = -(y[i] - (t0 + t1 * x[i]))
            grad0 += error
            grad1 += error * x[i]
        }
        grad0 *= 1.0/Double(m)
        grad1 *= 1.0/Double(m)

        // update theta
        t0 -= alpha * grad0
        t1 -= alpha * grad1
        
        // mean squared error
        var e = 0.0
        for i in 0..<m {
            let squaredError = (y[i] - (t0 + t1 * x[i])) ** 2
            e += squaredError
        }
        
        if abs(J-e) <= ep {
            print("Converged, iterations: \(iter)")
            converged = true
        }
        
        J = e   // update error
        iter++
        
        if iter == max_iter {
            print("Max interactions exceeded")
            converged = true
        }
        
    }
    
    return (t0, t1)
}



// verbose version.  easier to step through.
func minimizeBatchSumOfSquaredErrors(x: [Double], y: [Double], theta_0: [Double], tolerance: Double = 0.000001) -> [Double] {
    let stepSizes = [100.0, 10.0, 1.0, 0.1, 0.001, 0.0001, 0.00001]

    let m = x.count // number of samples
    
    var theta = theta_0
    
    func targetFn(xi: Double, _ yi: Double, _ theta: [Double]) -> Double {
        // (right answer minus predicted answer) squared
        let errorSquared = (yi - (theta[1] * xi + theta[0])) ** 2
        return errorSquared
    }
    
    // if we assume we didn't know the gradient function for the target function
    // we could use this
    func gradientFn(xi: Double, _ yi: Double, _ theta: [Double]) -> [Double] {
        let h = 0.0001
        var gradient = [Double]()
        for i in 0..<theta.count {
            var thetaPlusHAtI = theta
            thetaPlusHAtI[i] += h
            let gradientI = targetFn(xi, yi, thetaPlusHAtI) - targetFn(xi, yi, theta)
            let result = gradientI / h
            gradient.append(result)
        }
        return gradient
    }
    
    var currentErrorValue = 0.0
    for i in 0..<m {
        currentErrorValue += targetFn(x[i], y[i], theta)
    }
    
    while true {
        // the 'batch' version of gradient descent uses all the data for each iteration
        var avgGradient0 = 0.0
        var avgGradient1 = 0.0
        for (xi, yi) in zip(x, y) {
            let g = gradientFn(xi, yi, theta)
            avgGradient0 += g[0]
            avgGradient1 += g[1]
        }

        avgGradient0 /= Double(m)
        avgGradient1 /= Double(m)
        
        let nextThetas = stepSizes.map { (h: Double) -> [Double] in
            let t0 = theta[0]
            let t1 = theta[1]
            
            let newt0 = t0 - h * avgGradient0
            let newt1 = t1 - h * avgGradient1
            return [newt0, newt1]
        }

        // choose the stepSize that minimizes the error function
        let nextTheta = min(nextThetas, key: { (theta: [Double]) -> Double in
            // total error
            var J = 0.0
            for i in 0..<m {
                J += targetFn(x[i], y[i], theta)
            }
            return J
        })
        
        var nextErrorValue = 0.0
        for i in 0..<m {
            nextErrorValue += targetFn(x[i], y[i], nextTheta)
        }
        
        // stop if we are converging
        if abs(currentErrorValue - nextErrorValue) < tolerance {
            print("done. returning \(theta)")
            return theta
        }
        else {
            theta = nextTheta
            currentErrorValue = nextErrorValue
        }
    }
}



func negate(f: ArrayToScalarFunction) -> ArrayToScalarFunction {
    // return a function that for any input x, returns -f(x)
    func newF(v: [Double]) -> Double {
        return -f(v)
    }
    return newF
}

func negate(f: (Double, Double, [Double]) -> Double) -> (Double, Double, [Double]) -> Double {
    func newF(a: Double, b: Double, c: [Double]) -> Double {
        return -f(a, b, c)
    }
    return newF
}

func negateAll(f: ArrayToArrayFunction) -> ArrayToArrayFunction {
    // the same when f returns a list of numbers
    func newF(v: [Double]) -> [Double] {
        return f(v).map { -$0 }
    }
    return newF
}

func negateAll(f: (Double, Double, [Double]) -> [Double]) -> (Double, Double, [Double]) -> [Double] {
    func newF(a: Double, b: Double, c: [Double]) -> [Double] {
        return f(a, b, c).map { -$0 }
    }
    return newF
}

func maximizeBatch(targetFn: ArrayToScalarFunction, gradientFn: ArrayToArrayFunction, theta_0: [Double], tolerance: Double = 0.000001) -> [Double] {
    return minimizeBatch(negate(targetFn), gradientFn: negateAll(gradientFn), theta_0: theta_0, tolerance: tolerance)
}

func safe(f: ([Double]) -> Double) -> ([Double]) -> Double {
    func newF(v: [Double]) -> Double {
        do {
            let result = try f(v)
            return result
        } catch {
            return Double(UINT32_MAX)
        }
    }
    return newF
}


// MARK:- Stochastic Gradient Descent

func minimizeStochastic(targetFn: (Double, Double, [Double]) -> Double, gradientFn: (Double, Double, [Double]) -> [Double], x: [Double], y: [Double], theta0: [Double], alpha0: Double = 0.01, maxIterationsWithNoImprovement: Int = 100) -> [Double] {

    let data = zip(x, y)
    var theta = theta0
    var alpha = alpha0
    var minTheta = theta0
    var minValue = Double(UINT32_MAX)
    var iterationsWithNoImprovement = 0
    
    // if we ever go 100 iterations with no improvement, stop
    while iterationsWithNoImprovement < maxIterationsWithNoImprovement {
        
        //print("theta = \(theta)")
        var value = 0.0
        for (xi, yi) in data {
            value += targetFn(xi, yi, theta)
            
            //let errorSquared = (yi - (theta[1] * xi + theta[0])) ** 2
            //value += errorSquared
        }
        
        if value < minValue {
            // if we've found a new minimum remember it
            // and go back to the original step size
            minTheta = theta
            minValue = value
            iterationsWithNoImprovement = 0
            alpha = alpha0
        }
        else {
            // otherwise we're not improving, so try shrinking the step size
            iterationsWithNoImprovement++
            theta = minTheta
            alpha *= 0.9
        }
        
        // and take a gradient step for each of the data points
        var shuffled = Array(data)
        shuffled.shuffle()
        for (xi, yi) in shuffled {
            let gradientI = gradientFn(xi, yi, theta)
            theta = vectorSubtract(theta, scalarMultiply(alpha, gradientI))
        }
    }
    
    return minTheta
}

func maximizeStochastic(targetFn: (Double, Double, [Double]) -> Double, gradientFn: (Double, Double, [Double]) -> [Double], x: [Double], y: [Double], theta0: [Double], alpha0: Double = 0.01) -> [Double] {

    return minimizeStochastic(negate(targetFn),
        gradientFn: negateAll(gradientFn),
        x: x,
        y: y,
        theta0: theta0,
        alpha0: alpha0)
}











