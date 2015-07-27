//
//  DataScienceFromScratch.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/23/15.
//

import UIKit
import Accelerate

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
        
        //hypothesisTesting()
        
        //confidenceIntervals()
        
        //pHacking()
        
        //abTesting()
        
        bayesianInference()
    }
    
    func bayesianInference() {
        // Does ios have a built-in gamma method?
        // This can't handle very big numbers
        func gamma(x: Int) -> Int {
            return factorial(x - 1)
        }
        
        func factorial(x: Int) -> Int {
            return x == 0 ? 1 : x * factorial(x - 1)
        }
        
        func B(alpha: Int, _ beta: Int) -> Double {
            // a normalizing constant so that the total probability is 1
            return Double(gamma(alpha) * gamma(beta)) /  Double(gamma(alpha + beta))
        }

        func betaPdf(x: Double, alpha: Int, beta: Int) -> Double {
            if x < 0.0 || x > 1.0 {
                return 0.0
            }
            let a = x ** Double(alpha - 1)
            let b = (1 - x) ** Double(beta - 1)
            
            let num = a * b / B(alpha, beta)
            return num
        }
        
        let x: vU1024 = vU1024()
        print(x)
        
        
        let a = factorial(10)
        let b = factorial(20)
        let c = factorial(30)
        
    
        
        let chart = FunctionChartView(frame: view.frame)
        chart.pointInterval = 0.005
        chart.setUpChartWithFunction(view.frame, xAxisLabel: "", yAxisLabel: "", minX: 0, maxX: 1) { (x: Double) -> Double in
            betaPdf(x, alpha: 55, beta: 45)
        }
        view.addSubview(chart)
        
        chart.addNewLayerWithFunction(UIColor.grayColor()) { betaPdf($0, alpha: 1, beta: 1) }
        chart.addNewLayerWithFunction(UIColor.greenColor()) { betaPdf($0, alpha: 4, beta: 16) }
        chart.addNewLayerWithFunction(UIColor.blueColor()) { betaPdf($0, alpha: 10, beta: 10) }
    }
    
    func abTesting() {
        
        func estimatedParameters(N: Int, n: Int) -> (p: Double, sigma: Double) {
            let p = Double(n) / Double(N)
            let sigma = sqrt(p * (1.0 - p) / Double(N))
            return (p, sigma)
        }
        
        func abTestStatistic(N_A: Int, n_A: Int, N_B: Int, n_B: Int) -> Double {
            let (p_A, sigma_A) = estimatedParameters(N_A, n: n_A)
            let (p_B, sigma_B) = estimatedParameters(N_B, n: n_B)
            return (p_B - p_A) / sqrt(sigma_A ** 2 + sigma_B ** 2)
        }
        
        let z = abTestStatistic(1000, n_A: 200, N_B: 1000, n_B: 150)
        print(z)
        
        let twoSidedpValue = twoSidedPValue(z)
        print(twoSidedpValue)
        
    }
    
    func pHacking() {
        // flip a coin 1000 times, true = heads, false = tails
        func runExperiment() -> [Bool] {
            let arr = Array(count: 1000, repeatedValue: false)
            return arr.map { _ in
                Double.randomZeroToOne() < 0.5
            }
        }
        
        func rejectFairness(experiment: [Bool]) -> Bool {
            let numHeads = experiment.reduce(0) { (var count, flipIsHeads) in
                if flipIsHeads {
                    count++
                }
                return count
            }
            print("num heads = \(numHeads)")
            // using 5% confidence intervals
            if numHeads < 469 || numHeads > 531 {
                print("---------------------")
            }
            return numHeads < 469 || numHeads > 531
        }
        
        
        // do a 1000 experiments (which each have 1000 trials)
        var experiments = [[Bool]]()
        for _ in 0..<1000 {
            experiments.append(runExperiment())
        }
        
        var rejectedExperiments = [[Bool]]()
        for experiment in experiments {
            if rejectFairness(experiment) {
                rejectedExperiments.append(experiment)
            }
        }
        
        let numRejections = rejectedExperiments.count
        print("number of rejected experiments = \(numRejections)")
        
        // these represent 'significant' results, even though they were from a fair coin
        // beware of dark arts statistics
        // 
        // http://www.nature.com/news/scientific-method-statistical-errors-1.14700
        // http://ist-socrates.berkeley.edu/~maccoun/PP279_Cohen1.pdf
        // http://slatestarcodex.com/2014/01/02/two-dark-side-statistics-papers/
        
        // Determine your hypotheses BEFORE looking at the data
        // Clean your data WITHOUT the hypotheses in mind
        // p-values are not substitutes for common sense
    }
    

    
    
    func confidenceIntervals() {
        
        // if we flipped a coin 1000 times, and saw 525 heads
        var pHat = 525.0 / 1000.0
        var mu = pHat
        var sigma = sqrt(pHat * (1 - pHat) / 1000.0)
        print(sigma)
        
        let a = normalTwoSidedBounds(0.95, mu: mu, sigma: sigma)
        // we are 95% confident the true p is between
        // (book says "This is not entirely justified, but people seem to do it anyway."
        print(a.lowerBound)
        print(a.upperBound)
        // 0.5 falls within the confidence interval, so we assume the coin is fair
        
        print("-----")
        
        // if instead we saw 540 heads
        pHat = 540.0 / 1000.0
        mu = pHat
        sigma = sqrt(pHat * (1 - pHat) / 1000.0)
        print(sigma)
        let b = normalTwoSidedBounds(0.95, mu: mu, sigma: sigma)
        print(b.lowerBound)
        print(b.upperBound)
        // the fair coin doesn't lie within the confidence interval
        
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
