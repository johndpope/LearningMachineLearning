//
//  AnimatedFunctionChartView.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/27/15.
//  Copyright © 2015 Grace Avery. All rights reserved.
//

import UIKit
import SwiftCharts

typealias XToYFunc = (Double) -> Double

class AnimatedFunctionChartView: FunctionChartView {
    var functions = [XToYFunc]()
    private var timer: NSTimer?
    private var animationIndex = 0
    
    func beginAnimatedDisplay(duration duration: Double) {
        timer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector: Selector("animateFrame"), userInfo: nil, repeats: true)
    }
    
    func animateFrame() {
        if animationIndex >= functions.count {
            print("animation done")
            timer?.invalidate()
        }
        else {
            let f = functions[animationIndex]
            animationIndex++

            updateLine(f)
        }
    }
    
    func updateLine(f: (Double) -> Double) {
        for layer in extraLayers {
            layer.view.removeFromSuperview()
        }
        extraLayers.removeAll()

        addNewLayerWithFunction(UIColor.blackColor(), f: f)
    }
    
}
