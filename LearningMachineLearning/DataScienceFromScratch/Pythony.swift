//
//  Pythony.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/25/15.
//  Copyright (c) 2015 Grace Avery. All rights reserved.
//

import Foundation

// swift2.0 added zip!  
//func zip<T, U>(arr1: [T], arr2: [U]) -> [(T, U)] {
//    var zipped = [(T, U)]()
//    for i in 0..<arr1.count {
//        let tuple = (arr1[i], arr2[i])
//        zipped.append(tuple)
//    }
//    return zipped
//}

func unzip<T, U>(zipped: [(T, U)]) -> ([T], [U]) {
    var xs = [T]()
    var ys = [U]()
    for (x, y) in zipped {
        xs.append(x)
        ys.append(y)
    }
    return (xs, ys)
}

class Counter<T: Hashable>: CustomStringConvertible {
    var counts = [T: Int]()
    
    init(_ array: [T]) {
        for entry in array {
            if let prevCount = counts[entry] {
                counts[entry] = prevCount + 1
            }
            else {
                counts[entry] = 1
            }
        }
    }
    
    subscript(key: T) -> Int {
        get {
            if let count = counts[key] {
                return count
            }
            return 0
        }
        
        set(newValue) {
            counts[key] = newValue
        }
    }
    
    func max() -> (T, Int) {
        var maxValue = 0
        var maxKey = Array(counts.keys)[0]
        for (key, value) in counts {
            if value > maxValue {
                maxValue = value
                maxKey = key
            }
        }
        return (maxKey, maxValue)
    }
    
    var description: String {
        return counts.description
    }
}

infix operator ** { associativity left precedence 160 }

func ** (left: Double, right: Double) -> Double {
    return pow(left, right)
}

func min(v: [[Double]], key: ([Double]) -> Double) -> [Double] {
    var min = v[0]
    var minValue = Double(UINT32_MAX)
    for num in v {
        let newNum = key(num)
        if newNum < minValue {
            min = num
            minValue = newNum
        }
    }
    return min
}

func min<T, U: Comparable>(v: [T], key: (T) -> U) -> T {
    var minEntry = v[0]
    var minValue = key(minEntry)
    for entry in v {
        let newValue = key(entry)
        if newValue < minValue {
            minEntry = entry
            minValue = newValue
        }
    }
    return minEntry
}

func minIndex<T, U: Comparable>(v: [T], key: (T) -> U) -> Int {
    var minIndex = 0
    var minValue = key(v[0])
    for i in 1..<v.count {
        let newValue = key(v[i])
        if newValue < minValue {
            minIndex = i
            minValue = newValue
        }
    }
    return minIndex
}

func sum(v: [Double]) -> Double {
    return v.reduce(0.0) { $0 + $1 }
}



