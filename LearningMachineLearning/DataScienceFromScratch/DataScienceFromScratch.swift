//
//  DataScienceFromScratch.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/23/15.
//

import UIKit

class DataScienceFromScratch: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chart = HackChartView(frame: view.frame)
        chart.pointSize = 3
        chart.setUpChartWithFunction(view.frame, xAxisLabel: "x", yAxisLabel: "y", minX: 0, maxX: 100) { (x: Double) -> Double in
            return normalCdf(x, mu: 50.0, sigma: 10.0)
        }
        
        chart.addNewLayerWithFunction(UIColor.grayColor()) {  normalCdf($0, mu: 50.0, sigma: 15.0) }
        
        chart.addNewLayerWithFunction(UIColor.greenColor()) { normalCdf($0, mu: 50.0, sigma: 20.0) }
        
        chart.addNewLayerWithFunction(UIColor.blueColor()) { normalCdf($0, mu: 50.0, sigma: 8.0) }
        
        view.addSubview(chart)
    }
    

    
    
    func doTheThing() {

        var a = [Double]()
        for i in 0..<100 {
            a.append(Double(i))
        }
        println(a)
        
        let stdv = standardDeviation(a)
        println(stdv)

        
    }
}
