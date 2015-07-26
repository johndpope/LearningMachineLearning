//
//  DataScienceFromScratch.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/23/15.
//

import Foundation

class DataScienceFromScratch {
    func doTheThing() {

        var a = [Double]()
        for i in 0..<100 {
            a.append(Double(i))
        }
        println(a)
        
        let stdv = standardDeviation(a)
        println(stdv)
        
        
    }
}
