//
//  GAChart.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/22/15.
//

import UIKit
import SwiftCharts

protocol ChartUpdate {
    func updateDisplay(threshold threshold: Double?, xWeight: Double?, yWeight: Double?, accuracy: Double?, iteration: Int?)
}

struct DisplayParam {
    let threshold: Double?
    let xWeight: Double?
    let yWeight: Double?
    let accuracy: Double?
    let iteration: Int?
}

class AnimatedChartView: BaseChartView, ChartUpdate {
    private var lineChart: Chart?
    
    var label: UILabel!

    override func setUpChartWithData(data: [LabeledInput], frame: CGRect, xAxisLabel: String, yAxisLabel: String, xStart: Double? = nil, xEnd: Double? = nil, yStart: Double? = nil, yEnd: Double? = nil) {
        super.setUpChartWithData(data, frame: frame, xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
        
        self.label = UILabel(frame: CGRectMake(frame.width * 5/6, frame.height * 1/6, 180, 100))
        self.label.numberOfLines = 0
        addSubview(self.label)
    }

    
    func updateLine(x1 x1: Double, y1: Double, x2: Double, y2: Double) {
        lineChart?.view.removeFromSuperview()
        let (xAxis, yAxis, innerFrame) = baseChartLayers(labelSettings)

        // line layer
        let lineChartPoints = [
            (x1, y1),
            (x2, y2)
        ]
        
        let chartPoints1 = lineChartPoints.map{ (tup: (Double, Double)) -> ChartPoint in
            return ChartPoint(x: ChartAxisValueFloat(CGFloat(tup.0), labelSettings: self.labelSettings), y: ChartAxisValueFloat(CGFloat(tup.1)))
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
        return baseChartLayers(labelSettings, minX: minX!, maxX: maxX!, minY: minY!, maxY: maxY!, xInterval: xInterval!, yInterval: yInterval!, xAxisLabel: xAxisLabel!, yAxisLabel: yAxisLabel!)
    }
    
    func updateLine(xWeight xWeight: Double, yWeight: Double, threshold: Double) {
        let x1 = 0.0
        let y1 = threshold / yWeight
        
        let x2 = Double(maxX)
        let y2 = (threshold - xWeight * x2) / yWeight
        
        updateLine(x1: x1, y1: y1, x2: x2, y2: y2)
    }
    
    // MARK:- Chart Update Methods
    
    func updateDisplay(threshold threshold: Double?, xWeight: Double?, yWeight: Double?, accuracy: Double?, iteration: Int?) {
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
    
    func beginAnimatedDisplay(duration duration: Double) {
        timer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: Selector("animateFrame"), userInfo: nil, repeats: true)
    }
    
    func animateFrame() {
        if animationIndex >= displayParams.count {
            print("animation done")
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





