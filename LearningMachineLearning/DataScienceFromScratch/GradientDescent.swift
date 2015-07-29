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
        
        print("next theta = \(nextTheta).  nextValue = \(nextValue)")
        
        // stop if we are converging
        if abs(value - nextValue) < tolerance {
            print("done")
            return theta
        }
        else {
            theta = nextTheta
            value = nextValue
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

func minimizeStochastic(targetFn: (Double, Double, [Double]) -> Double, gradientFn: (Double, Double, [Double]) -> [Double], x: [Double], y: [Double], theta0: [Double], alpha0: Double = 0.01) -> [Double] {

    let data = zip(x, y)
    var theta = theta0
    var alpha = alpha0
    var minTheta:[Double]? = nil
    var minValue = Double(UINT32_MAX)
    var iterationsWithNoImprovement = 0
    
    // if we ever go 100 iterations with no improvement, stop
    while iterationsWithNoImprovement < 100 {
        
        var value = 0.0
        for (xi, yi) in data {
            value += targetFn(xi, yi, theta)
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
    
    return minTheta!
}

func maximizeStochastic(targetFn: (Double, Double, [Double]) -> Double, gradientFn: (Double, Double, [Double]) -> [Double], x: [Double], y: [Double], theta0: [Double], alpha0: Double = 0.01) -> [Double] {

    return minimizeStochastic(negate(targetFn),
        gradientFn: negateAll(gradientFn),
        x: x,
        y: y,
        theta0: theta0,
        alpha0: alpha0)
}











