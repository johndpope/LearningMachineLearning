//
//  SimpleLinearRegression.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/28/15.
//

import Foundation

class LinearRegression {

    class func predict(_ alpha: Double, beta: Double, xi: Double) -> Double {
        return beta * xi + alpha
    }
    
    // given training values for x and y,
    // find the least-squares values of alpha and beta
    class func leastSquaresFit(_ x: [Double], _ y: [Double]) -> (alpha: Double, beta: Double) {
        let corr = correlation(x, y)
        let stdvX = standardDeviation(x)
        let stdvY = standardDeviation(y)
        
        let beta =  corr * stdvY / stdvX
        
        
        
        let alpha = mean(y) - beta * mean(x)
        print("correlation = \(corr)")
        print("stdv x = \(stdvX)")
        print("stdv y = \(stdvY)")
        
        print("stdvy / stdvx = \(stdvY / stdvX)")
        
        
        print("beta = \(beta)")
        
        return (alpha, beta)
    }
    
    // the error from predicting beta * xi + alpha when the actual value is yi
    class func error(_ alpha: Double, beta: Double, xi: Double, yi: Double) -> Double {
        return yi - predict(alpha, beta: beta, xi: xi)
    }
    
    class func sumOfSquaredErrors(_ alpha: Double, beta: Double, x: [Double], y: [Double]) -> Double {
        let squaredErrors = zip(x, y).map { (xi, yi) -> Double in
            let error = self.error(alpha, beta: beta, xi: xi, yi: yi)
            return error ** 2
        }
        return sum(squaredErrors)
    }
    
    // the total squared variation of y-i's from their mean
    class func totalSumOfSquares(_ y: [Double]) -> Double {
        let squared = deMean(y).map { $0 ** 2 }
        return sum(squared)
    }
    
    // Coefficient of Determination (R-squared)
    // the fraction of the variation in y captured by the model
    // which equals 1 - the fraction of variation in y not captured by the model
    class func rSquared(_ alpha: Double, beta: Double, x: [Double], y: [Double]) -> Double {
        let sumOfSquaredErrors = self.sumOfSquaredErrors(alpha, beta: beta, x: x, y: y)
        let totalSumOfSquares = self.totalSumOfSquares(y)
        
        print("\n\n")
        print("sum of squared errors = \(sumOfSquaredErrors)")
        print("total sum of squares in y = \(totalSumOfSquares)")
        
        let variationNotCapturedByModel = sumOfSquaredErrors / totalSumOfSquares
        
        print("variation not captured by model = \(variationNotCapturedByModel)\n")
        return 1.0 - variationNotCapturedByModel
    }
    
    
    
    // Mark:- Solve with Gradient Descent
    
    class func squaredError(_ xi: Double, yi: Double, theta: [Double]) -> Double {
        let alpha = theta[0]
        let beta = theta[1]
        
        return error(alpha, beta: beta, xi: xi, yi: yi) ** 2
    }
    
    class func squaredErrorGradient(_ xi: Double, yi: Double, theta: [Double]) -> [Double] {
        let alpha = theta[0]
        let beta = theta[1]
        let alphaPartialDerivative = -2 * error(alpha, beta: beta, xi: xi, yi: yi)
        let betaPartialDerivative = -2 * error(alpha, beta: beta, xi: xi, yi: yi) * xi
        return [alphaPartialDerivative, betaPartialDerivative]
    }
    
    class func linearRegressionMinimizeStochastic(_ x: [Double], y: [Double], h: Double = 0.01) -> (alpha: Double, beta: Double) {
        let theta = [Double.randNeg1To1() * 3, Double.randNeg1To1() * 3]
        
        let result = minimizeStochastic(squaredError, gradientFn: squaredErrorGradient, x: x, y: y, theta0: theta, alpha0: h, maxIterationsWithNoImprovement: 40)
        
        let alpha = result[0]
        let beta = result[1]
        
        return (alpha, beta)
        
    }
    
    
    
    
    
    
    
}
