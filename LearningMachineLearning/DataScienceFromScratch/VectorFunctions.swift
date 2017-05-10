//
//  VectorFunctions.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/24/15.
//

import Foundation

func vectorAdd<T: CanUseOperators>(_ arr1: [T], _ arr2: [T]) -> [T] {
    return zip(arr1, arr2).map { (tuple: (T, T)) -> T in
        return tuple.0 + tuple.1
    }
}

func vectorSubtract<T: CanUseOperators>(_ arr1: [T], _ arr2: [T]) -> [T] {
    return zip(arr1, arr2).map { (tuple: (T, T)) -> T in
        return tuple.0 - tuple.1
    }
}

func sum<T: CanUseOperators>(_ vector: [T]) -> T {
    return vector[1..<vector.count].reduce(vector[0]) {
        $0 + $1
    }
}

func vectorSum<T: CanUseOperators>(_ vectors: [[T]]) -> [T] {
    return vectors[1..<vectors.count].reduce(vectors[0]) {
        vectorAdd($0, $1)
    }
}

func vectorComponentwiseMultiply<T: CanUseOperators>(_ arr1: [T], _ arr2: [T]) -> [T] {
    return zip(arr1, arr2).map { (tuple: (T, T)) -> T in
        return tuple.0 * tuple.1
    }
}

func scalarMultiply<T: CanUseOperators>(_ scalar: T, _ arr: [T]) -> [T] {
    return arr.map {
        return $0 * scalar
    }
}

func vectorMean<T: CanUseOperators>(_ vectors: [[T]]) -> [Double] {
    let n = Double(vectors.count)
    let sum = vectorSum(vectors)
    let sumAsDoubles = sum.map {
        $0.toDouble()
    }
    return scalarMultiply(1.0/n, sumAsDoubles)
}

func dot<T: CanUseOperators>(_ arr1: [T], _ arr2: [T]) -> T {
    let multiplied = vectorComponentwiseMultiply(arr1, arr2)
    return multiplied[1..<multiplied.count].reduce(multiplied[0]) {
        return $0 + $1
    }
}

func sumOfSquares<T: CanUseOperators>(_ vector: [T]) -> T {
    return dot(vector, vector)
}

func magnitude<T: CanUseOperators>(_ vector: [T]) -> Double {
    let vectorAsDoubles = vector.map {
        $0.toDouble()
    }
    return sqrt(sumOfSquares(vectorAsDoubles))
}

func squaredDistance<T: CanUseOperators>(_ arr1: [T], _ arr2: [T]) -> T {
    return sumOfSquares(vectorSubtract(arr1, arr2))
}

func distance<T: CanUseOperators>(_ arr1: [T], _ arr2: [T]) -> Double {
    let squaredDist = squaredDistance(arr1, arr2)
    return sqrt(squaredDist.toDouble())
}


// MARK:- Convenience Infix Operators

func +<T: CanUseOperators>(lhs: [T], rhs: [T]) -> [T] { // 2
    return vectorAdd(lhs, rhs)
}

func -<T: CanUseOperators>(lhs: [T], rhs: [T]) -> [T] { // 2
    return vectorSubtract(lhs, rhs)
}

func *<T: CanUseOperators>(lhs: [T], rhs: [T]) -> [T] {
    return vectorComponentwiseMultiply(lhs, rhs)
}

func *<T: CanUseOperators>(lhs: T, rhs: [T]) -> [T] {
    return scalarMultiply(lhs, rhs)
}
func *<T: CanUseOperators>(lhs: [T], rhs: T) -> [T] {
    return scalarMultiply(rhs, lhs)
}


