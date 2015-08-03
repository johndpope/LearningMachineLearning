//
//  DataScienceFromScratch19.swift
//  LearningMachineLearning
//
//  Created by Grace on 8/3/15.
//

import UIKit

class DataScienceFromScratch19: UIViewController {
    var chart: BaseChartView!
    let feature1Index = 0
    let feature2Index = 2
    let speciesExcludeIndex = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chart = BaseChartView(frame: view.frame)
        let labeledData = labeledInputForIrisData(speciesExcludeIndex: speciesExcludeIndex, feature1Index: feature1Index, feature2Index: feature2Index)
        
        let iris = IrisData()
        
        let data = labeledData.map { $0.0 }
        
        let clusterFinder = KMeans(k: 5)
        
        clusterFinder.train(data)
        
        
        let relabelledData = zip(data, clusterFinder.assignments).map { (point, assignment) -> LabeledInput in
            let dataType = DataType(rawValue: assignment)!
            return (point, dataType)
        }
        
        
        chartIrisData(relabelledData, xAxisLabel: iris.attributes[feature1Index], yAxisLabel: iris.attributes[feature2Index])
        

    }
    
    
    
    func chartIrisData(data: [LabeledInput], xAxisLabel: String, yAxisLabel: String) {
        chart.paddingOptions = ChartPadding.PadAll
        chart.setUpChartWithData(data, frame: view.frame, xAxisLabel: xAxisLabel, yAxisLabel: yAxisLabel)
        view.addSubview(chart)
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
