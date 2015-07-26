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
        
        var a = [1.0, 4.0, 6.9, 99.3, 54.0, 27.3, 2.0]
        let r = dataRange(a)
        println(r)
        
        println(a)
        let v = variance(a)
        println(v)
        
        var dev = standardDeviation(a)
        println(dev)
        
        var b = [4.6, 9.6, 1.0, 14.5, -2.0, 4.5, 7.7]
        dev = standardDeviation(b)
        println(dev)
        
        var q = interquartileRange(a)
        println(q)
        
        q = interquartileRange(b)
        println(q)
        
        println("------")
        
        var c = correlation(a, b)
        println("correlation = \(c)")
        
        
        
    }
}
