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
//        print(a)
//        let b = inverseNormalCdf(0.1, mu: 50.0, sigma: 10.0)
//        print(b)
//        let c = inverseNormalCdf(0.9, mu: 50.0, sigma: 10.0)
//        print(c)

        
        //makeHist(0.75, n: 100, numPoints: 10000)
        
        hypothesisTesting()
    }
    
    func hypothesisTesting() {
        // we flip a coin 1000 times.
        // if it is a fair coin, x should be distributed approximately normally
        // with mean 500 and standard deviation 15.8
        let approx = normalApproximationToBinomial(1000, p: 0.5)

        print(approx.mu)
        print(approx.sigma)
        
        let chart = FunctionChartView(frame: view.frame)
        chart.setUpChartWithFunction(view.frame, xAxisLabel: "x", yAxisLabel: "y", minX: 400, maxX: 600) { (x: Double) -> Double in
            return normalCdf(x, mu: approx.mu, sigma: approx.sigma)
        }
        view.addSubview(chart)
        
        print("------")
        let (lo, hi) = normalTwoSidedBounds(0.95, mu: approx.mu, sigma: approx.sigma)
        print(lo)
        print(hi)
        print("------")
        
        let (mu2, sigma2) = normalApproximationToBinomial(1000, p: 0.55)
        
        // type 2 error is when you fail to reject the null hypothesis when it's wrong
        // eg we still think the coin is fair even though it is slightly biased
        var type2Probability = normalProbabilityBetween(lo: lo, hi: hi, mu: mu2, sigma: sigma2)
        print(type2Probability)
        var power = 1 - type2Probability
        print(power)
        print("------")
        
        // test if coin is NOT biased towards heads (ie biased towards tails is ok)
        // use one-sided test
        let hi2 = normalUpperBound(0.95, mu: approx.mu, sigma: approx.sigma)
        print(hi2)
        type2Probability = normalProbabilityBelow(hi2, mu: mu2, sigma: sigma2)
        power = 1 - type2Probability
        print(power)
        print("------")
        
        
        // probability (assuming null hypothesis true) that we would see a value
        // at least as extreme as 530
        let a = twoSidedPValue(529.5, mu: approx.mu, sigma: approx.sigma)
        print(a)
        
        var extremeValueCount = 0
        for _ in 0..<10000 {
            let numHeads = binomial(n: 1000, p: 0.5)
            if numHeads >= 530 || numHeads <= 470 {
                extremeValueCount++
            }
        }
        
        print("extremeValueCount = \(Double(extremeValueCount) / 10000.0)")
        
        // for one-sided test, if we saw 527 heads
        print(normalProbabilityAbove(526.5, mu: approx.mu, sigma: approx.sigma))
        // p is less than 0.05, so we'd reject the null hypothesis (ie we assume we have a biased coin)
        
        
        
        
    }
    
    
    
    func makeHist(p: Double, n: Int, numPoints: Int) {
        var data = [Int]()
        for _ in 0..<numPoints {
            let binom = binomial(n: n, p: p)
            print(binom)
            data.append(binom)
        }
        
        let counter = Counter(data)
        print(counter)
        
        var dataAsTuples = [(Double, Double)]()
        for (key, value) in counter.counts {
            dataAsTuples.append((Double(key), Double(Double(value)/Double(numPoints))))
        }

        let chart = BarChartView()
        chart.paddingOptions = .PadTop
        chart.setUpChartWithData(dataAsTuples, frame: view.frame, xAxisLabel: "x", yAxisLabel: "y", color: UIColor.blueColor())
        view.addSubview(chart)
        
        
        let mu = p * Double(n)
        let sigma = sqrt(Double(n) * p * (1.0 - p))

        chart.addLineLayerWithFunction(UIColor.redColor()) { (x: Double) -> Double in
            normalCdf(x + 0.5, mu: mu, sigma: sigma) - normalCdf(x - 0.5, mu: mu, sigma: sigma)
        }
    }


}
