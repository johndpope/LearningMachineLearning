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
        
        //karpathyTutorial()
        
        //showPerceptron()
        

        //let dataScienceVC = DataScienceFromScratch1_7()
        //let dataScienceVC = DataScienceFromScratch8()
        //let dataScienceVC = DataScienceFromScratch14()
        //let dataScienceVC = DataScienceFromScratch15()
        let dataScienceVC = DataScienceFromScratch19()
        //let dataScienceVC = DataScienceFromScratch20()
        
        view.addSubview(dataScienceVC.view)
    }
    
    func showPerceptron() {
        let perceptronVC = PerceptronViewController()
        view.addSubview(perceptronVC.view)
    }
    
    func karpathyTutorial() {
        KarpathyTutorial.doTheThing()
    }

}





