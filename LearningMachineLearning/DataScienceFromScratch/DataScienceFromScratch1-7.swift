//
//  DataScienceFromScratch.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/23/15.
//

import UIKit

class DataScienceFromScratch1_7: UIViewController {
    
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
        
        bayesianInference2()
    }
    
    
    // This can't handle big numbers
    // try Accelerate framework if you need big numbers
    // http://cocoaconf.com/slides/chicago-2012/Accelerate.pdf
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
    
    func bayesianInference2() {
        var alpha = 3
        var beta = 4
        
        let chart = AnimatedFunctionChartView(frame: view.frame)
        chart.pointInterval = 0.005
        chart.paddingOptions = .PadTop
        chart.setUpChartWithFunction(view.frame, xAxisLabel: "", yAxisLabel: "", minX: 0, maxX: 1) { (x: Double) -> Double in
            self.betaPdf(x, alpha: alpha, beta: beta)
        }
        view.addSubview(chart)
        
        
        for _ in 0..<10 {
            
            // flip a  coin biased towards heads
            let rand = Double.randomZeroToOne()
            let heads = rand >= 0.1
            
            if heads {
                alpha += 1
            }
            else {
                beta += 1
            }
            
            print("alpha = \(alpha), beta = \(beta)")
            
            let a = alpha
            let b = beta
            
            let f: XToYFunc = { (x: Double) -> Double in
                return self.betaPdf(x, alpha: a, beta: b)
            }
            
            
            chart.functions.append(f)
        }
        
        chart.beginAnimatedDisplay(duration: 1.0)
        
    }
    
    func bayesianInference() {
        
        // chart the prior probabilities
        var alpha1 = 12
        var beta1 = 3
        
        var alpha2 = 8
        var beta2 = 2
        
        var alpha3 = 2
        var beta3 = 4
        
        let chart = FunctionChartView(frame: view.frame)
        chart.pointInterval = 0.005
        chart.setUpChartWithFunction(view.frame, xAxisLabel: "", yAxisLabel: "", minX: 0, maxX: 1) { (x: Double) -> Double in
            self.betaPdf(x, alpha: alpha1, beta: beta1)
        }
        view.addSubview(chart)
        
        chart.addNewLayerWithFunction(UIColor.blueColor()) { self.betaPdf($0, alpha: alpha2, beta: beta2) }
        
        chart.addNewLayerWithFunction(UIColor.blueColor()) { self.betaPdf($0, alpha: alpha2, beta: beta2) }
        
        chart.addNewLayerWithFunction(UIColor.orangeColor()) { self.betaPdf($0, alpha: alpha3, beta: beta3) }
        
        
        // now we flip a coin 5 times and only see 1 heads
        alpha1 += 1
        beta1 += 4
        
        alpha2 += 1
        beta2 += 4
        
        alpha3 += 1
        beta3 += 4
        
        chart.addNewLayerWithFunction(UIColor.grayColor()) { self.betaPdf($0, alpha: alpha1, beta: beta1) }
        
        chart.addNewLayerWithFunction(UIColor.greenColor()) { self.betaPdf($0, alpha: alpha2, beta: beta2) }
        
        chart.addNewLayerWithFunction(UIColor.redColor()) { self.betaPdf($0, alpha: alpha3, beta: beta3) }
        
        
        
        
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
