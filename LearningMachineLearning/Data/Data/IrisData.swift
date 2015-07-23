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

class IrisData {
    var data = [[Double]]()
    var labels = [IrisType]()
    var attributes = [String]()
    
    init() {
        if let text = textFromBundle()?.componentsSeparatedByString("\n") {
            parseIrisData(text)
            parseAttributes(text)
            
            println(data)
            println(labels)
            println(attributes)
        }
    }
    
    func parseIrisData(text: [String]) {
        var active = false
        for string in text {
            if active {
                let vals = string.componentsSeparatedByString(",")
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
    
    func parseAttributes(text: [String]) {
        for string in text {
            if string.hasPrefix("@ATTRIBUTE") {
                let attr = string.componentsSeparatedByString("\t")
                let attr2 = attr[0].componentsSeparatedByString(" ")
                attributes.append(attr2[1])
            }
            else if string.hasPrefix("@DATA") {
                break
            }
        }
    }
    
    func textFromBundle() -> String? {
        let path = NSBundle.mainBundle().pathForResource("iris", ofType: "txt")
        
        let text = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        return text
        
        // keep this for next language change
//        do {
//            let text = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
//            return text
//        } catch {
//            print("error getting data from bundle")
//        }
//        return nil
    }
}
