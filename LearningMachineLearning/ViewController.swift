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
        
        //dataScienceFromScratch1()
        
        dataScienceFromScratch2()
    }
    
    func showPerceptron() {
        let perceptronVC = PerceptronViewController()
        view.addSubview(perceptronVC.view)
    }
    
    func karpathyTutorial() {
        KarpathyTutorial.doTheThing()
    }
    
    func dataScienceFromScratch1() {
        let dataScienceVC = DataScienceFromScratch1_7()
        view.addSubview(dataScienceVC.view)
    }
    
    func dataScienceFromScratch2() {
        let dataScienceVC = DataScienceFromScratch8()
        view.addSubview(dataScienceVC.view)
    }
   

}





