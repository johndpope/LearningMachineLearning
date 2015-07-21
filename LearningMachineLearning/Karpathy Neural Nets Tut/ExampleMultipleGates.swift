//
//  ExampleMultipleGates.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/17/15.
//

import UIKit

class ExampleMultipleGates {

    static func doTheThing() {
        // create input units
        var a = Unit(value: 1.0, grad: 0.0)
        var b = Unit(value: 2.0, grad: 0.0)
        var c = Unit(value: -3.0, grad: 0.0)
        var x = Unit(value: -1.0, grad: 0.0)
        var y = Unit(value: 3.0, grad: 0.0)
        
        // create the gates
        let multiplyGate0 = MultiplyGate()
        let multiplyGate1 = MultiplyGate()
        let addGate0 = AddGate()
        let addGate1 = AddGate()
        let sigmoidGate = SigmoidGate()
        
        // do the forward pass
        func forwardNeuron() -> Unit {
            let ax = multiplyGate0.forward(a, x)
            let by = multiplyGate1.forward(b, y)
            let axPlusBy = addGate0.forward(ax, by)
            let axPlusByPlusC = addGate1.forward(axPlusBy, c)
            let s = sigmoidGate.forward(axPlusByPlusC)
            return s
        }
        
        let result = forwardNeuron()
        print("circuit output: \(result.value)")
        
        
        // backpropagation
        result.grad = 1.0
        sigmoidGate.backward()   // writes gradient into axpbypc
        addGate1.backward()      // writes gradients into axpby and c
        addGate0.backward()      // writes gradients into ax and by
        multiplyGate1.backward() // writes gradients into b and y
        multiplyGate0.backward() // writes gradients into a and x
        
        let stepSize = 0.01
        
        a.value += stepSize * a.grad // a.grad is -0.105
        b.value += stepSize * b.grad // b.grad is 0.315
        c.value += stepSize * c.grad // c.grad is 0.105
        x.value += stepSize * x.grad // x.grad is 0.105
        y.value += stepSize * y.grad // y.grad is 0.210
        
        let result2 = forwardNeuron()
        print("circuit output after one backprop: \(result2.value)") // prints 0.8825
        
        
        
        
        // check with numerical gradient
        func forwardCircuitFast(a: Double, _ b: Double, _ c: Double, _ x: Double, _ y: Double) -> Double {
            return 1 / (1 + exp(-(a*x + b*y + c)))
        }
        
        func check() {
            
            let a = 1.0
            let b = 2.0
            let c = -3.0
            let x = -1.0
            let y = 3.0
            let h = 0.0001
            let aGrad = (forwardCircuitFast(a + h, b, c, x, y) - forwardCircuitFast(a, b, c, x, y)) / h
            let bGrad = (forwardCircuitFast(a, b + h, c, x, y) - forwardCircuitFast(a, b, c, x, y)) / h
            let cGrad = (forwardCircuitFast(a, b, c + h, x, y) - forwardCircuitFast(a, b, c, x, y)) / h
            let xGrad = (forwardCircuitFast(a, b, c, x + h, y) - forwardCircuitFast(a, b, c, x, y)) / h
            let yGrad = (forwardCircuitFast(a, b, c, x, y + h) - forwardCircuitFast(a, b, c, x, y)) / h
        
            print("aGrad = \(aGrad), bGrad = \(bGrad), cGrad = \(cGrad), xGrad = \(xGrad), yGrad = \(yGrad)")
        }
        check()
        
    }
}













