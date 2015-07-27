//
//  SupportVectorMachine2d.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/20/15.
//

import Foundation

extension Double {
    func formatD(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

class SupportVectorMachine2d {

    // looking at it in terms of loss functions (rather than force specifications)
    class func doTheThing() {
        func cost(data: [ExampleData], w: [Double], alpha: Double) -> Double {
            
            var totalCost = 0.0 // L, in SVM loss function above
            let n = data.count
            
            for var i=0; i < n; i++ {
                // loop over all data points and compute their score
                
                var xi = data[i].data
                let label = data[i].label
                let score = w[0] * xi[0] + w[1] * xi[1] + w[2]
                
                // accumulate cost based on how compatible the score is with the label
                let costi = max(0, Double(-label) * score + 1)
                
                let formattedScore = score.formatD(".3")
                let formattedCosti = costi.formatD(".3")
                
                print("example \(i): xi = \(xi) and label = \(label)")
                print("score computed to be \(formattedScore)")
                print("cost computed to be \(formattedCosti)")
                print("-----")
                
                totalCost += costi
            }
            
            // regularization cost: we want small weights
            let regCost = alpha * (w[0] * w[0] + w[1] * w[1])
            let formattedRegCost = regCost.format(".3")
            print("regularization cost for current model is \(formattedRegCost)")
            
            totalCost += regCost
            
            let formattedTotalCost = totalCost.format(".3")
            print("total cost is \(formattedTotalCost)")
            return totalCost
        }
        
        let data = ExampleData.exampleData2()
        let w = [0.1, 0.2, 0.3] // example: random numbers
        let alpha = 0.1 // regularization strength
        
        cost(data, w: w, alpha: alpha)
    }
}

