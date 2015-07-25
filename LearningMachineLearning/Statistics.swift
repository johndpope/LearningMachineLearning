//
//  Statistics.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/24/15.
//  Copyright (c) 2015 Grace Avery. All rights reserved.
//

import Foundation

func max(arr: [Double]) -> Double {
    return arr.reduce(Double(Int.min)) {
        return max($0, $1)
    }
}

func min(arr: [Double]) -> Double {
    return arr.reduce(Double(Int.max)) {
        return min($0, $1)
    }
}

func mean(arr: [Double]) -> Double {
    return sum(arr) / Double(arr.count)
}

func median(arr:[Double]) -> Double {
    let n = arr.count
    let arrSorted = sorted(arr)
    let midpoint = n/2
    
    if n % 2 == 1 {
        return arrSorted[midpoint]
    }
    else {
        let lo = midpoint - 1
        let hi = midpoint
        return (arrSorted[lo] + arrSorted[hi]) / 2
    }
}

func quantile(arr: [Double], p: Double) -> Double {
    let pIndex = Int(p * Double(arr.count))
    return sorted(arr)[pIndex]
}














