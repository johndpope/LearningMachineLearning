//
//  DataScienceFromScratch8ViewController.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/27/15.
//  Copyright © 2015 Grace Avery. All rights reserved.
//

import UIKit

class DataScienceFromScratch8: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        gradientDescent2()
    }

    func gradientDescent() {
        let v = [4.0, 3.0]
        let i = 1
        let h = 0.00001
        
        let a = partialDifferenceQuotient(v, i: i, h: h) { (v: [Double]) -> Double  in
            return v[0] * v[1]
        }
        print(a)
    }

    func gradientDescent2() {
        // pick a random starting point
        var v = [Double]()
        for _ in 0..<3 {
            let rand = Int.randomIntBetween(-10, 10)
            v.append(Double(rand))
        }
    
        print(v)
        
        let tolerance = 0.0000001
        
        // find the variables which produce the smallest output of sumOfSquares 
        // this approaches [0, 0, 0]
        while true {
            let gradient = sumOfSquaresGradient(v)
            print("v = \(v)")
            print("gradient = \(gradient)")
            let nextV = step(v, direction: gradient, stepSize: -0.01)
            if distance(nextV, v) < tolerance {
                break
            }
            v = nextV
        }
        
        print(v)

    }

}
