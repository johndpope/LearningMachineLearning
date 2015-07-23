//
//  GeneralizedSVM.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/19/15.
//

import UIKit

extension Double {
    static func randomZeroToOne() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX)
    }
}

class GeneralizedSVM {

    private class func rand() -> Double {
        let r = Double.randomZeroToOne()
        return r - 0.5
    }
    
    //"Obviously, you want to modularize your code nicely but I expended this example for you in the hope that it makes things much more concrete and simpler to understand."
    class func doTheThing() {
        let dataAndLabels = ExampleData.exampleData()
        
        // random initial parameters between -0.5 and 0.5
        var a1=rand(), a2=rand(), a3=rand(), a4=rand()
        var b1=rand(), b2=rand(), b3=rand(), b4=rand()
        var c1=rand(), c2=rand(), c3=rand(), c4=rand()
        var d4=rand()
        
        for iter in 0..<100000 {
            // pick a random data point
            let i = Int(arc4random_uniform(UInt32(dataAndLabels.count)))
            let data = dataAndLabels[i]
            let x = data.data[0]
            let y = data.data[1]
            
            // compute forward pass
            let n1 = max(0, a1*x + b1*y + c1) // activation of 1st hidden neuron
            let n2 = max(0, a2*x + b2*y + c2) // 2nd neuron
            let n3 = max(0, a3*x + b3*y + c3) // 3rd neuron
            let score = a4*n1 + b4*n2 + c4*n3 + d4 // the score
            
            // compute the pull on top
            var pull = 0.0
            if data.label == 1 && score < 1 {
                pull = 1 // we want higher output! Pull up.
            }
            else if data.label == -1 && score > -1 {
                pull = -1 // we want lower output! Pull down.
            }
            
            // print accuracy
            if iter % 25 == 0 {
                var numCorrect = 0
                for data in dataAndLabels {
                    let x = data.data[0]
                    let y = data.data[1]
                    
                    // see if the prediction matches the provided label
                    let n1 = max(0, a1*x + b1*y + c1) // activation of 1st hidden neuron
                    let n2 = max(0, a2*x + b2*y + c2) // 2nd neuron
                    let n3 = max(0, a3*x + b3*y + c3) // 3rd neuron
                    let score = a4*n1 + b4*n2 + c4*n3 + d4 // the score
                    
                    let predictedLabel = score > 0 ? 1 : -1
                    if predictedLabel == data.label {
                        numCorrect++
                    }
                }
                let accuracy = Double(numCorrect) / Double(dataAndLabels.count)
                print("training accuracy at iteration \(iter): \(accuracy)")
            }
            
            
            // now compute backward pass to all parameters of the model
            
            // backprop through the last "score" neuron
            let dscore = pull
            var da4 = n1 * dscore
            var dn1 = a4 * dscore
            var db4 = n2 * dscore
            var dn2 = b4 * dscore
            var dc4 = n3 * dscore
            var dn3 = d4 * dscore
            let dd4 = 1.0 * dscore
            
            // backprop the ReLU non-linearities, in place
            // i.e. just set gradients to zero if the neurons did not "fire"
            dn3 = n3 == 0 ? 0 : dn3
            dn2 = n2 == 0 ? 0 : dn2
            dn1 = n1 == 0 ? 0 : dn1
            
            // backprop to parameters of neuron 1
            var da1 = x * dn1
            var db1 = y * dn1
            let dc1 = 1.0 * dn1
            
            // backprop to parameters of neuron 2
            var da2 = x * dn2
            var db2 = y * dn2
            let dc2 = 1.0 * dn2
            
            // backprop to parameters of neuron 3
            var da3 = x * dn3
            var db3 = y * dn3
            let dc3 = 1.0 * dn3
            
            // phew! End of backprop!
            // note we could have also backpropped into x,y
            // but we do not need these gradients. We only use the gradients
            // on our parameters in the parameter update, and we discard x,y
            
            
            // add the pulls from the regularization, tugging all multiplicative
            // parameters (i.e. not the biases) downward, proportional to their value
            da1 -= a1
            da2 -= a2
            da3 -= a3
            da4 -= a4
            db1 -= b1
            db2 -= b2
            db3 -= b3
            db4 -= b4
            dc4 -= c4
            
            
            // finally, do the parameter update
            let stepSize = 0.01
            a1 += stepSize * da1
            b1 += stepSize * db1
            c1 += stepSize * dc1
            a2 += stepSize * da2
            b2 += stepSize * db2
            c2 += stepSize * dc2
            a3 += stepSize * da3
            b3 += stepSize * db3
            c3 += stepSize * dc3
            a4 += stepSize * da4
            b4 += stepSize * db4
            c4 += stepSize * dc4
            d4 += stepSize * dd4
            // wow this is tedious, please use for loops in prod.
            // we're done!
        }
    }
    
}





