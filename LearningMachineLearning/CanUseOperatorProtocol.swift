//
//  CanUseOperatorProtocol.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/25/15.
//  Copyright (c) 2015 Grace Avery. All rights reserved.
//

import Foundation

protocol CanUseOperators {
    func + (lhs: Self, rhs: Self) -> Self
    func - (lhs: Self, rhs: Self) -> Self
    func * (lhs: Self, rhs: Self) -> Self
    
    func toDouble() -> Double
}

extension Int: CanUseOperators {
    func toDouble() -> Double {
        return Double(self)
    }
}

extension Double: CanUseOperators {
    func toDouble() -> Double {
        return self
    }
}

extension Float: CanUseOperators {
    func toDouble() -> Double {
        return Double(self)
    }
}