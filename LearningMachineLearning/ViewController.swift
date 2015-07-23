//
//  ViewController.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/22/15.
//

import UIKit
import SwiftCharts

class ViewController: UIViewController {
    var chart: AnimatedChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chairsAndTables: [LabeledInput] =
        [([1.0, 5.0], .Chair),
            ([2.0, 6.0], .Chair),
            ([1.5, 7.0], .Chair),
            ([1.0, 1.0], .Table),
            ([2.0, 2.5], .Table),
            ([1.5, 2.0], .Table)]
        
        setUpChartWithData(chairsAndTables)
        trainPerceptronWithData(chairsAndTables)
        

        let delay = 1.2 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.startAnimating()
        }
    }
    
    func setUpChartWithData(data: [LabeledInput]) {
        chart = AnimatedChartView(frame: view.frame)
        chart.setUpChartWithData(data, frame: view.frame, minX: 0, minY: 0, maxX: 5, maxY: 8, interval: 1)

        view.addSubview(chart)
    }
    
    func startAnimating() {
        chart.beginAnimatedDisplay(duration: 0.1)
    }

    func trainPerceptronWithData(data: [LabeledInput]) {
        let p = Perceptron(displayUpdater: chart)
        p.learn(data)

    }


}






