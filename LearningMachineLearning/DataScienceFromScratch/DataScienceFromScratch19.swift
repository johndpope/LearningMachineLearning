//
//  DataScienceFromScratch19.swift
//  LearningMachineLearning
//
//  Created by Grace on 8/3/15.
//

import UIKit

class DataScienceFromScratch19: UIViewController {
    var chart, chart2: AnimatedScatterplotView!
    var imageView: UIImageView!
    let feature1Index = 0
    let feature2Index = 2
    let speciesExcludeIndex = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        chart = AnimatedScatterplotView(frame: view.frame)
//        let labeledData = labeledInputForIrisData(speciesExcludeIndex: speciesExcludeIndex, feature1Index: feature1Index, feature2Index: feature2Index)
        
//        let iris = IrisData()
//        let data = labeledData.map { $0.0 }
        
//        let clusterer = KMeans(k: 5)
//        clusterer.train(data)
//        showAnimatedChartWithDifferentClustering(data, clusterer: clusterer, xAxisLabel: iris.attributes[feature1Index], yAxisLabel: iris.attributes[feature2Index])
//        let relabelledData = relabelData(data, assignments: clusterer.assignments)
//        chartIrisData(relabelledData, xAxisLabel: iris.attributes[feature1Index], yAxisLabel: iris.attributes[feature2Index])
        
        
        
        //showSquaredErrorsAsFunctionOfK(data)
        
        
        clusteringWithImages()
    }
    
    func clusteringWithImages() {
        let image = UIImage(named: "turtleOnFrogTiny2.jpg")!
        imageView = UIImageView(frame: view.frame)
        //imageView.contentMode = UIViewContentMode.Center
        imageView.image = image
        view.addSubview(imageView)
        
        
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            let clusterer = ImageClustering()
            let newImage = clusterer.posterize(image, k: 10)
            self.imageView.image = newImage
        }
    }
    
    func showSquaredErrorsAsFunctionOfK(data: [[Double]]) {
        let maxK = 40
        let clusterer = KMeans(k: 5)
        let errors = clusterer.trainWithDifferentKValues(data, maxK: maxK)
        
        let chart2 = FunctionChartView(frame: view.frame)
        chart2.overrides.xInterval = 1.0
        chart2.overrides.minY = 0.0
        chart2.setUpChartWithFunction(view.frame, xAxisLabel: "k", yAxisLabel: "total squared error", minX: 0.0, maxX: Double(maxK) - 1.0) { (x: Double) -> Double in
            let i = Int(x)
            return errors[i].1
        }
        view.addSubview(chart2)
    }
    
    func showAnimatedChartWithDifferentClustering(data: [[Double]], clusterer: KMeans, xAxisLabel: String, yAxisLabel: String) {
        let relabelledData = relabelData(data, assignments: clusterer.assignments)
        
        let allAssignments = clusterer.train(data, iterations: 50)
        var allAssignmentsLabeled = [[LabeledInput]]()
        
        for assignments in allAssignments {
            let relabelledData = relabelData(data, assignments: assignments)
            allAssignmentsLabeled.append(relabelledData)
        }
        
        // and we'll put the best one last
        allAssignmentsLabeled.append(relabelledData)
        
        chartIrisDataAnimated(allAssignmentsLabeled, xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
    }
    
    func relabelData(data: [[Double]], assignments: [Int]) -> [LabeledInput] {
        return zip(data, assignments).map { (point, assignment) -> LabeledInput in
            let dataType = DataType(rawValue: assignment)!
            return (point, dataType)
        }
    }
    
    func chartIrisData(data: [LabeledInput], xAxisLabel: String, yAxisLabel: String) {
        chart.paddingOptions = ChartPadding.PadAll
        chart.setUpChartWithData(data, frame: view.frame, xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
        view.addSubview(chart)
    }
    
    func chartIrisDataAnimated(data: [[LabeledInput]], xAxisLabel: String, yAxisLabel: String) {
        chart.paddingOptions = ChartPadding.PadAll
        chart.setUpChartWithData(data[0], frame: view.frame, xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
        chart.dataFrames = data
        view.addSubview(chart)
        
        chart.beginAnimatedDisplay(duration: 0.8)
    }
    
    func labeledInputForIrisData(speciesExcludeIndex speciesExcludeIndex: Int, feature1Index: Int, feature2Index: Int) -> [LabeledInput] {
        let iris = IrisData()
        let dataAndLabels = zip(iris.data, iris.labels)
        let filtered = dataAndLabels.filter { return $1.type().rawValue != speciesExcludeIndex }
        let twoFeatures = filtered.map { (data: [Double], label: IrisType) -> LabeledInput in
            ([data[feature1Index], data[feature2Index]], label.type())
        }
        return twoFeatures
    }
    
    
    

}
