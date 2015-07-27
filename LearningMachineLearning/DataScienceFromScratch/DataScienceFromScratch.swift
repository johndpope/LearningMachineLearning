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
        
//        let chart = FunctionChartView(frame: view.frame)
//        chart.pointSize = 3
//        chart.setUpChartWithFunction(view.frame, xAxisLabel: "x", yAxisLabel: "y", minX: 0, maxX: 100) { (x: Double) -> Double in
//            return normalCdf(x, mu: 50.0, sigma: 10.0)
//        }
//        
//        //chart.addNewLayerWithFunction(UIColor.grayColor()) {  normalCdf($0, mu: 50.0, sigma: 15.0) }
//        
//        //chart.addNewLayerWithFunction(UIColor.greenColor()) { normalCdf($0, mu: 50.0, sigma: 20.0) }
//        
//        //chart.addNewLayerWithFunction(UIColor.blueColor()) { normalCdf($0, mu: 50.0, sigma: 10.0) }
//        
//        view.addSubview(chart)
//        
//        let a = inverseNormalCdf(0.5, mu: 50.0, sigma: 10.0)
//        println(a)
//        let b = inverseNormalCdf(0.1, mu: 50.0, sigma: 10.0)
//        println(b)
//        let c = inverseNormalCdf(0.9, mu: 50.0, sigma: 10.0)
//        println(c)

        
        makeHist(0.75, n: 100, numPoints: 10000)
        
        //hypothesisTesting()
    }
    
    func hypothesisTesting() {
        let approx = normalApproximationToBinomial(100, 0.75)

        let chart = FunctionChartView(frame: view.frame)
//        chart.pointSize = 3
        chart.setUpChartWithFunction(view.frame, xAxisLabel: "x", yAxisLabel: "y", minX: 0, maxX: 100) { (x: Double) -> Double in
            return normalCdf(x, mu: approx.mu, sigma: approx.sigma)
        }
        view.addSubview(chart)
        
    }
    
    
    func makeHist(p: Double, n: Int, numPoints: Int) {
        var data = [Int]()
        for _ in 0..<numPoints {
            let binom = binomial(n, p)
            println(binom)
            data.append(binom)
        }
        
        let counter = Counter(data)
        println(counter)
        
        var dataAsTuples = [(Double, Double)]()
        for (key, value) in counter.counts {
            dataAsTuples.append((Double(key), Double(Double(value)/Double(numPoints))))
        }

        let chart = BarChartView()
        chart.setUpChartWithData(dataAsTuples, frame: view.frame, xAxisLabel: "x", yAxisLabel: "y", color: UIColor.blueColor())
        view.addSubview(chart)
        
        
        let mu = p * Double(n)
        let sigma = sqrt(Double(n) * p * (1.0 - p))

        chart.addLineLayerWithFunction(UIColor.redColor()) { (x: Double) -> Double in
            normalCdf(x + 0.5, mu: mu, sigma: sigma) - normalCdf(x - 0.5, mu: mu, sigma: sigma)
        }
    }


}
