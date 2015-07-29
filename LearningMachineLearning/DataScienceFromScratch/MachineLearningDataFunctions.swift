//
//  MachineLearningDataFunctions.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/29/15.
//

import Foundation

class ML {
    // split data into fractions [prob, 1-prob]
    class func splitData<T>(data: [T], prob: Double) -> (train: [T], test: [T]) {
        var results = [[T](), [T]()]
        for row in data {
            let group = Double.randomZeroToOne() < prob ? 1 : 0
            results[group].append(row)
        }
        return (results[0], results[1])
    }
    
    class func trainTestSplit<T, U>(x: [T], y: [U], testPercent: Double) -> (xTrain: [T], xTest: [T], yTrain: [U], yTest: [U]) {
        let data = Array(zip(x, y))
        let (train, test) = splitData(data, prob: 1 - testPercent)
        
        let (xTrain, yTrain) = unzip(train)
        let (xTest, yTest) = unzip(test)
        
        return (xTrain, xTest, yTrain, yTest)
    }
    
    // fraction of correct predictions
    // not actually an indicator of a good model.  check out precision and recall
    class func accuracy(truePositives truePositives: Int, falsePositives: Int, trueNegatives: Int, falseNegatives: Int) -> Double {
        let correct = truePositives + trueNegatives
        let total = truePositives + falsePositives + trueNegatives + falseNegatives
        return Double(correct) / Double(total)
    }
    
    // precision is accuracy of positive predictions
    // low result means lots of false positives
    class func precision(truePositives truePositives: Int, falsePositives: Int, trueNegatives: Int, falseNegatives: Int) -> Double {
        return Double(truePositives) / Double(truePositives + falsePositives)
    }
    
    // recall is fraction of positives the model identified
    // low result means lots of false negatives
    class func recall(truePositives truePositives: Int, falsePositives: Int, trueNegatives: Int, falseNegatives: Int) -> Double {
        return Double(truePositives) / Double(truePositives + falseNegatives)
    }
    
    // f1 score is the harmonic mean of precision and recall
    class func f1Score(truePositives truePositives: Int, falsePositives: Int, trueNegatives: Int, falseNegatives: Int) -> Double {
        let p = Double(precision(truePositives: truePositives, falsePositives: falsePositives, trueNegatives: trueNegatives, falseNegatives: falseNegatives))
        let r = Double(recall(truePositives: truePositives, falsePositives: falsePositives, trueNegatives: trueNegatives, falseNegatives: falseNegatives))
        return 2.0 * p * r / (p + r)
    }
    

}
