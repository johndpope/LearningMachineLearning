//
//  Clustering.swift
//  LearningMachineLearning
//
//  Created by Grace on 8/3/15.
//

import Foundation

class KMeans {
    let k: Int
    var means: [[Double]]
    var assignments: [Int]

    
    init(k: Int) {
        self.k = k
        self.means = Array(count: k, repeatedValue: [0.0, 0.0])
        self.assignments = Array(count: k, repeatedValue: 0)
    }
    
    // return the index of the cluster closest to the input
    func classify(input: [Double]) -> Int {
        return minIndex(means) { (mean: [Double]) -> Double in
            squaredDistance(input, mean)
        }
    }
    
    func train(inputs: [[Double]]) {
        // choose k random points as the initial means
        means = inputs.sample(k)
        
        while true {
            let newAssignments = inputs.map { classify($0) }
            print(means)
            print(newAssignments)
            print("----")
            
            
            // if no assignments have changed, we're done
            if assignments == newAssignments {
                return
            }
            
            // otherwise keep the new assignements
            assignments = newAssignments
            
            // and compute new means based on the new assignments
            for i in 0..<k {
                // find all points assigned to cluster i
                
                
                let filtered = zip(inputs, assignments).filter { $0.1 == i }
                
                let iPoints = filtered.map { $0.0 }
                
                // make sure iPoints is not empty, so we don't divide by zero
                if iPoints.count > 0 {
                    means[i] = vectorMean(iPoints)
                }
                
                
            }
            
            
        }
    }
    
    
}
