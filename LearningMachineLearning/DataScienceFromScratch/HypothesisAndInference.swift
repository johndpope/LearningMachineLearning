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


