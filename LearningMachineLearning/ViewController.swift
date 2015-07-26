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
        
        dataScienceFromScratch()
    }
    
    func showPerceptron() {
        let perceptronVC = PerceptronViewController()
        view.addSubview(perceptronVC.view)
    }
    
    func karpathyTutorial() {
        KarpathyTutorial.doTheThing()
    }
    
    func dataScienceFromScratch() {
        let dataScienceVC = DataScienceFromScratch()
        view.addSubview(dataScienceVC.view)
    }
   

}





