//
//  HypothesisAndInference.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/27/15.
//  Copyright (c) 2015 Grace Avery. All rights reserved.
//

import Foundation

func normalApproximationToBinomial(n: Int, p: Double) -> (mu: Double, sigma: Double) {
    let mu = Double(n) * p
    let sigma = sqrt(p * (1 - p) * Double(n))
    return (mu, sigma)
}

func normalProbabilityBelow(hi: Double, mu: Double = 0.0, sigma: Double = 1.0) -> Double {
    return normalCdf(hi, mu: mu, sigma: sigma)
}

func normalProbabilityAbove(lo: Double, mu: Double = 0.0, sigma: Double = 1.0) -> Double {
    return 1 - normalCdf(lo, mu: mu, sigma: sigma)
}

func normalProbabilityBetween(lo lo: Double, hi: Double, mu: Double = 0.0, sigma: Double = 1.0) -> Double {
    return normalCdf(hi, mu: mu, sigma: sigma) - normalCdf(lo, mu: mu, sigma: sigma)
}

func normalProbabilityOutside(lo lo: Double, hi: Double, mu: Double = 0.0, sigma: Double = 1.0) -> Double {
    return 1 - normalProbabilityBetween(lo: lo, hi: hi, mu: mu, sigma: sigma)
}

// returns the z for which P(Z <= z) = probability
func normalUpperBound(p: Double, mu: Double = 0.0, sigma: Double = 1.0) -> Double {
    return inverseNormalCdf(p: p, mu: mu, sigma: sigma)
}

// returns the z for which P(Z >= z) = probability
func normalLowerBound(p: Double, mu: Double = 0.0, sigma: Double = 1.0) -> Double {
    return inverseNormalCdf(p: 1 - p, mu: mu, sigma: sigma)
}

// returns the symmetric (about the mean) bounds that contain the specified probability
func normalTwoSidedBounds(p: Double, mu: Double = 0.0, sigma: Double = 1.0) -> (lowerBound: Double, upperBound: Double) {
    let tailProbability = (1.0 - p) / 2.0
    let upperBound = normalLowerBound(tailProbability, mu: mu, sigma: sigma)
    let lowerBound = normalUpperBound(tailProbability, mu: mu, sigma: sigma)
    return (lowerBound, upperBound)
}




