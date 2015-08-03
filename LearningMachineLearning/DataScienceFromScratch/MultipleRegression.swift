//
//  MultipleRegression.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/29/15.
//

import Foundation

class MultipleRegression {
    
    // assumes that the first element of each xi is 1
    class func predict(xi: [Double], _ beta: [Double]) -> Double {
        return dot(xi, beta)
    }
    
    class func error(xi: [Double], _ yi: Double, _ beta: [Double]) -> Double {
        return yi - predict(xi, beta)
    }
    
    class func squaredError(xi: [Double], _ yi: Double, _ beta: [Double]) -> Double {
        return error(xi, yi, beta) ** 2
    }
    
    // the gradient (with respect to beta) corresponding to the ith squared error term
    class func squaredErrorGradient(xi: [Double], _ yi: Double, _ beta: [Double]) -> [Double] {
        let error = self.error(xi, yi, beta)
        return xi.map { (xij: Double) -> Double in
            -2 * xij * error
        }
    }
    
    func estimateBeta(x: [[Double]], y: [Double]) {
        let betaInitial = Array(count: x[0].count, repeatedValue: Double.randNeg1To1())
        print(betaInitial)
    }
    
    
    
    
    
    
    
    
    
}





