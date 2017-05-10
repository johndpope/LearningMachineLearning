//
//  BaseChartView.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/26/15.
//  Copyright (c) 2015 Grace Avery. All rights reserved.
//

import UIKit
import SwiftCharts

struct ChartPadding : OptionSet {
    let rawValue: Int
    init(rawValue: Int) { self.rawValue = rawValue }
    
    static var PadNone: ChartPadding { return ChartPadding(rawValue: 0) }
    static var PadBottom: ChartPadding { return ChartPadding(rawValue: 1 << 0) }
    static var PadTop: ChartPadding { return ChartPadding(rawValue: 1 << 1) }
    static var PadLeft: ChartPadding { return ChartPadding(rawValue: 1 << 2) }
    static var PadRight: ChartPadding { return ChartPadding(rawValue: 1 << 3) }
    static var PadAll: ChartPadding { return ChartPadding(rawValue: 15) }
}

struct ChartOverrides {
    var minX, minY, maxX, maxY, xInterval, yInterval, xMaxMultiplier, yMaxMultiplier: Double?
}

class BaseChartView: UIView {
    var chartFrame: CGRect!
    var chart: Chart?
    var pointSize: Int?
    var minX, minY, maxX, maxY, xInterval, yInterval: Double!
    var overrides: ChartOverrides = ChartOverrides()
    var xAxisLabel: String!
    var yAxisLabel: String!
    var labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
    var paddingOptions = ChartPadding.PadNone
    
    let layerSpecifications: [DataType : UIColor] = [
        .type0 : UIColor.red,
        .type1 : UIColor.blue,
        .type2 : UIColor.green,
        .type3 : UIColor.yellow,
        .type4 : UIColor.purple,
        .type5 : UIColor.orange,
        .type6 : UIColor.black
    ]
    
    
    func setUpChartWithData(_ data: [LabeledInput], frame: CGRect, xAxisLabel: String, yAxisLabel: String) {
        setDataMinMaxInterval(data)
        
        self.xAxisLabel = xAxisLabel
        self.yAxisLabel = yAxisLabel

        let (xAxis, yAxis, innerFrame) = baseChartLayers(labelSettings, minX: minX, maxX: maxX, minY: minY, maxY: maxY, xInterval: xInterval, yInterval: yInterval, xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
        
        let scatterLayers = self.toLayers(data, layerSpecifications: layerSpecifications, xAxis: xAxis, yAxis: yAxis, chartInnerFrame: innerFrame)
        
        let guidelinesLayerSettings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth)
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

    func baseChartLayers(_ labelSettings: ChartLabelSettings, minX: Double, maxX: Double, minY: Double, maxY: Double, xInterval: Double, yInterval: Double, xAxisLabel: String, yAxisLabel: String) -> (ChartAxisLayer, ChartAxisLayer, CGRect) {
        let xValues = Array(stride(from: minX, through: maxX, by: xInterval)).map { ChartAxisValueFloat(CGFloat($0), labelSettings: labelSettings)}
        let yValues = Array(stride(from: minY, through: maxY, by: yInterval)).map {ChartAxisValueFloat(CGFloat($0), labelSettings: labelSettings)}
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: xAxisLabel, settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: yAxisLabel, settings: labelSettings.defaultVertical()))
        
        let chartFrame = ExamplesDefaults.chartFrame(self.chartFrame)
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: ExamplesDefaults.chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        return (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
    }
    
    func baseChartLayers(xAxisLabel: String, yAxisLabel: String) -> (ChartAxisLayer, ChartAxisLayer, CGRect) {
        return baseChartLayers(labelSettings, minX: minX, maxX: maxX, minY: minY, maxY: maxY, xInterval: xInterval, yInterval: yInterval, xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
    }
    
    func toLayers(_ models: [LabeledInput], layerSpecifications: [DataType : UIColor], xAxis: ChartAxisLayer, yAxis: ChartAxisLayer, chartInnerFrame: CGRect) -> [ChartLayer] {
        
        // group chartpoints by type
        let groupedChartPoints: Dictionary<DataType, [ChartPoint]> = models.reduce(Dictionary<DataType, [ChartPoint]>()) {(dict, model) in
            let points = model.0
            let type = model.1
            let x = CGFloat(points[0])
            let y = CGFloat(points[1])
            let chartPoint = ChartPoint(x: ChartAxisValueFloat(x), y: ChartAxisValueFloat(y))
            if dict[type] != nil {
                dict[type]!.append(chartPoint)
            } else {
                dict[type] = [chartPoint]
            }
            return dict
        }
        
        // create layer for each group
        var dim: CGFloat = Env.iPad ? 14 : 7
        if let d = pointSize {
            dim = CGFloat(d)
        }
        let size = CGSize(width: dim, height: dim)
        let layers: [ChartLayer] = groupedChartPoints.map {(type, chartPoints) in
            let color = layerSpecifications[type]!
            return ChartPointsScatterCirclesLayer(xAxis: xAxis as! ChartAxis, yAxis: yAxis as! ChartAxis, chartPoints: chartPoints, displayDelay: chartInnerFrame, itemSize: size, itemFillColor: color)
        }
        
        return layers
    }
    
    func setDataMinMaxInterval(_ data: [LabeledInput]) {
        chartFrame = frame
        var minX = Double(UINT32_MAX)
        var minY = Double(UINT32_MAX)
        var maxX = -Double(UINT32_MAX)
        var maxY = -Double(UINT32_MAX)
        
        for input in data {
            let x = input.0[0]
            let y = input.0[1]
            
            if x < minX {
                minX = x
            } else if x > maxX {
                maxX = x
            }
            if y < minY {
                minY = y
            } else if y > maxY {
                maxY = y
            }
        }
        
        if let overrideMinX = overrides.minX  {
            minX = overrideMinX
        }
        if let overrideMaxX = overrides.maxX {
            maxX = overrideMaxX
        }
        if let overrideMinY = overrides.minY {
            minY = overrideMinY
        }
        if let overrideMaxY = overrides.maxY {
            maxY = overrideMaxY
        }
        
        if let overrideXInterval = overrides.xInterval {
            xInterval = overrideXInterval
        }
        else {
            let xDiff = abs(maxX - minX)
            xInterval = xDiff/10
        }
        
        if let overrideYInterval = overrides.yInterval {
            yInterval = overrideYInterval
        }
        else {
            let yDiff = abs(maxY - minY)
            yInterval = yDiff/8
        }
        
        if let xMultiplier = overrides.xMaxMultiplier {
            maxX *= xMultiplier
        }
        if let yMultiplier = overrides.yMaxMultiplier {
            maxY *= yMultiplier
        }
        
        if paddingOptions.contains(.PadBottom) {
            minY -= yInterval
        }
        if paddingOptions.contains(.PadTop) {
            maxY += yInterval
        }
        
        if paddingOptions.contains(.PadLeft) {
            minX -= xInterval
        }
        if paddingOptions.contains(.PadRight) {
            maxX += xInterval
        }
        
        // the stride sometimes misses the top value if this is not included
        maxY += (yInterval / 5)
        maxX += (xInterval / 5)
     
        self.minX = minX
        self.minY = minY
        self.maxX = maxX
        self.maxY = maxY
    }
    
    

}
