//
//  AnimatedScatterplotView.swift
//  LearningMachineLearning
//
//  Created by Grace on 8/3/15.
//  Copyright © 2015 Grace Avery. All rights reserved.
//

import UIKit
import SwiftCharts

class AnimatedScatterplotView: BaseChartView {
    var dataFrames = [[LabeledInput]]()
    private var timer: NSTimer?
    private var animationIndex = 0
    var currentPlot: Chart!
    
    override func setUpChartWithData(data: [LabeledInput], frame: CGRect, xAxisLabel: String, yAxisLabel: String) {
        super.setUpChartWithData(data, frame: frame, xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
        addNewLayerWithData(data)
    }
    
    func beginAnimatedDisplay(duration duration: Double) {
        timer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: Selector("animateFrame"), userInfo: nil, repeats: true)
    }
    
    func animateFrame() {
        if animationIndex >= dataFrames.count {
            print("animation done")
            timer?.invalidate()
        }
        else {
            let frame = dataFrames[animationIndex]
            animationIndex++
            
            updateScatterPlot(frame)
        }
    }
    
    func updateScatterPlot(data: [LabeledInput]) {
        currentPlot.view.removeFromSuperview()
        
        addNewLayerWithData(data)
    }
    
    func addNewLayerWithData(data: [LabeledInput]) {
        let (xAxis, yAxis, innerFrame) = baseChartLayers(labelSettings, minX: minX, maxX: maxX, minY: minY, maxY: maxY, xInterval: xInterval, yInterval: yInterval, xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
        
        let scatterLayers = self.toLayers(data, layerSpecifications: layerSpecifications, xAxis: xAxis, yAxis: yAxis, chartInnerFrame: innerFrame)
        
        let chart = Chart(
            frame: chartFrame,
            layers: scatterLayers
        )
        
        addSubview(chart.view)
        self.currentPlot = chart
    }
    
}
