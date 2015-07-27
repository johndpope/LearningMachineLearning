//
//  StaticChartView.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/26/15.
//  Copyright (c) 2015 Grace Avery. All rights reserved.
//

import UIKit
import SwiftCharts

class FunctionChartView: BaseChartView {
    var dataXMin, dataXMax: Double!
    var extraLayers = [Chart]()
    var pointInterval = 0.2
    
    func setUpChartWithFunction(frame: CGRect, xAxisLabel: String, yAxisLabel: String, minX: Double, maxX: Double, f: (Double) -> Double) {
        dataXMin = minX
        dataXMax = maxX
        let xPoints = Array(stride(from: minX, through: maxX, by: pointInterval))
        let data = xPoints.map { (x: Double) -> LabeledInput in
            let y = f(x)
            let input: LabeledInput = ([x, y], .Type0)
            return input
        }
        
        setUpChartWithData(data, frame: frame, xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
        addNewLayerWithFunction(UIColor.blackColor(), f: f)
    }
    
    func setUpChartWithData(data: [LabeledInput], frame: CGRect, xAxisLabel: String, yAxisLabel: String) {
        setDataMinMaxInterval(data)
        
        let (xAxis, yAxis, innerFrame) = baseChartLayers(xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
        
        let guidelinesLayerSettings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.blackColor(), linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: guidelinesLayerSettings)
        
        let chart = Chart(
            frame: chartFrame,
            layers: [
                xAxis,
                yAxis,
                guidelinesLayer,
                ]
        )
        
        addSubview(chart.view)
        self.chart = chart
    }
    
    func addNewLayerWithFunction(color: UIColor, f: (Double) -> Double) {
        let xPoints = Array(stride(from: dataXMin, through: dataXMax, by: pointInterval))
        let data = xPoints.map { (x: Double) -> ChartPoint in
            let y = f(x)
            return ChartPoint(x: ChartAxisValueFloat(CGFloat(x)), y: ChartAxisValueFloat(CGFloat(y)))
        }

        let (xAxis, yAxis, innerFrame) = baseChartLayers(labelSettings, minX: minX, maxX: maxX, minY: minY, maxY: maxY, xInterval: xInterval, yInterval: yInterval, xAxisLabel: "", yAxisLabel: "")
        
        let lineModel = ChartLineModel(chartPoints: data, lineColor: color, lineWidth: 2.0, animDuration: 0.0, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel])
        
        let chart = Chart(
            frame: chartFrame,
            layers: [chartPointsLineLayer]
        )
        
        addSubview(chart.view)
        self.extraLayers.append(chart)
    }
    
}






