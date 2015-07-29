//
//  DataScaping.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/28/15.
//

import Foundation

func scale(dataMatrix: [[Double]]) -> (means: [Double], standardDeviations: [Double]) {
    let (_, numCols) = shape(dataMatrix)
    var means = [Double]()
    var standardDeviations = [Double]()
    for j in 0..<numCols {
        let column = getColumn(dataMatrix, j: j)
        means.append(mean(column))
        standardDeviations.append(standardDeviation(column))
    }
    return (means: means, standardDeviations: standardDeviations)
}

// Rescales the input data so that each column has mean 0 and standard deviation 1
// Leaves alone columns with no deviation
func rescale(dataMatrix: [[Double]]) -> [[Double]] {
    
    let (means, standardDeviations) = scale(dataMatrix)
    
    func rescaled(i: Int, j: Int) -> Double {
        let orig = dataMatrix[i][j]
        if standardDeviations[j] > 0 {
            return (orig - means[j]) / standardDeviations[j]
        }
        else{
            return orig
        }
    }
    
    let (numRows, numCols) = shape(dataMatrix)
    return makeMatrix(numRows, numCols: numCols, entryFunction: rescaled)
}
















