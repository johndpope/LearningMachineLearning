//
//  DataScienceFromScratch.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/23/15.
//

import Foundation

class DataScienceFromScratch {
    func doTheThing() {

        let m = makeMatrix(4, 4) { (i, j) -> Int in
            return i == j ? 1 : 0
        }
        
        println(m)
        
        
        let a = [1.0, 2.0]
        let b = [1.0, 3.0]
        
        var z = dot(a, b)
        println(z)
        
        z = magnitude(b)
        println(z)
    }
}
