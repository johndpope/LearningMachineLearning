//
//  DecisionTrees.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/28/15.
//  Copyright © 2015 Grace Avery. All rights reserved.
//

import UIKit

class DecisionTrees {
    
    indirect enum Tree: CustomStringConvertible {
        case Leaf(Bool)
        case Node(String, [String: Tree])
        
        var description: String {
            return recursiveDescription("")
        }
        
        func recursiveDescription(indentString: String) -> String {
            switch self {
            case .Leaf(let bool):
                return "\(bool)\n"
            case .Node(let attribute, let dict):
                var s = ""
                s += "Switch on \(attribute)\n"
                var nextDescrips = [String]()
                for (key, tree) in dict {
                    let indent = "\(indentString)->\(attribute) \(key): "
                    nextDescrips.append(indent + tree.recursiveDescription(indentString + "     "))
                }
                let shortest = nextDescrips.sort() { $0.characters.count < $1.characters.count }
                s += shortest.reduce("") { $0 + $1 }
                return s
            }
        }
    }

    func doTheThing() {
        //decisionTreesWithApartmentData()
        
        decisionTreesWithTurtleData()
    }
    
    func decisionTreesWithApartmentData() {
        let data = getApartmentData()
        
        print("total entropy = \(dataEntropy(data))")
        
        // find the lowest partition entropy - that will be your first decision. then repeat!
        for key in Apartment.keys {
            let entropyOfPartition = partitionEntropyBy(data, attribute: key)
            print("\(key) = \(entropyOfPartition)")
        }
        print("----")
        
        
        let tree = buildTreeID3(data, splitCandidates: Apartment.keys)
        print(tree)
        
        
        let apartment1 = Apartment(lotsOfLight: true, bigKitchen: true, expensive: true, bigRooms: true, roofDeck: true)
        let result1 = classify(tree, input: apartment1)
        
        let apartment2 = Apartment(lotsOfLight: true, bigKitchen: true, expensive: true, bigRooms: false, roofDeck: true)
        let result2 = classify(tree, input: apartment2)
        
        let apartment3 = Apartment(lotsOfLight: false, bigKitchen: true, expensive: true, bigRooms: true, roofDeck: true)
        let result3 = classify(tree, input: apartment3)
        
        let apartment4 = Apartment(lotsOfLight: true, bigKitchen: false, expensive: false, bigRooms: false, roofDeck: false)
        let result4 = classify(tree, input: apartment4)
        
        print("Would i want this apartment1?  \(result1)")
        print("Would i want this apartment2?  \(result2)")
        print("Would i want this apartment3?  \(result3)")
        print("Would i want this apartment4?  \(result4)")
    }
    
    func decisionTreesWithTurtleData() {
        let data = getTurtleData()
        
        print("total entropy = \(dataEntropy(data))\n")
        for key in Turtle.knownKeys {
            let entropyOfPartition = partitionEntropyBy(data, attribute: key)
            print("\(key) = \(entropyOfPartition)")
        }
        print("----")
        
        let tree = buildTreeID3(data, splitCandidates: Turtle.knownKeys)
        print(tree)
        
        let turtle1 = makeTurtle(.Cm10, yellowStripesOnSkin: true, redSpotOnSidesOfHead: false, darkShell: true)
        let turtle2 = makeTurtle(.Cm5, yellowStripesOnSkin: true, redSpotOnSidesOfHead: false, darkShell: false)
        let turtle3 = makeTurtle(.Cm15, yellowStripesOnSkin: false, redSpotOnSidesOfHead: true, darkShell: true)
        let turtle4 = makeTurtle(.Cm10, yellowStripesOnSkin: true, redSpotOnSidesOfHead: true, darkShell: false)
        
        print("are these turtles red eared sliders?")
        print("turtle1: \(classify(tree, input: turtle1))")
        print("turtle2: \(classify(tree, input: turtle2))")
        print("turtle3: \(classify(tree, input: turtle3))")
        print("turtle4: \(classify(tree, input: turtle4))")
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
    
    func dataEntropy(labeledData: [(Subscriptable, Bool)]) -> Double {
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
    func partitionEntropy(subsets: [[(Subscriptable, Bool)]]) -> Double {
        let totalCount = subsets.map { $0.count }.reduce(0) { $0 + $1 }
        let subsetEntropies = subsets.map { dataEntropy($0) * Double($0.count) / Double(totalCount) }
        return subsetEntropies.reduce(0.0) { $0 + $1 }
    }
    
    func partitionBy(inputs: [(Subscriptable, Bool)], attribute: String) -> [String: [(Subscriptable, Bool)]]{
        var groups = [String: [(Subscriptable, Bool)]]()
        for input in inputs {
            let key = input.0[attribute]
            if groups[key] == nil {
                groups[key] = [(Subscriptable, Bool)]()
            }
            groups[key]!.append(input)
        }
        return groups
    }
    
    // computes the entropy corresponding to a given partition
    func partitionEntropyBy(inputs: [(Subscriptable, Bool)], attribute: String) -> Double {
        let partitions = partitionBy(inputs, attribute: attribute)
        return partitionEntropy(Array(partitions.values))
    }
    
    func partitionEntropyBy(inputs: [(Subscriptable, Bool)])(attribute: String) -> Double {
        return partitionEntropyBy(inputs, attribute: attribute)
    }
    
    func classify(tree: Tree, input: Subscriptable) -> Bool {
        switch tree {
        // if this is a leaf node, return its value
        case .Leaf(let value):
            return value
            
        // otherwise the tree consists of an attribute to split on
        // and a dictionary whose keys are values of that attribute
        // and whose values are subtrees to consider next
        case .Node(let attribute, let subtreeDict):
            var subtreeKey = input[attribute]
            
            if subtreeDict[subtreeKey] == nil {
                subtreeKey = "None"
            }
            let subtree = subtreeDict[String(subtreeKey)]
            return classify(subtree!, input: input)
        }
    }

    
    func buildTreeID3(inputs: [(Subscriptable, Bool)], var splitCandidates: [String]) -> Tree {
        // if this is our first pass,
        // all the keys of the first input are split candidates
        
        // count trues and falses in the inputs
        let numInputs = inputs.count
        let numTrues = inputs.reduce(0) { $0 + ($1.1 ? 1 : 0) }
        let numFalses = numInputs - numTrues
        
        if numTrues == 0 {
            return Tree.Leaf(false)
        }
        if numFalses == 0 {
            return Tree.Leaf(true)
        }
        
        // if no split candidates left, return the majority leaf
        if splitCandidates.isEmpty {
            return Tree.Leaf(numTrues >= numFalses)
        }
        
        // otherwise, split on the best attribute
        let partitionFunc = partitionEntropyBy(inputs)
        let bestAttribute = min(splitCandidates, key: partitionFunc)
        
        let partitions = partitionBy(inputs, attribute: bestAttribute)
        let newCandidates = splitCandidates.filter { $0 != bestAttribute }
        
        // recursively build the subtrees
        var subtreeDict = [String: Tree]()
        
        for (attributeValue, subset) in partitions {
            let subsetTree = buildTreeID3(subset, splitCandidates: newCandidates)
            subtreeDict[attributeValue] = subsetTree
        }
        
        // default case
        subtreeDict["None"] = Tree.Leaf(numTrues > numFalses)
        
        return Tree.Node(bestAttribute, subtreeDict)
    }
    
    
    
}

