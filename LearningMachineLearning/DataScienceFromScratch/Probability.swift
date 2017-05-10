//
//  Probability.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/26/15.
//

import Foundation
import Darwin

func uniformCdf(_ x: Double) -> Double {
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

func normalPdf(_ x: Double, mu: Double = 0.0, sigma: Double = 0.0) -> Double {
    // Probability Density Function
    // mu is the mean, sigma is the standard deviation
    let sqrtTwoPi = sqrt(2 * M_PI)
    let xMinusMuSquared = (x - mu) ** 2
    let sigmaSquaredTimesTwo = 2 * (sigma ** 2)
    let numerator = exp(-xMinusMuSquared / sigmaSquaredTimesTwo)
    return numerator / (sqrtTwoPi * sigma)
}

func normalCdf(_ x: Double, mu: Double = 0.0, sigma: Double = 1.0) -> Double {
    return (1 + Darwin.erf((x - mu) / sqrt(2.0) / sigma)) / 2
}

func inverseNormalCdf(p: Double, mu: Double = 0.0, sigma: Double = 1.0, tolerance: Double = 0.00001) -> Double {
    // find approximate inverse using binary search
    
    // if not standard, compute standard and rescale
    if mu != 0.0 || sigma != 1.0 {
        return mu + sigma * inverseNormalCdf(p: p)
    }
    
    var lowZ = -10.0
    var midZ = 0.0
    var midP = 0.0
    var hiZ = 10.0
    
    while hiZ - lowZ > tolerance {
        midZ = (lowZ + hiZ) / 2
        midP = normalCdf(midZ)
        
        if midP < p {
            lowZ = midZ
        }
        else if midP > p {
            hiZ = midZ
        }
        else {
            break
        }
    }
    
    return midZ
}

func bernoulliTrial(_ p: Double) -> Int {
    if Double.randomZeroToOne() < p {
        return 1
    }
    return 0
}

func binomial(n: Int, p: Double) -> Int {
    var sum = 0
    for _ in 0..<n {
        sum += bernoulliTrial(p)
    }
    return sum
}






