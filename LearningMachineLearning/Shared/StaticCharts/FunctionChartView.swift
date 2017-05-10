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
    
    override func setUpChartWithData(_ data: [LabeledInput], frame: CGRect, xAxisLabel: String, yAxisLabel: String) {
        super.setUpChartWithData(data, frame: frame, xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
        dataXMin = minX
        dataXMax = maxX
    }
    
    func setUpChartWithFunction(_ frame: CGRect, xAxisLabel: String, yAxisLabel: String, minX: Double, maxX: Double, f: (Double) -> Double) {
        dataXMin = minX
        dataXMax = maxX
        self.xAxisLabel = xAxisLabel
        self.yAxisLabel = yAxisLabel
        let xPoints = Array(stride(from: minX, through: maxX, by: pointInterval))
        let data = xPoints.map { (x: Double) -> LabeledInput in
            let y = f(x)
            let input: LabeledInput = ([x, y], .type0)
            return input
        }
        
        setUpChartWithLineData(data, frame: frame, xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
        addNewLayerWithFunction(UIColor.black, f: f)
    }
    
    func setUpChartWithLineData(_ data: [LabeledInput], frame: CGRect, xAxisLabel: String, yAxisLabel: String) {
        setDataMinMaxInterval(data)
        
        let (xAxis, yAxis, innerFrame) = baseChartLayers(xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
        
        let guidelinesLayerSettings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(yAxis: yAxis, xAxis: xAxis, innerFrame: innerFrame, settings: guidelinesLayerSettings)
        
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
    
    func addNewLayerWithFunction(_ color: UIColor, f: (Double) -> Double) {
        let xPoints = Array(stride(from: dataXMin, through: dataXMax, by: pointInterval))
        let data = xPoints.map { (x: Double) -> ChartPoint in
            let y = f(x)
            return ChartPoint(x: ChartAxisValueFloat(CGFloat(x)), y: ChartAxisValueFloat(CGFloat(y)))
        }

        let (xAxis, yAxis, innerFrame) = baseChartLayers(labelSettings, minX: minX, maxX: maxX, minY: minY, maxY: maxY, xInterval: xInterval, yInterval: yInterval, xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
        
        let lineModel = ChartLineModel(chartPoints: data, lineColor: color, lineWidth: 2.0, animDuration: 0.0, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, lineModels: [lineModel], innerFrame: innerFrame)
        
        let chart = Chart(
            frame: chartFrame,
            layers: [chartPointsLineLayer]
        )
        
        addSubview(chart.view)
        self.extraLayers.append(chart)
    }
    
}






