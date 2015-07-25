//
//  MatrixFunctions.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/24/15.
//  Copyright (c) 2015 Grace Avery. All rights reserved.
//

import Foundation

func shape<T>(matrix: [[T]]) -> (Int, Int) {
    let numRows = matrix.count
    let numCols = numRows > 0 ? matrix[0].count : 0
    return (numRows, numCols)
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










