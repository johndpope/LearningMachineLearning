//
//  SupportVectorMachine.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/19/15.
//  Copyright © 2015 Grace Avery. All rights reserved.
//

import Foundation

/*
vector -> label
---------------
[1.2, 0.7] -> +1
[-0.3, 0.5] -> -1
[-3, -1] -> +1
[0.1, 1.0] -> -1
[3.0, 1.1] -> -1
[2.1, -3] -> +1
*/


// A circuit: it takes 5 Units (x,y,a,b,c) and outputs a single Unit
// It can also compute the gradient w.r.t. its inputs
// (a * x) + (b * y) + c
class Circuit {
    let multiplyGate0 = MultiplyGate()
    let multiplyGate1 = MultiplyGate()
    let addGate0 = AddGate()
    let addGate1 = AddGate()
    var topUnit: Unit!
    
    func forward(x: Unit, _ y: Unit, _ a: Unit, _ b: Unit, _ c: Unit) -> Unit {
        let ax = multiplyGate0.forward(a, x)
        let by = multiplyGate1.forward(b, y)
        let axPlusBy = addGate0.forward(ax, by)
        topUnit = addGate1.forward(axPlusBy, c)
        return topUnit
    }
    
    func backward(gradientTop: Double) {
        topUnit.grad = gradientTop
        addGate1.backward()
        addGate0.backward()
        multiplyGate1.backward()
        multiplyGate0.backward()
    }
}




class SupportVectorMachine {
    let unitA = Unit(value: 1.0, grad: 0.0)
    let unitB = Unit(value: -2.0, grad: 0.0)
    let unitC = Unit(value: -1.0, grad: 0.0)
    let circuit = Circuit()
    var unitOut: Unit!
    
    func forward(x: Unit, _ y: Unit) -> Unit{
        unitOut = circuit.forward(x, y, unitA, unitB, unitC)
        return unitOut
    }
    
    func backward(label: Int) {  // label is +1 or -1
        // reset pulls on a,b,c
        unitA.grad = 0.0
        unitB.grad = 0.0
        unitC.grad = 0.0
        
        // compute the pull based on what the circuit output was
        var pull = 0.0
        if label == 1 && unitOut.value < 1 {
            pull = 1 // the score was too low: pull up
        }
        else if label == -1 && unitOut.value > -1 {
            pull = -1 // the score was too high for a positive example, pull down
        }
        
        circuit.backward(pull) // writes gradient into x,y,a,b,c
        
        // add regularization pull for parameters: towards zero and proportional to value
        //unitA.grad += -unitA.value
        //unitB.grad += -unitB.value
    }
    
    func parameterUpdate() {
        let stepSize = 0.01
        unitA.value += stepSize * unitA.grad
        unitB.value += stepSize * unitB.grad
        unitC.value += stepSize * unitC.grad
    }
    
    func learnFrom(x x: Unit, y: Unit, label: Int) {
        forward(x, y) // forward pass (set .value in all Units)
        backward(label) // backward pass (set .grad in all Units)
        parameterUpdate() // parameters respond to tug
    }
    
}



extension SupportVectorMachine {
    private class func getDataAndLabels() -> [([Double], Int)] {
        var dataAndLabels = [([Double], Int)]() // tuple of data, label
        
        dataAndLabels.append([1.2, 0.7], 1)
        dataAndLabels.append([-0.3, -0.5], -1)
        dataAndLabels.append([3.0, 0.1], 1)
        dataAndLabels.append([-0.1, -1.0], -1)
        dataAndLabels.append([-1.0, 1.1], -1)
        dataAndLabels.append([2.1, -3.0], 1)
        
        return dataAndLabels
    }
    
    class func doTheThing() {
        var dataAndLabels = getDataAndLabels()
        let svm = SupportVectorMachine()
        
        // a function that computes the classification accuracy
        func evalTrainingAccuracy() -> Double {
            var numCorrect = 0
            for (data, label) in dataAndLabels {
                let x = Unit(value: data[0], grad: 0.0)
                let y = Unit(value: data[1], grad: 0.0)
                
                // see if the prediction matches the provided label
                let predictedLabel = svm.forward(x, y).value > 0 ? 1 : -1
                if predictedLabel == label {
                    numCorrect++
                }
            }
            return Double(numCorrect) / Double(dataAndLabels.count)
        }
        
        // the learning loop
        for iter in 0..<400 {
            // pick a random data point
            let i = Int(arc4random_uniform(UInt32(dataAndLabels.count)))
            let (data, label) = dataAndLabels[i]
            let x = Unit(value: data[0], grad: 0.0)
            let y = Unit(value: data[1], grad: 0.0)
            svm.learnFrom(x: x, y: y, label: label)
            
            if iter % 25 == 0 {
                print("training accuracy at iteration \(iter): \(evalTrainingAccuracy())")
            }
            
        }
        
        
    }
}



