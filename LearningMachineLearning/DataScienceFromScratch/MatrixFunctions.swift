//
//  MatrixFunctions.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/24/15.
//

import Foundation

func shape<T>(matrix: [[T]]) -> (rows: Int, cols: Int) {
    let numRows = matrix.count
    let numCols = numRows > 0 ? matrix[0].count : 0
    return (numRows, numCols)
}

func getColumn<T>(matrix: [[T]], j: Int) -> [T] {
    return matrix.map { $0[j] }
}

func makeMatrix<T>(numRows: Int, numCols: Int, entryFunction: (i: Int, j: Int) -> T) -> [[T]] {
    var matrix = [[T]]()
    for i in 0..<numRows {
        var newRow = [T]()
        for j in 0..<numCols {
            let entry = entryFunction(i: i, j: j)
            newRow.append(entry)
        }
        matrix.append(newRow)
    }
    return matrix
}

func transpose<T>(matrix: [[T]]) -> [[T]] {
    let oldShape = shape(matrix)
    let newMatrix = makeMatrix(oldShape.cols, numCols: oldShape.rows) { (i, j) -> T in
        return matrix[j][i]
    }
    return newMatrix
}








