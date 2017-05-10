//
//  Double+Format.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/22/15.
//  Copyright (c) 2015 Grace Avery. All rights reserved.
//

import UIKit

extension Double {
    func format(_ f: String) -> String {
        return String(format: "%\(f)f", self)
    }
    
    static func randomZeroToOne() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX)
    }
    
    static func randNeg1To1() -> Double {
        return Double.randomZeroToOne() * shouldBeNegative()
    }
    
    fileprivate static func shouldBeNegative() -> Double{
        if Double(arc4random()) / Double(UINT32_MAX) > 0.5 {
            return -1
        }
        return 1
    }
}

