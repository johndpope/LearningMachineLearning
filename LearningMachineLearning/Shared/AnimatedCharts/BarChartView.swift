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
    
    func setUpChartWithData(data: [(Double, Double)], frame: CGRect, xAxisLabel: String, yAxisLabel: String, color: UIColor) {
        
        let dataAsLabeledInput = data.map { (tuple: (Double, Double)) -> LabeledInput in
            let input: LabeledInput = ([tuple.0, tuple.1], .Type0)
            return input
        }
        setDataMinMaxInterval(dataAsLabeledInput)
        
        let zero = ChartAxisValueFloat(0)
        let bars: [ChartBarModel] = data.map { (index: Double, barModel: Double) -> ChartBarModel in
            return ChartBarModel(constant: ChartAxisValueFloat(CGFloat(index)), axisValue1: zero, axisValue2: ChartAxisValueFloat(CGFloat(barModel)), bgColor: color)
        }
        
        chartFrame = frame

        let (xAxis, yAxis, innerFrame) = barChartLayers(xAxisLabel, yAxisLabel: yAxisLabel)
        
        let n = data.count
        let width = (innerFrame.width * 3/4) / CGFloat(n)
        
        let barsLayer = ChartBarsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, bars: bars, horizontal: false, barWidth: width, animDuration: 0.0)
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.blackColor(), linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
        
        let view = ChartBaseView(frame: frame)
        
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
        self.chart = chart
    }
    
    func barChartLayers(xAxisLabel: String, yAxisLabel: String) -> (ChartAxisLayer, ChartAxisLayer, CGRect) {
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        
        let valAxisValues = Array(stride(from: 0, through: maxY, by: yInterval)).map{ (num: Double) -> ChartAxisValueFloat in
            return ChartAxisValueFloat(CGFloat(num))
        }
        let labelAxisValues = Array(stride(from: minX, through: maxX, by: xInterval)).map{ (num: Double) -> ChartAxisValueFloat in
            return ChartAxisValueFloat(CGFloat(num))
        }
        
        let (xValues, yValues) = (labelAxisValues, valAxisValues)
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: xAxisLabel, settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: yAxisLabel, settings: labelSettings))
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: ExamplesDefaults.chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        return (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
    }
    
    func addLineLayerWithFunction(color: UIColor, f: (Double) -> Double) {
        let xPoints = Array(stride(from: minX, through: maxX, by: 0.2))
        let data = xPoints.map { (x: Double) -> ChartPoint in
            let y = f(x)
            return ChartPoint(x: ChartAxisValueFloat(CGFloat(x)), y: ChartAxisValueFloat(CGFloat(y)))
        }
        
        let (xAxis, yAxis, innerFrame) = barChartLayers("", yAxisLabel: "")
        
        let lineModel = ChartLineModel(chartPoints: data, lineColor: color, lineWidth: 2.0, animDuration: 1.0, animDelay: 0.5)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel])
        
        let lineChart = Chart(
            frame: chartFrame,
            layers: [chartPointsLineLayer]
        )
        
        addSubview(lineChart.view)
        self.extraLayers.append(lineChart)
    }
    
    
}
