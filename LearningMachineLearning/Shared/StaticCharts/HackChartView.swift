//
//  StaticChartView.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/26/15.
//  Copyright (c) 2015 Grace Avery. All rights reserved.
//

import UIKit
import SwiftCharts

class HackChartView: BaseChartView {
    var dataXMin, dataXMax: Double!
    var extraLayers = [Chart]()
    
    // this is a hacky way to make chart show a function
    // if you can find some library like matplotlib for swift, that would be much better
    func setUpChartWithFunction(frame: CGRect, xAxisLabel: String, yAxisLabel: String, minX: Double, maxX: Double, f: (Double) -> Double) {
        dataXMin = minX
        dataXMax = maxX
        let xPoints = Array(stride(from: minX, through: maxX, by: 0.2))
        let data = xPoints.map { (x: Double) -> LabeledInput in
            let y = f(x)
            let input: LabeledInput = ([x, y], .Type0)
            return input
        }
        
        setUpChartWithData(data, frame: frame, xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
    }
    
    func setUpChartWithData(data: [LabeledInput], frame: CGRect, xAxisLabel: String, yAxisLabel: String) {
        setDataMinMaxInterval(data)
        
        let layerSpecifications: [DataType : UIColor] = [
            .Type0 : UIColor.blackColor()
        ]
        
        let (xAxis, yAxis, innerFrame) = baseChartLayers(labelSettings, minX: minX, maxX: maxX, minY: minY, maxY: maxY, xInterval: xInterval, yInterval: yInterval, xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
        
        let scatterLayers = self.toLayers(data, layerSpecifications: layerSpecifications, xAxis: xAxis, yAxis: yAxis, chartInnerFrame: innerFrame)
        
        let guidelinesLayerSettings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.blackColor(), linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: guidelinesLayerSettings)
        
        
        let chart = Chart(
            frame: chartFrame,
            layers: [
                xAxis,
                yAxis,
                guidelinesLayer,
                ] + scatterLayers
        )
        
        addSubview(chart.view)
        self.chart = chart
    }
    
    func addNewLayerWithFunction(color: UIColor, f: (Double) -> Double) {
        let xPoints = Array(stride(from: dataXMin, through: dataXMax, by: 0.2))
        let data = xPoints.map { (x: Double) -> LabeledInput in
            let y = f(x)
            return ([x, y], .Type0)
        }
        
        let layerSpecifications: [DataType : UIColor] = [
            .Type0 : color
        ]
        
        let (xAxis, yAxis, innerFrame) = baseChartLayers(labelSettings, minX: minX, maxX: maxX, minY: minY, maxY: maxY, xInterval: xInterval, yInterval: yInterval, xAxisLabel: "", yAxisLabel: "")
        
        let scatterLayers = self.toLayers(data, layerSpecifications: layerSpecifications, xAxis: xAxis, yAxis: yAxis, chartInnerFrame: innerFrame)
        
        
        let chart = Chart(
            frame: chartFrame,
            layers: scatterLayers
        )
        
        addSubview(chart.view)
        self.extraLayers.append(chart)
    }
    
}






