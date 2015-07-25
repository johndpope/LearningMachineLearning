//
//  GAChart.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/22/15.
//

import UIKit
import SwiftCharts

protocol ChartUpdate {
    func updateDisplay(#threshold: Double?, xWeight: Double?, yWeight: Double?, accuracy: Double?, iteration: Int?)
}

struct DisplayParam {
    let threshold: Double?
    let xWeight: Double?
    let yWeight: Double?
    let accuracy: Double?
    let iteration: Int?
}

class AnimatedChartView: UIView, ChartUpdate {
    private var lineChart: Chart?
    private var dataChart: Chart?
    private var minX, minY, maxX, maxY, xInterval, yInterval: Double!
    private var chartFrame: CGRect!
    
    var xAxisLabel: String!
    var yAxisLabel: String!
    
    var label: UILabel!

    func setUpChartWithData(data: [LabeledInput], frame: CGRect, xAxisLabel: String, yAxisLabel: String) {
        minX = Double(UINT32_MAX)
        minY = Double(UINT32_MAX)
        maxX = -Double(UINT32_MAX)
        maxY = -Double(UINT32_MAX)
        self.chartFrame = frame
        self.xAxisLabel = xAxisLabel
        self.yAxisLabel = yAxisLabel
        
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
        
        let xDiff = abs(maxX - minX)
        let yDiff = abs(maxY - minY)
        
        xInterval = xDiff/10
        yInterval = yDiff/8
        minX! -= xInterval!
        maxX! += xInterval!
        minY! -= yInterval!
        maxY! += yInterval!
        
        
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
        
        let layerSpecifications: [DataType : UIColor] = [
            .Type0 : UIColor.redColor(),
            .Type1 : UIColor.blueColor(),
            .Type2 : UIColor.greenColor()
        ]
        
        let (xAxis, yAxis, innerFrame) = baseChartLayers(labelSettings)
        
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
        self.dataChart = chart
        
        self.label = UILabel(frame: CGRectMake(frame.width * 5/6, frame.height * 1/6, 180, 100))
        self.label.numberOfLines = 0
        addSubview(self.label)
    }

    
    func updateLine(#x1: Double, y1: Double, x2: Double, y2: Double) {
        lineChart?.view.removeFromSuperview()
        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)

        let (xAxis, yAxis, innerFrame) = baseChartLayers(labelSettings)

        // line layer
        let lineChartPoints = [
            (x1, y1),
            (x2, y2)
        ]
        
        let chartPoints1 = lineChartPoints.map{ (tup: (Double, Double)) -> ChartPoint in
            return ChartPoint(x: ChartAxisValueFloat(CGFloat(tup.0), labelSettings: labelSettings), y: ChartAxisValueFloat(CGFloat(tup.1)))
        }
        let lineModel = ChartLineModel(chartPoints: chartPoints1, lineColor: UIColor.blackColor(), lineWidth: 2, animDuration: 0, animDelay: 0)
        let lineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel])
        
        lineChart = Chart(
            frame: chartFrame,
            layers: [
                lineLayer
                ]
        )
        
        addSubview(lineChart!.view)
    }
    
    private func baseChartLayers(labelSettings: ChartLabelSettings) -> (ChartAxisLayer, ChartAxisLayer, CGRect) {
        let xValues = Array(stride(from: minX, through: maxX, by: xInterval)).map {ChartAxisValueFloat(CGFloat($0), labelSettings: labelSettings)}
        let yValues = Array(stride(from: minY, through: maxY, by: yInterval)).map {ChartAxisValueFloat(CGFloat($0), labelSettings: labelSettings)}
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: xAxisLabel, settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: yAxisLabel, settings: labelSettings))
        
        let chartFrame = ExamplesDefaults.chartFrame(self.chartFrame)
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: ExamplesDefaults.chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        return (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
    }
    
    private func toLayers(models: [LabeledInput], layerSpecifications: [DataType : UIColor], xAxis: ChartAxisLayer, yAxis: ChartAxisLayer, chartInnerFrame: CGRect) -> [ChartLayer] {
        
        // group chartpoints by type
        let groupedChartPoints: Dictionary<DataType, [ChartPoint]> = models.reduce(Dictionary<DataType, [ChartPoint]>()) {(var dict, model) in
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
        let dim: CGFloat = Env.iPad ? 14 : 7
        let size = CGSizeMake(dim, dim)
        let layers: [ChartLayer] = map(groupedChartPoints) {(type, chartPoints) in
            let color = layerSpecifications[type]!
            return ChartPointsScatterCirclesLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: chartInnerFrame, chartPoints: chartPoints, itemSize: size, itemFillColor: color)
        }
        
        return layers
    }
    
    
    func updateLine(#xWeight: Double, yWeight: Double, threshold: Double) {
        let x1 = 0.0
        let y1 = threshold / yWeight
        
        let x2 = Double(maxX)
        let y2 = (threshold - xWeight * x2) / yWeight
        
        updateLine(x1: x1, y1: y1, x2: x2, y2: y2)
    }
    
    // MARK:- Chart Update Methods
    
    func updateDisplay(#threshold: Double?, xWeight: Double?, yWeight: Double?, accuracy: Double?, iteration: Int?) {
        let param = DisplayParam(threshold: threshold, xWeight: xWeight, yWeight: yWeight, accuracy: accuracy, iteration: iteration)
        displayParams.append(param)
    }
    
    // MARK:- Animation Properties and Methods
    var displayParams = [DisplayParam]()
    var timer: NSTimer?
    var animationIndex = 0
    var currentThreshold = 0.0
    var currentXWeight = 0.0
    var currentYWeight = 0.0
    var currentAccuracy = 0.0
    var currentIteration = 0
    
    func beginAnimatedDisplay(#duration: Double) {
        timer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: Selector("animateFrame"), userInfo: nil, repeats: true)
    }
    
    func animateFrame() {
        if animationIndex >= displayParams.count {
            println("animation done")
            timer?.invalidate()
        }
        else {
            let next = displayParams[animationIndex]
            animationIndex++
            currentThreshold = next.threshold ?? currentThreshold
            currentXWeight = next.xWeight ?? currentXWeight
            currentYWeight = next.yWeight ?? currentYWeight
            
            // if we only update the accuracy or iteration, update that and call again
            currentAccuracy = next.accuracy ?? currentAccuracy
            if next.threshold == nil && next.xWeight == nil && next.yWeight == nil {
                currentIteration = next.iteration ?? currentIteration
                animateFrame()
            }
            else {
                let formattedAccuracy = (currentAccuracy * 100).format("2.1")
                updateLine(xWeight: currentXWeight, yWeight: currentYWeight, threshold: currentThreshold)
            }
            updateLabel()
            
        }
    }
    
    private func updateLabel() {
        let formattedAccuracy = (currentAccuracy * 100).format("2.1")
        self.label.text = "Iteration \(currentIteration)\nAccuracy: \(formattedAccuracy)%"
    }
    

    
}





