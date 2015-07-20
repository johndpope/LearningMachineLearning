//
//  Data.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/20/15.
//

import Foundation

struct Data {
    let data: [Double]
    let label: Int
    
    static func exampleData() -> [Data] {
        var dataAndLabels = [Data]() // tuple of data, label
        
        dataAndLabels.append(Data(data: [1.2, 0.7], label: 1))
        dataAndLabels.append(Data(data: [-0.3, -0.5], label: -1))
        dataAndLabels.append(Data(data: [3.0, 0.1], label: 1))
        dataAndLabels.append(Data(data: [-0.1, -1.0], label: -1))
        dataAndLabels.append(Data(data: [-1.0, 1.1], label: -1))
        dataAndLabels.append(Data(data: [2.1, -3.0], label: 1))
        
        return dataAndLabels
    }
}