//
//  HelperFunctions.swift
//  LearningMachineLearning
//
//  Created by Grace on 8/5/15.
//

import Foundation

func textFromBundle(_ name: String) -> String? {
    let path = Bundle.main.path(forResource: name, ofType: "txt")
    
    do {
        let text = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        return text
    } catch {
        print("error getting data from bundle")
    }
    return nil
}
