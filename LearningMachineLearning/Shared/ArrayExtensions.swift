//
//  ArrayExtensions.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/28/15.
//  Copyright © 2015 Grace Avery. All rights reserved.
//

import Foundation

extension Array {
    // sample without replacement
    func sample(k: Int) -> [Element] {
        var population = self
        var samples = [Element]()
        for _ in 0..<k {
            if population.count > 0 {
                let rand = Int.randomIntBetween(0, population.count)
                let element = population.removeAtIndex(rand)
                samples.append(element)
            }
        }
        return samples
    }
    
    // sample with replacement
    func sampleWithReplacement(k: Int) -> [Element] {
        var samples = [Element]()
        for _ in 0..<k {
            let rand = Int.randomIntBetween(0, self.count)
            let element = self[rand]
            samples.append(element)
        }
        return samples
    }
}


// the following is from
// https://gist.github.com/ijoshsmith/5e3c7d8c2099a3fe8dc3
extension Array
{
    /** Randomizes the order of an array's elements. */
    mutating func shuffle()
    {
        for _ in 0..<10
        {
            sortInPlace { (_,_) in arc4random() < arc4random() }
        }
    }
}