//
//  PerceptronViewController.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/23/15.
//

import UIKit
import SwiftCharts

class PerceptronViewController: UIViewController {
    var chart: AnimatedChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let data = chairsAndTablesData()
        //setUpChartWithData(data, xAxisLabel: "Furniture Width", yAxisLabel: "Furniture Height")
        
        let (data, xAxisLabel, yAxisLabel) = irisData(feature0: 0, feature1: 1)
        setUpChartWithData(data, xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
        
        trainPerceptronWithData(data)
        
        
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.startAnimating()
        }
    }
    
    func setUpChartWithData(data: [LabeledInput], xAxisLabel: String, yAxisLabel: String) {
        chart = AnimatedChartView(frame: view.frame)
        chart.setUpChartWithData(data, frame: view.frame, xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
        
        view.addSubview(chart)
    }
    
    func startAnimating() {
        chart.beginAnimatedDisplay(duration: 0.05)
    }
    
    func trainPerceptronWithData(data: [LabeledInput]) {
        let p = Perceptron(displayUpdater: chart)
        p.learn(data)
        
    }
    
    func chairsAndTablesData() -> [LabeledInput] {
        let chair = Furniture.Chair.type()
        let table = Furniture.Table.type()
        return [([1.0, 5.0], chair),
            ([2.0, 6.0], chair),
            ([1.5, 7.0], chair),
            ([1.0, 1.0], table),
            ([2.0, 2.5], table),
            ([1.5, 2.0], table)]
    }
    
    func irisData(#feature0: Int, feature1: Int) -> ([LabeledInput], String, String) {
        let iris = IrisData()
        var labeledInput = [LabeledInput]()
        
        for i in 0..<iris.data.count {
            let data = iris.data[i]
            let label = iris.labels[i]
            
            // only look at two species for now
            if label.type().rawValue == 2 {
                continue
            }
            
            let f0 = data[feature0]
            let f1 = data[feature1]
            
            let input = ([f0, f1], label.type())
            labeledInput.append(input)
        }
        
        return (labeledInput, iris.attributes[feature0], iris.attributes[feature1])
    }
    
    
}



