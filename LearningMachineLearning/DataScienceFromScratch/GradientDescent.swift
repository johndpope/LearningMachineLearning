//
//  GradientDescent.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/27/15.
//

import Foundation

// easy derivatives:
// http://www.mathsisfun.com/calculus/derivatives-rules.html


func differenceQuotient(x: Double, h: Double, f: (Double) -> Double) -> Double {
    return (f(x + h) - f(x)) / h
}

func partialDifferenceQuotient(vector: [Double], i: Int, h: Double, f: ([Double]) -> Double) -> Double {
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

