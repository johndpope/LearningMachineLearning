//
//  Models.swift
//  LearningMachineLearning
//
//  Created by Grace and Josh on 7/21/15.
//

import Foundation

enum DataType: Int {
    case Type0 = 0
    case Type1 = 1
    case Type2 = 2
}

enum Furniture {
    case Table
    case Chair
    
    func type() -> DataType {
        switch self {
        case .Table:
            return .Type0
        case .Chair:
            return .Type1
        }
    }
}


typealias LabeledInput = ([Double], DataType)

