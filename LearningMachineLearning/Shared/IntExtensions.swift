//
//  IntExtensions.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/27/15.
//  Copyright © 2015 Grace Avery. All rights reserved.
//

import UIKit

extension Int {
    static func randomIntBetween(lo: Int, _ hi: Int) -> Int {
        let diff = hi - lo
        let rand = arc4random_uniform(UInt32(diff))
        return Int(rand) + lo
    }
}