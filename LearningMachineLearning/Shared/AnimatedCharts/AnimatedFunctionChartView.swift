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
    fileprivate var timer: Timer?
    fileprivate var animationIndex = 0
    
    func beginAnimatedDisplay(duration: Double) {
        timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(AnimatedFunctionChartView.animateFrame), userInfo: nil, repeats: true)
    }
    
    func animateFrame() {
        if animationIndex >= functions.count {
            print("animation done")
            timer?.invalidate()
        }
        else {
            let f = functions[animationIndex]
            animationIndex += 1

            updateLine(f)
        }
    }
    
    func updateLine(_ f: (Double) -> Double) {
        for layer in extraLayers {
            layer.view.removeFromSuperview()
        }
        extraLayers.removeAll()

        addNewLayerWithFunction(UIColor.black, f: f)
    }
    
}
