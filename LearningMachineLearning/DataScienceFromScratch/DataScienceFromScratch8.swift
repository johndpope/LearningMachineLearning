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

        DecisionTrees().doTheThing()
        
        //gradientDescent2()
    }

    func gradientDescent() {
        let v = [4.0, 2.0]
        let i = 0
        let h = 0.00001
        
        let a = partialDifferenceQuotient(v, i: i, h: h) { (v: [Double]) -> Double  in
            return v[0] ** v[1]
        }
        print(a)
    }
    
    // todo-maybe: find 3d graphing library so you can show some of this stuff

    func gradientDescent2() {
        // pick a random starting point
        var v = [Double]()
        for _ in 0..<3 {
            let rand = Int.randomIntBetween(-10, 10)
            v.append(Double(rand))
        }
    
        print(v)
        
        let tolerance = 0.0000001
        
        func f(v: [Double]) -> Double {
            return v[0] ** 2 + v[1] ** 2 + v[2] ** 2
        }
        
        // find the variables which produce the smallest output of sumOfSquares 
        // this approaches [0, 0, 0]
        while true {
            let gradient = sumOfSquaresGradient(v)
            print("v = \(v)")
            print("gradient = \(gradient)")
            
            var gradientApprox = [Double]()
            for i in 0..<v.count {
                gradientApprox.append(partialDifferenceQuotient(v, i: i, h: 0.00001, f: f))
            }
            print(gradientApprox)
            
            let nextV = step(v, direction: gradient, stepSize: -0.01)
            if distance(nextV, v) < tolerance {
                print("done")
                break
            }
            v = nextV
        }
        
        print(v)
    }
    
    func gradientDescent3() {
        let theta = [4.0, 3.0]
        func targetFn(v: [Double]) -> Double {
            return v[0] ** v[1]
        }
        func gradientFn(v: [Double]) -> [Double] {
            var gradient = [Double]()
            for i in 0..<v.count {
                let a = partialDifferenceQuotient(v, i: i, h: 0.0001, f: targetFn)
                gradient.append(a)
            }
            return gradient
        }
        print(minimizeBatch(targetFn, gradientFn: gradientFn, theta_0: theta))
    }
    

    func gradientDescent4() {
        let theta = [4.0, 3.0]
        
        
        func targetFn(v: [Double]) -> Double {
            return v[0] - v[1]
        }
        func gradientFn(v: [Double]) -> [Double] {
            var gradient = [Double]()
            for i in 0..<v.count {
                let a = partialDifferenceQuotient(v, i: i, h: 0.0001, f: targetFn)
                gradient.append(a)
            }
            return gradient
        }
        print(maximizeBatch(targetFn, gradientFn: gradientFn, theta_0: theta))
    }
    
    func gradientDescent5() {
        func f(x: Double) -> Double {
            return x ** 2 + 4 * x
        }
        func targetFn(v: [Double]) -> Double {
            return v[0] ** 2 + v[0] * 4
        }
        func gradientFn(v: [Double]) -> [Double] {
            var gradient = [Double]()
            for i in 0..<v.count {
                let a = partialDifferenceQuotient(v, i: i, h: 0.0001, f: targetFn)
                gradient.append(a)
            }
            return gradient
        }
        
        let chart = FunctionChartView(frame: view.frame)
        chart.setUpChartWithFunction(view.frame, xAxisLabel: "", yAxisLabel: "", minX: -20, maxX: 20, f: f)
        view.addSubview(chart)
        
        let a = differenceQuotient(-4.0, h: 0.001, f: f)
        print(a)
        
        chart.addNewLayerWithFunction(UIColor.blueColor()) {
            differenceQuotient($0, h: 0.0001, f: f)
        }
        
        print(minimizeBatch(targetFn, gradientFn: gradientFn, theta_0: [4.0]))
        
    }

}




