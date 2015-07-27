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

    func setUpChartWithData(data: [(Int, Int)], frame: CGRect, xAxisLabel: String, yAxisLabel: String, color: UIColor) {
        
        let dataAsLabeledInput = data.map { (tuple: (Int, Int)) -> LabeledInput in
            let input: LabeledInput = ([Double(tuple.0), Double(tuple.1)], .Type0)
            return input
        }
        setDataMinMaxInterval(dataAsLabeledInput)
        
        let zero = ChartAxisValueFloat(0)
        let bars: [ChartBarModel] = data.map { (index: Int, barModel: Int) -> ChartBarModel in
            return ChartBarModel(constant: ChartAxisValueFloat(CGFloat(index)), axisValue1: zero, axisValue2: ChartAxisValueFloat(CGFloat(barModel)), bgColor: color)
        }
        
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        
        let valAxisValues = Array(stride(from: 0, through: maxY, by: yInterval)).map{ (num: Double) -> ChartAxisValueFloat in
            return ChartAxisValueFloat(CGFloat(num))
        }
        let labelAxisValues = Array(stride(from: minX, through: maxX, by: xInterval)).map{ (num: Double) -> ChartAxisValueFloat in
            return ChartAxisValueFloat(CGFloat(num))
        }

        let (xValues: [ChartAxisValue], yValues: [ChartAxisValue]) = (labelAxisValues, valAxisValues)
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: xAxisLabel, settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: yAxisLabel, settings: labelSettings))
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: ExamplesDefaults.chartSettings, chartFrame: frame, xModel: xModel, yModel: yModel)
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
        let n = data.count
        let width = (innerFrame.width * 4/5) / CGFloat(n)
        
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
    
    
}
