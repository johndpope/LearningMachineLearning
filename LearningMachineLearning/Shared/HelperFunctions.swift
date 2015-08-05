//
//  HelperFunctions.swift
//  LearningMachineLearning
//
//  Created by Grace on 8/5/15.
//

import Foundation

func textFromBundle(name: String) -> String? {
    let path = NSBundle.mainBundle().pathForResource(name, ofType: "txt")
    
    do {
        let text = try String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        return text
    } catch {
        print("error getting data from bundle")
    }
    return nil
}