//
//  BarChartView.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/26/15.
//  Copyright (c) 2015 Grace Avery. All rights reserved.
//

import UIKit
import SwiftCharts

class BarChartView: BaseChartView {
    var extraLayers = [Chart]()
    
    func setUpChartWithData(_ data: [(Double, Double)], frame: CGRect, xAxisLabel: String, yAxisLabel: String, color: UIColor) {
        
        let dataAsLabeledInput = data.map { (tuple: (Double, Double)) -> LabeledInput in
            let input: LabeledInput = ([tuple.0, tuple.1], .type0)
            return input
        }
        setDataMinMaxInterval(dataAsLabeledInput)
        
        let zero = ChartAxisValueFloat(0)
        let bars: [ChartBarModel] = data.map { (index: Double, barModel: Double) -> ChartBarModel in
            return ChartBarModel(constant: ChartAxisValueFloat(CGFloat(index)), axisValue1: zero, axisValue2: ChartAxisValueFloat(CGFloat(barModel)), bgColor: color)
        }
        
        chartFrame = frame

        let (xAxis, yAxis, innerFrame) = baseChartLayers(xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
        
        let n = data.count
        let width = (innerFrame.width * 3/4) / CGFloat(n)
        
        print("TODO FIX THIS CODE")
        /*
        let barsLayer = ChartBarsLayer(xAxis: xAxis as! ChartAxis, yAxis: yAxis as! ChartAxis, bars: bars, horizontal: false, barWidth: width, settings: innerFrame, mode: 0.0)
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
        
        let chart = Chart(
            frame: frame,
            layers: [
                xAxis,
                yAxis,
                guidelinesLayer,
                barsLayer
                ]
        )
        
        addSubview(chart.view)
        self.chart = chart*/
    }
    
    func addLineLayerWithFunction(_ color: UIColor, f: (Double) -> Double) {
        let xPoints = Array(stride(from: minX, through: maxX, by: 0.2))
        let data = xPoints.map { (x: Double) -> ChartPoint in
            let y = f(x)
            return ChartPoint(x: ChartAxisValueFloat(CGFloat(x)), y: ChartAxisValueFloat(CGFloat(y)))
        }
        
        let (xAxis, yAxis, innerFrame) = baseChartLayers(xAxisLabel: "", yAxisLabel: "")
        
        let lineModel = ChartLineModel(chartPoints: data, lineColor: color, lineWidth: 2.0, animDuration: 1.0, animDelay: 0.5)
        print("TODO FIX THIS CODE")
        /*
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis as! ChartAxis, yAxis: yAxis as! ChartAxis, lineModels: [lineModel], pathGenerator: innerFrame)
        
        let lineChart = Chart(
            frame: chartFrame,
            layers: [chartPointsLineLayer]
        )
        
        addSubview(lineChart.view)
        self.extraLayers.append(lineChart)*/
    }
    
    
}
