//
//  Gates.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/17/15.
//

import Foundation

class BaseGate {
    var unit0: Unit!
    var unit1: Unit!
    var unitTop: Unit!
}

class MultiplyGate: BaseGate {
    func forward(u0: Unit, _ u1: Unit) -> Unit {
        unit0 = u0
        unit1 = u1
        unitTop = Unit(value: u0.value * u1.value, grad: 0.0)
        return unitTop
    }
    
    func backward() {
        unit0.grad += unit1.value * unitTop.grad
        unit1.grad += unit0.value * unitTop.grad
    }
}

class AddGate: BaseGate {
    func forward(u0: Unit, _ u1: Unit) -> Unit {
        unit0 = u0
        unit1 = u1
        unitTop = Unit(value: u0.value + u1.value, grad: 0.0)
        return unitTop
    }
    
    func backward() {
        unit0.grad += 1 * unitTop.grad
        unit1.grad += 1 * unitTop.grad
    }
}

class SigmoidGate: BaseGate {
    func sig(x: Double) -> Double {
        return 1 / (1 + exp(-x))
    }
    
    func forward(u: Unit) -> Unit {
        unit0 = u
        unitTop = Unit(value: sig(u.value), grad: 0.0)
        return unitTop
    }
    
    func backward() {
        let s = sig(unit0.value)
        unit0.grad += (s * (1 - s)) * unitTop.grad
    }
}












