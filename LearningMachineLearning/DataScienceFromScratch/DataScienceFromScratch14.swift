//
//  DataScienceFromScratch14.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/28/15.
//  Copyright © 2015 Grace Avery. All rights reserved.
//

import UIKit
import SwiftCharts

class DataScienceFromScratch14: UIViewController {
    var chart: FunctionChartView!
    let feature1Index = 0
    let feature2Index = 2
    let speciesIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chart = FunctionChartView(frame: view.frame)
        
        
        let data = labeledInputForIrisData(speciesIndex: speciesIndex, feature1Index: feature1Index, feature2Index: feature2Index)
        linearRegression(data)
    }

    func chartIrisData(data: [LabeledInput], xAxisLabel: String, yAxisLabel: String) {
        chart.paddingOptions = (ChartPadding.PadTop).union(ChartPadding.PadRight)
        chart.overrides.minX = 0.0
        chart.overrides.minY = 0.0
        chart.setUpChartWithData(data, frame: view.frame, xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
        view.addSubview(chart)
    }
    
    func labeledInputForIrisData(speciesIndex speciesIndex: Int, feature1Index: Int, feature2Index: Int) -> [LabeledInput] {
        let iris = IrisData()
        let dataAndLabels = zip(iris.data, iris.labels)
        let filtered = dataAndLabels.filter { return $1.type().rawValue == speciesIndex }
        let twoFeatures = filtered.map { (data: [Double], label: IrisType) -> LabeledInput in
            // i'm messing with the data here to better understand the math
            // remember to change this back
            ([data[feature1Index], data[feature2Index] * 4], label.type())
        }
        return twoFeatures
    }
    
    func linearRegression(data: [LabeledInput]) {
        let onlyData = data.map { $0.0 }
        let featureVectors = transpose(onlyData)
        
        let x = featureVectors[0]
        let y = featureVectors[1]
        
        let (alpha, beta) = LinearRegression.leastSquaresFit(x, y)
        print(alpha)
        print(beta)
        
        let stdvX = standardDeviation(x)
        let stdvY = standardDeviation(y)
        
        chart.overrides.xInterval = stdvX
        chart.overrides.yInterval = stdvY
        
        
        chart.overrides.xInterval = stdvY
        print("stdv x = \(stdvX)")
        print("stdv y = \(stdvY)")
        
        let proportion = stdvY / stdvX
        print("stdvx / stdvy = \(proportion)")
        chart.overrides.xMaxMultiplier = proportion
        
        chartIrisData(data, xAxisLabel: "x", yAxisLabel: "y")

        chart.addNewLayerWithFunction(UIColor.blackColor()) { (x: Double) -> Double in
            x * beta + alpha 
        }
    }
    
   

}
