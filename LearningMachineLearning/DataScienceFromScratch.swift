//
//  DataScienceFromScratch.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/23/15.
//

import Foundation

class DataScienceFromScratch {
    func doTheThing() {
        var a = [1,2,3]
        var b = [4,5,6]
        
        var c = zip(a, b)
        
        println(c)
        
        var d = vectorAdd(a, b)

        println(d)
        d = vectorSubtract(a, b)
        println(d)
        
        
        var x = [3.1,5.1,7.1]
        var y = [1.0,1.0,1.0]
        var z = vectorAdd(x, y)
        println(z)
        
        z = vectorSubtract(x, y)
        println(z)
        
        
        
       
        var w = [10.0,20.0,30.0]
        z = vectorSum([x,y,w])
        println(z)
        
        
        println("-----")
        
        
        z = scalarMultiply(5.0, w)
        println(z)
        
        println("-----")
        
        x = [1.0, 1.0, 2.0]
        y = [1.0, 3.0, 5.0]
        w = [1.0, 5.0, 10.0]
        
        z = vectorMean([x,y,w])
        println(z)
        
        var g = dot(x,y)
        println(g)
        
        g = sumOfSquares(y)
        println(g)
        
        
        println("-----")
        
        
        
        
        
        
        z = x + y
        println(z)
        
        z = x - y
        println(z)
        
        z = x * y
        println(z)
        
        z = 5.0 * x
        println(z)
        
        z = x * 2.0
        println(z)
        
        
        println("-----")
        
        var v1 = [2.0, 4.0]
        g = magnitude(v1)
        println(g)
        
        var v2 = [9.0, 5.0]
        g = magnitude(v2)
        println(g)
        
        println("-----")
        
        g = squaredDistance(v1, v2)
        println(g)
        
        g = distance(v1, v2)
        println(g)
    }
}
