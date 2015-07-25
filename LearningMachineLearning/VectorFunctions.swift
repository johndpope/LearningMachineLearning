//
//  VectorFunctions.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/24/15.
//

import Foundation

protocol Addable {
    func + (lhs: Self, rhs: Self) -> Self
}
protocol Subtractable {
    func - (lhs: Self, rhs: Self) -> Self
}
protocol Multiplyable {
    func * (lhs: Self, rhs: Self) -> Self
}

extension Int: Addable, Subtractable, Multiplyable {}
extension Double: Addable, Subtractable, Multiplyable {}
extension Float: Addable, Subtractable, Multiplyable {}

func zip<T, U>(arr1: [T], arr2: [U]) -> [(T, U)] {
    var zipped = [(T, U)]()
    for i in 0..<arr1.count {
        let tuple = (arr1[i], arr2[i])
        zipped.append(tuple)
    }
    return zipped
}

func vectorAdd<T: Addable>(arr1: [T], arr2: [T]) -> [T] {
    return zip(arr1, arr2).map { (tuple: (T, T)) -> T in
        return tuple.0 + tuple.1
    }
}

func vectorSubtract<T: Subtractable>(arr1: [T], arr2: [T]) -> [T] {
    return zip(arr1, arr2).map { (tuple: (T, T)) -> T in
        return tuple.0 - tuple.1
    }
}

func vectorSum<T: Addable>(vectors: [[T]]) -> [T] {
    return vectors[1..<vectors.count].reduce(vectors[0]) {
        vectorAdd($0, $1)
    }
}

func vectorComponentwiseMultiply<T: Multiplyable>(arr1: [T], arr2: [T]) -> [T] {
    return zip(arr1, arr2).map { (tuple: (T, T)) -> T in
        return tuple.0 * tuple.1
    }
}

func scalarMultiply<T: Multiplyable>(scalar: T, arr: [T]) -> [T] {
    return arr.map {
        return $0 * scalar
    }
}

//TODO: make the following functions generic
func vectorMean(vectors: [[Double]]) -> [Double] {
    let n = Double(vectors.count)
    return scalarMultiply(1.0/n, vectorSum(vectors))
}

func dot(arr1: [Double], arr2: [Double]) -> Double {
    let multiplied = vectorComponentwiseMultiply(arr1, arr2)
    return multiplied.reduce(0.0) {
        return $0 + $1
    }
}

func sumOfSquares(vector: [Double]) -> Double {
    return dot(vector, vector)
}

func magnitude(vector: [Double]) -> Double {
    return sqrt(sumOfSquares(vector))
}

func squaredDistance(arr1: [Double], arr2: [Double]) -> Double {
    return sumOfSquares(vectorSubtract(arr1, arr2))
}

func distance(arr1: [Double], arr2: [Double]) -> Double {
    return sqrt(squaredDistance(arr1, arr2))
}


// MARK:- Convenience Infix Operators

func +<T: Addable>(lhs: [T], rhs: [T]) -> [T] { // 2
    return vectorAdd(lhs, rhs)
}

func -<T: Subtractable>(lhs: [T], rhs: [T]) -> [T] { // 2
    return vectorSubtract(lhs, rhs)
}

func *<T: Multiplyable>(lhs: [T], rhs: [T]) -> [T] {
    return vectorComponentwiseMultiply(lhs, rhs)
}

func *<T: Multiplyable>(lhs: T, rhs: [T]) -> [T] {
    return scalarMultiply(lhs, rhs)
}
func *<T: Multiplyable>(lhs: [T], rhs: T) -> [T] {
    return scalarMultiply(rhs, lhs)
}


