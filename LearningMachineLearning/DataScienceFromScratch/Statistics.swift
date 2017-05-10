//
//  Statistics.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/24/15.
//  Copyright (c) 2015 Grace Avery. All rights reserved.
//

import Foundation

func max(_ arr: [Double]) -> Double {
    return arr.reduce(Double(Int.min)) {
        return max($0, $1)
    }
}

func min(_ arr: [Double]) -> Double {
    return arr.reduce(Double(Int.max)) {
        return min($0, $1)
    }
}

func mean(_ arr: [Double]) -> Double {
    return sum(arr) / Double(arr.count)
}

func median(_ arr:[Double]) -> Double {
    let n = arr.count
    let arrSorted = arr.sorted()
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

func quantile(_ arr: [Double], p: Double) -> Double {
    let pIndex = Int(p * Double(arr.count))
    return arr.sorted()[pIndex]
}

func mode<T: Hashable>(_ arr: [T]) -> T {
    let counts = Counter(arr)
    let (maxValue, _) = counts.max()
    return maxValue
}

func dataRange(_ arr: [Double]) -> Double {
    return max(arr) - min(arr)
}

func deMean(_ arr: [Double]) -> [Double] {
    let xBar = mean(arr)
    return arr.map {
        $0 - xBar
    }
}

func variance(_ arr: [Double]) -> Double {
    // (approx) average squared deviation from the mean
    let deviationsFromMean = deMean(arr)
    let sumOfSq = sumOfSquares(deviationsFromMean)
    return sumOfSq / Double(arr.count - 1)
}

func standardDeviation(_ arr: [Double]) -> Double {
    return sqrt(variance(arr))
}

func interquartileRange(_ arr: [Double]) -> Double {
    let q75 = quantile(arr, p: 0.75)
    let q25 = quantile(arr, p: 0.25)
    return q75 - q25
}

func covariance(_ arr1: [Double], _ arr2: [Double]) -> Double {
    let n = arr1.count
    let deviationsFromMean1 = deMean(arr1)
    let deviationsFromMean2 = deMean(arr2)
    return dot(deviationsFromMean1, deviationsFromMean2) / Double(n - 1)
}

func correlation(_ arr1: [Double], _ arr2: [Double]) -> Double {
    let standardDeviation1 = standardDeviation(arr1)
    let standardDeviation2 = standardDeviation(arr2)

    if standardDeviation1 > 0 && standardDeviation2 > 0 {
        let covar = covariance(arr1, arr2)
        return covar / standardDeviation1 / standardDeviation2
    }
    else {
        return 0.0
    }
}







