//
//  DataScienceFromScratch14.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/28/15.
//  Copyright © 2015 Grace Avery. All rights reserved.
//

import UIKit
import SwiftCharts

class DataScienceFromScratch14: UIViewController {
    var chart: FunctionChartView!
    // for example with low correlation, put in 0, 3, 0
    // for example with higher correlation, put in 0, 2, 2  (or 0, 2, 1)
    let feature1Index = 0
    let feature2Index = 2
    let speciesIndex = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chart = FunctionChartView(frame: view.frame)
        
        
        let data = labeledInputForIrisData(speciesIndex: speciesIndex, feature1Index: feature1Index, feature2Index: feature2Index)
        linearRegression(data)
    }

    func chartIrisData(_ data: [LabeledInput], xAxisLabel: String, yAxisLabel: String) {
        //chart.paddingOptions = (ChartPadding.PadTop).union(ChartPadding.PadRight)
        chart.paddingOptions = ChartPadding.PadAll
        //chart.overrides.minX = 0.0
        //chart.overrides.minY = 0.0
        chart.setUpChartWithData(data, frame: view.frame, xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
        view.addSubview(chart)
    }
    
    func labeledInputForIrisData(speciesIndex: Int, feature1Index: Int, feature2Index: Int) -> [LabeledInput] {
        let iris = IrisData()
        let dataAndLabels = zip(iris.data, iris.labels)
        let filtered = dataAndLabels.filter { return $1.type().rawValue == speciesIndex }
        let twoFeatures = filtered.map { (data: [Double], label: IrisType) -> LabeledInput in
            // i'm messing with the data here (x * 2)
            // actual data doesn't matter right now, this is just for learning
            ([data[feature1Index] * 2, data[feature2Index]], label.type())
        }
        return twoFeatures
    }
    
    func linearRegression(_ data: [LabeledInput]) {
        let onlyData = data.map { $0.0 }
        let featureVectors = transpose(onlyData)
        
        let x = featureVectors[0]
        let y = featureVectors[1]
        
        let (alpha, beta) = LinearRegression.leastSquaresFit(x, y)
        
        
        let stdvX = standardDeviation(x)
        //let stdvY = standardDeviation(y)
        chart.overrides.xInterval = stdvX
        chart.overrides.yInterval = stdvX
        //let proportion = stdvX / stdvY
        //chart.overrides.yMaxMultiplier = proportion
        
        chartIrisData(data, xAxisLabel: "x", yAxisLabel: "y")

        chart.addNewLayerWithFunction(UIColor.black) { (x: Double) -> Double in
            x * beta + alpha 
        }
        
        
        print("Linear regression with gradient descent")
        
        let (alpha2, beta2) = LinearRegression.linearRegressionMinimizeStochastic(x, y: y)
        
        
        chart.addNewLayerWithFunction(UIColor.red) { (x: Double) -> Double in
            x * beta2 + alpha2
        }
        
        
        let (alpha3, beta3) = gradientDescent2(0.01, x: x, y: y)
        
        
        chart.addNewLayerWithFunction(UIColor.green) { (x: Double) -> Double in
            x * beta3 + alpha3
        }
        
        
        let theta = minimizeBatchSumOfSquaredErrors(x, y: y, theta_0: [4.0, 4.0])
        let alpha4 = theta[0]
        let beta4 = theta[1]
        
        
        chart.addNewLayerWithFunction(UIColor.blue) { (x: Double) -> Double in
            x * beta4 + alpha4
        }
        
        
        print("alpha1 = \(alpha)")
        print("beta1 = \(beta)\n")
        print("alpha2 = \(alpha2)")
        print("beta2 = \(beta2)\n")
        print("alpha3 = \(alpha3)")
        print("beta3 = \(beta3)\n")
        print("alpha4 = \(alpha4)")
        print("beta4 = \(beta4)\n")
        
        print("r squared for algebra model (black) = \(LinearRegression.rSquared(alpha, beta: beta, x: x, y: y))\n")
        
        print("r squared for stochastic model (red) = \(LinearRegression.rSquared(alpha2, beta: beta2, x: x, y: y))\n")
        
        print("r squared for batch model 1 (doesn't adjust h) (green) = \(LinearRegression.rSquared(alpha3, beta: beta3, x: x, y: y))\n")
        
        print("r squared for batch model 2 (adjusts h) (blue) = \(LinearRegression.rSquared(alpha4, beta: beta4, x: x, y: y))\n")
        
        // r squared with straight line at mean of y
        //LinearRegression.rSquared(mean(y), beta: 0.0, x: x, y: y)
        
        
    }
    
   

}
