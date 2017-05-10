//
//  MatrixFunctions.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/24/15.
//

import Foundation

func shape<T>(_ matrix: [[T]]) -> (rows: Int, cols: Int) {
    let numRows = matrix.count
    let numCols = numRows > 0 ? matrix[0].count : 0
    return (numRows, numCols)
}

func getColumn<T>(_ matrix: [[T]], j: Int) -> [T] {
    return matrix.map { $0[j] }
}

func makeMatrix<T>(_ numRows: Int, numCols: Int, entryFunction: (_ i: Int, _ j: Int) -> T) -> [[T]] {
    var matrix = [[T]]()
    for i in 0..<numRows {
        var newRow = [T]()
        for j in 0..<numCols {
            let entry = entryFunction(i, j)
            newRow.append(entry)
        }
        matrix.append(newRow)
    }
    return matrix
}

func transpose<T>(_ matrix: [[T]]) -> [[T]] {
    let oldShape = shape(matrix)
    return makeMatrix(oldShape.cols, numCols: oldShape.rows) { (i, j) -> T in
        matrix[j][i]
    }
}








