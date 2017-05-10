//
//  Models.swift
//  LearningMachineLearning
//
//  Created by Grace and Josh on 7/21/15.
//

import Foundation

enum DataType: Int {
    case type0 = 0
    case type1
    case type2
    case type3
    case type4
    case type5
    case type6
}

enum Furniture {
    case table
    case chair
    
    func type() -> DataType {
        switch self {
        case .table:
            return .type0
        case .chair:
            return .type1
        }
    }
}


typealias LabeledInput = ([Double], DataType)


