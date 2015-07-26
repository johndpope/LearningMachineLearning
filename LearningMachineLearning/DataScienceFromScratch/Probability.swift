//
//  Probability.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/26/15.
//

import Foundation

func uniformCdf(x: Double) -> Double {
    // Cumulative Distribution Function
    // returns the probability that a uniform random variable is <= x
    
    if x < 0 {
        return 0.0
    }
    else if x < 1 {
        return x
    }
    return 1.0
}

func normalPdf(x: Double, mu: Double = 0.0, sigma: Double = 0.0) -> Double {
    // mu is the mean, sigma is the standard deviation
    let sqrtTwoPi = sqrt(2 * M_PI)
    let xMinusMuSquared = (x - mu) ** 2
    let sigmaSquaredTimesTwo = 2 * (sigma ** 2)
    let numerator = exp(-xMinusMuSquared / sigmaSquaredTimesTwo)
    return numerator / (sqrtTwoPi * sigma)
}