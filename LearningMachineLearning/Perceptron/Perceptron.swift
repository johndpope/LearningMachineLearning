//
//  Perceptron.swift
//  LearningMachineLearning
//
//  Created by Grace and Josh on 7/21/15.
//

import Foundation

class Perceptron {
    let display: ChartUpdate
    
    var weights = [Double]()
    var threshold: Double
    let c = 0.005
    
    init(displayUpdater: ChartUpdate) {
        for _ in 0..<2 {
            weights.append(Double.randNeg1To1())
        }
        threshold = Double.randNeg1To1()
        display = displayUpdater
    }
    
    /*
    Process an input by feeding it through the network.
    Sum up the input * the weights.
    Return 1 if that's gt than the threshold, otherwise 0.
    */
    func feedForward(inputs: [Double]) -> Int{
        
        // compute the sum of the weights times the inputs
        var sum = 0.0
        for i in 0..<inputs.count{
            let weight = weights[i]
            let input = inputs[i]
            sum += (weight * input)
        }
        
        // check if this is greater than the threshold ...
        // ... and if so, output 1! Otherwise, output 0.
        if (sum >= threshold){
            return 1
        }else{
            return 0
        }
    }
    
    /*
    Process an input and check if the network got it correct.
    Arbitrarily, we'll say that if the network outputs "1" -- then it thinks
    the input is a chair. Otherwise, it thinks it is a table.
    */
    func isCorrect(input: LabeledInput) -> Bool {
        let data = input.0
        let label = input.1
        let output = feedForward(data)
        return output == label.rawValue
    }
    
    
    func accuracy(inputs: [LabeledInput]) -> Double {
        var numCorrect = 0
        for input in inputs {
            if isCorrect(input) {
                numCorrect++
            }
        }
        return Double(numCorrect) / Double(inputs.count)
    }
    
    func updateWeightsAndThreshold(input: LabeledInput){
        let data = input.0
        let label = input.1
        
        let output = feedForward(data)
        let direction = Double(label.rawValue - output)
        
        for i in 0..<data.count{
            let weight = weights[i]
            let input = data[i]
            
            // perceptron learning rule from
            // http://computing.dcu.ie/~humphrys/Notes/Neural/single.neural.html
            
            let newWeight = weight + c * direction * input
            
            weights[i] = newWeight
            println("\t\(i): oldW = \(weight), newW = \(newWeight)")
        }
        let oldThreshold = threshold
        threshold = threshold - c * direction
        
        println("\toldT = \(oldThreshold), newT = \(threshold)")
    }
    
    
    
    func learn(inputs: [LabeledInput]) {
        println("Learning!")
        
        var iter = 0
        var converged = false
        
        while (!converged){
            // converged will remain "true" if we
            // never had to update the weights (since we got
            // an example wrong)
            converged = true
            
            let accur = accuracy(inputs)
            println("Accuracy at iteration \(iter): \(accur)")
            display.updateDisplay(threshold: nil, xWeight: nil, yWeight: nil, accuracy: accur, iteration: iter)
            
            iter++
            for input in inputs {
                if !isCorrect(input){
                    updateWeightsAndThreshold(input)
                    let accur2 = accuracy(inputs)
                    if accur2 == 1.0 {
                        println("SHOULD STOP HERE")
                    }
                    display.updateDisplay(threshold: threshold, xWeight: weights[0], yWeight: weights[1], accuracy: accur2, iteration: nil)
                    converged = false
                }
            }
        }
        
        println("Converged! Congratulations!")
    }
}




