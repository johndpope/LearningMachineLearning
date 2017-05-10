//
//  DataParser.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/20/15.
//

import Foundation

enum IrisType: String {
    case Setosa = "Iris-setosa"
    case Versicolor = "Iris-versicolor"
    case Virginica = "Iris-virginica"
}

extension IrisType {
    func type() -> DataType {
        switch self {
        case .Setosa:
            return .type0
        case .Versicolor:
            return .type1
        case .Virginica:
            return .type2
        }
    }
}

class IrisData {
    var data = [[Double]]()
    var labels = [IrisType]()
    var attributes = [String]()
    
    init() {
        if let text = textFromBundle("iris")?.components(separatedBy: "\n") {
            parseIrisData(text)
            parseAttributes(text)
        }
    }
    
    func parseIrisData(_ text: [String]) {
        var active = false
        for string in text {
            if active {
                let vals = string.components(separatedBy: ",")
                if vals.count < 5 {
                    break
                }
                let nums = Array(vals[0..<4]).map {
                    //Double($0)
                    ($0 as NSString).doubleValue
                }
                data.append(nums)
                labels.append(IrisType(rawValue: vals[4])!)
            }
            if string.hasPrefix("@DATA") {
                active = true
            }
        }
    }
    
    func parseAttributes(_ text: [String]) {
        for string in text {
            if string.hasPrefix("@ATTRIBUTE") {
                let attr = string.components(separatedBy: "\t")
                let attr2 = attr[0].components(separatedBy: " ")
                attributes.append(attr2[1])
            }
            else if string.hasPrefix("@DATA") {
                break
            }
        }
    }
}
