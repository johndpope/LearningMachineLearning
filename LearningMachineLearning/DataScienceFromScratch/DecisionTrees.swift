//
//  DecisionTrees.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/28/15.
//  Copyright © 2015 Grace Avery. All rights reserved.
//

import UIKit

class DecisionTrees {

    func doTheThing() {
        let data = getApartmentData()
        
        print("total entropy = \(dataEntropy(data))")
        
        for key in ["lotsOfLight", "bigKitchen", "expensive", "bigRooms"] {
            let entropyOfPartition = partitionEntropyBy(data, attribute: key)
            print("\(key) = \(entropyOfPartition)")
        }
        // find the lowest partition entropy - that will be your first decision. then repeat!
        
    }
    
    func entropy(classProbabilities: [Double]) -> Double {
        return classProbabilities.map { p in
            if p == 0 {
                return 0
            }
            return -p * log2(p)
        }.reduce(0.0) { (total, value) in
            return total + value
        }
    }
    
    func dataEntropy(labeledData: [(Apartment, Bool)]) -> Double {
        let labels = labeledData.map { $0.1 }
        let probabilities = classProbabilities(labels)
        return entropy(probabilities)
    }
    
    func classProbabilities(labels: [Bool]) -> [Double] {
        let totalCount = labels.count
        let counter = Counter(labels)
        let labelCounts = Array(counter.counts.values)
        return labelCounts.map { Double($0) / Double(totalCount) }
    }
    
    // finds the entropy from this partition of data into subsets
    func partitionEntropy(subsets: [[(Apartment, Bool)]]) -> Double {
        let totalCount = subsets.map { $0.count }.reduce(0) { $0 + $1 }
        let subsetEntropies = subsets.map { dataEntropy($0) * Double($0.count) / Double(totalCount) }
        return subsetEntropies.reduce(0.0) { $0 + $1 }
    }
    
    func partitionBy(inputs: [(Apartment, Bool)], attribute: String) -> [Bool: [(Apartment, Bool)]]{
        var groups = [Bool: [(Apartment, Bool)]]()
        groups[true] = [(Apartment, Bool)]()
        groups[false] = [(Apartment, Bool)]()
        for input in inputs {
            let dict = input.0.asDict()
            let key = dict[attribute]!
            groups[key]!.append(input)
        }
        return groups
    }
    
    // computes the entropy corresponding to a given partition
    func partitionEntropyBy(inputs: [(Apartment, Bool)], attribute: String) -> Double {
        let partitions = partitionBy(inputs, attribute: attribute)
        return partitionEntropy(Array(partitions.values))
    }
    
    
    
    
    
    
    
}

