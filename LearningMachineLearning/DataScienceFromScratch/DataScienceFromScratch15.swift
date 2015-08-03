//
//  DataScienceFromScratch15.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/29/15.
//  Copyright © 2015 Grace Avery. All rights reserved.
//

import UIKit

class DataScienceFromScratch15: UIViewController {
    var chart: FunctionChartView!
    let feature1Index = 1
    let feature2Index = 2
    let speciesExcludeIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        chart = FunctionChartView(frame: view.frame)
        
        
        let data = labeledInputForIrisData(speciesExcludeIndex: speciesExcludeIndex, feature1Index: feature1Index, feature2Index: feature2Index)

        let iris = IrisData()
        chartIrisData(data, xAxisLabel: iris.attributes[feature1Index], yAxisLabel: iris.attributes[feature2Index])
    }

    func chartIrisData(data: [LabeledInput], xAxisLabel: String, yAxisLabel: String) {
        //chart.paddingOptions = (ChartPadding.PadTop).union(ChartPadding.PadRight)
        chart.paddingOptions = ChartPadding.PadAll
        //chart.overrides.minX = 0.0
        //chart.overrides.minY = 0.0
        chart.setUpChartWithData(data, frame: view.frame, xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
        view.addSubview(chart)
    }

    func labeledInputForIrisData(speciesExcludeIndex speciesExcludeIndex: Int, feature1Index: Int, feature2Index: Int) -> [LabeledInput] {
        let iris = IrisData()
        let dataAndLabels = zip(iris.data, iris.labels)
        let filtered = dataAndLabels.filter { return $1.type().rawValue != speciesExcludeIndex }
        let twoFeatures = filtered.map { (data: [Double], label: IrisType) -> LabeledInput in
            // i'm messing with the data here (x * 2)
            // actual data doesn't matter right now, this is just for learning
            ([data[feature1Index] * 2, data[feature2Index]], label.type())
        }
        return twoFeatures
    }
    
    func estimateBeta(data: [LabeledInput]) {
        let onlyData = data.map { $0.0 }
        
        
    }
    
}








