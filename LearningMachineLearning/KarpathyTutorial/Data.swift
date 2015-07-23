//
//  Data.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/20/15.
//

import Foundation

struct ExampleData {
    let data: [Double]
    let label: Int
    
    static func exampleData() -> [ExampleData] {
        var dataAndLabels = [ExampleData]()
        
        dataAndLabels.append(ExampleData(data: [1.2, 0.7], label: 1))
        dataAndLabels.append(ExampleData(data: [-0.3, -0.5], label: -1))
        dataAndLabels.append(ExampleData(data: [3.0, 0.1], label: 1))
        dataAndLabels.append(ExampleData(data: [-0.1, -1.0], label: -1))
        dataAndLabels.append(ExampleData(data: [-1.0, 1.1], label: -1))
        dataAndLabels.append(ExampleData(data: [2.1, -3.0], label: 1))
        
        return dataAndLabels
    }
    
    static func exampleData2() -> [ExampleData] {
        var dataAndLabels = [ExampleData]()
        
        dataAndLabels.append(ExampleData(data: [1.2, 0.7], label: 1))
        dataAndLabels.append(ExampleData(data: [-0.3, 0.5], label: -1))
        dataAndLabels.append(ExampleData(data: [3.0, 2.5], label: 1))
        
        return dataAndLabels
    }
}