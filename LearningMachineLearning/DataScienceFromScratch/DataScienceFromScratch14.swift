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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let feature1Index = 0
        let feature2Index = 2
        let speciesIndex = 1
        
        let (data, xAxisLabel, yAxisLabel) = labeledInputForIrisData(speciesIndex: speciesIndex, feature1Index: feature1Index, feature2Index: feature2Index)
        
        chartIrisData(data, xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)

        linearRegression(data)
    }

    func chartIrisData(data: [LabeledInput], xAxisLabel: String, yAxisLabel: String) {
        chart = FunctionChartView(frame: view.frame)
        chart.paddingOptions = (ChartPadding.PadTop).union(ChartPadding.PadRight)
        chart.setUpChartWithData(data, frame: view.frame, xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel, xStart: 0.0, yStart: 0.0)
        view.addSubview(chart)
    }
    
    func labeledInputForIrisData(speciesIndex speciesIndex: Int, feature1Index: Int, feature2Index: Int) -> (data: [LabeledInput], xAxisLabel: String, yAxisLabel: String) {
        let iris = IrisData()
        let dataAndLabels = zip(iris.data, iris.labels)
        let filtered = dataAndLabels.filter { return $1.type().rawValue == speciesIndex }
        let twoFeatures = filtered.map { (data: [Double], label: IrisType) -> LabeledInput in
            ([data[feature1Index], data[feature2Index]], label.type())
        }
        return (twoFeatures, iris.attributes[feature1Index], iris.attributes[feature2Index])
    }
    
    func linearRegression(data: [LabeledInput]) {
        let onlyData = data.map { $0.0 }
        let featureVectors = transpose(onlyData)
        
        let (alpha, beta) = LinearRegression.leastSquaresFit(featureVectors[0], featureVectors[1])
        print(alpha)
        print(beta)
        
        
        chart.addNewLayerWithFunction(UIColor.blackColor()) { (x: Double) -> Double in
            x * beta + alpha 
        }

        
    }
    
   

}
