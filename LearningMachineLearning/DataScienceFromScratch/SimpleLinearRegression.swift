//
//  SimpleLinearRegression.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/28/15.
//

import Foundation

class LinearRegression {

    class func predict(alpha: Double, beta: Double, xi: Double) -> Double {
        return beta * xi + alpha
    }
    
    // the error from predicting beta * xi + alpha when the actual value is yi
    class func error(alpha: Double, beta: Double, xi: Double, yi: Double) -> Double {
        return yi - predict(alpha, beta: beta, xi: xi)
    }
    
    class func sumOfSquaredErrors(alpha: Double, beta: Double, x: [Double], y: [Double]) -> Double {
        let squaredErrors = zip(x, y).map { (xi, yi) -> Double in
            let error = self.error(alpha, beta: beta, xi: xi, yi: yi)
            return error ** 2
        }
        return sum(squaredErrors)
    }
    
    // given training values for x and y,
    // find the least-squares values of alpha and beta
    class func leastSquaresFit(x: [Double], _ y: [Double]) -> (alpha: Double, beta: Double) {
        let corr = correlation(x, y)
        let stdvX = standardDeviation(x)
        let stdvY = standardDeviation(y)
        
        let beta = corr * stdvY / stdvX
        
        let alpha = mean(y) - beta * mean (x)
        
        return (alpha, beta)
    }
    
    
    
    
    
}
