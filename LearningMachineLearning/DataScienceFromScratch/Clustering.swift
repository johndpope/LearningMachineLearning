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
            
            // if no assignments have changed, we're done
            if assignments == newAssignments {
                return
            }
            
            // otherwise keep the new assignements and compute new means based on the new assignments
            assignments = newAssignments
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
    
    // how much does the initial sampling matter?
    func train(inputs: [[Double]], iterations: Int) -> [[Int]] {
        var bestAssignments = [Int]()
        var bestMeans = [[Double]]()
        var lowestError = Double(UINT32_MAX)
        var allAssignments = [[Int]]()
        
        for _ in 0..<iterations {
            train(inputs)
            allAssignments.append(assignments)
            let error = totalError(inputs)
            print("total error = \(error)")
            
            if error < lowestError {
                lowestError = error
                bestAssignments = assignments
                bestMeans = means
            }
        }
        
        print("lowest error = \(lowestError)")
        self.assignments = bestAssignments
        self.means = bestMeans
        return allAssignments
    }
    
    func totalError(inputs: [[Double]]) -> Double {
        let errors = zip(inputs, assignments).map { (input, cluster) -> Double in
            return squaredDistance(input, means[cluster])
        }
        return sum(errors)
    }
    
    func squaredClusteringErrors(inputs: [[Double]], k: Int) -> Double {
        let clusterer = KMeans(k: k)
        clusterer.train(inputs)
        return clusterer.totalError(inputs)
    }
    
    func trainWithDifferentKValues(inputs: [[Double]]) -> [(Int, Double)] {
        // try out 1 to inputs.count clusters
        let kValues = Array(1...inputs.count)
        
        let errors = kValues.map { ($0, squaredClusteringErrors(inputs, k: $0)) }
        return errors
    }

    
}




