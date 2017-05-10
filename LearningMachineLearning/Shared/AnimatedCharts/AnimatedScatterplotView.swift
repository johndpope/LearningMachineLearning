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
    fileprivate var timer: Timer?
    fileprivate var animationIndex = 0
    var currentPlot: Chart!
    
    override func setUpChartWithData(_ data: [LabeledInput], frame: CGRect, xAxisLabel: String, yAxisLabel: String) {
        super.setUpChartWithData(data, frame: frame, xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
        addNewLayerWithData(data)
    }
    
    func beginAnimatedDisplay(duration: Double) {
        timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(AnimatedScatterplotView.animateFrame), userInfo: nil, repeats: true)
    }
    
    func animateFrame() {
        if animationIndex >= dataFrames.count {
            print("animation done")
            timer?.invalidate()
        }
        else {
            let frame = dataFrames[animationIndex]
            animationIndex += 1
            
            updateScatterPlot(frame)
        }
    }
    
    func updateScatterPlot(_ data: [LabeledInput]) {
        currentPlot.view.removeFromSuperview()
        
        addNewLayerWithData(data)
    }
    
    func addNewLayerWithData(_ data: [LabeledInput]) {
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
