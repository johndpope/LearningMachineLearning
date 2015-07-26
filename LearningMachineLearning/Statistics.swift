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

func mode<T: Hashable>(arr: [T]) -> T {
    let counts = Counter(arr)
    let (maxValue, _) = counts.max()
    return maxValue
}

func dataRange(arr: [Double]) -> Double {
    return max(arr) - min(arr)
}

func deMean(arr: [Double]) -> [Double] {
    let xBar = mean(arr)
    return arr.map {
        $0 - xBar
    }
}

func variance(arr: [Double]) -> Double {
    // (approx) average squared deviation from the mean
    let deviationsFromMean = deMean(arr)
    let sumOfSq = sumOfSquares(deviationsFromMean)
    return sumOfSq / Double(arr.count - 1)
}

func standardDeviation(arr: [Double]) -> Double {
    return sqrt(variance(arr))
}

func interquartileRange(arr: [Double]) -> Double {
    let q75 = quantile(arr, 0.75)
    let q25 = quantile(arr, 0.25)
    return q75 - q25
}

func covariance(arr1: [Double], arr2: [Double]) -> Double {
    let n = arr1.count
    let deviationsFromMean1 = deMean(arr1)
    let deviationsFromMean2 = deMean(arr2)
    
    println(deviationsFromMean1)
    println(deviationsFromMean2)
    
    let d = dot(deviationsFromMean1, deviationsFromMean2)
    println(d)
    
    let covar = d / Double(n - 1)
    println(covar)
    
    return covar
}

func correlation(arr1: [Double], arr2: [Double]) -> Double {
    let standardDeviation1 = standardDeviation(arr1)
    let standardDeviation2 = standardDeviation(arr2)

    if standardDeviation1 > 0 && standardDeviation2 > 0 {
        let covar = covariance(arr1, arr2)
        println("covariance = \(covar)")
        println(standardDeviation1)
        println(standardDeviation2)
        
        let covarDivided = covar / standardDeviation1 / standardDeviation2
        println("covar divided = \(covarDivided)")
        
        return covarDivided
    }
    else {
        return 0.0
    }
}







