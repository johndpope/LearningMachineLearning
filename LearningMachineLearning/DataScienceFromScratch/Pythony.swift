//
//  Pythony.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/25/15.
//  Copyright (c) 2015 Grace Avery. All rights reserved.
//

import Foundation

// swift2.0 added zip! (but not for three things)
func zip<T, U, V>(arr1: [T], _ arr2: [U], _ arr3: [V]) -> [(T, U, V)] {
    var zipped = [(T, U, V)]()
    let ordered = [arr1.count, arr2.count, arr3.count].sort()
    let smallestCount = ordered[0]
    
    
    for i in 0..<smallestCount {
        let tuple = (arr1[i], arr2[i], arr3[i])
        zipped.append(tuple)
    }
    return zipped
}

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
        let tuples = mostFrequent(1)
        return tuples[0]
    }
    
    func mostFrequent(n: Int = 5) -> [(T, Int)] {
        var maxValues = Array(count: n, repeatedValue: 0)
        var maxKeys = Array(count: n, repeatedValue: Array(counts.keys)[0])
        for (key, value) in counts {
            for i in 0..<n {
                if value > maxValues[i] {
                    maxValues[i] = value
                    maxKeys[i] = key
                    break
                }
            }
        }
        
        let tuples = Array(zip(maxKeys, maxValues))
        return tuples.sort { $0.1 > $1.1 }
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



