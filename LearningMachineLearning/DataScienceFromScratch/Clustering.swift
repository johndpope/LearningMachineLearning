//
//  Clustering.swift
//  LearningMachineLearning
//
//  Created by Grace on 8/3/15.
//

import UIKit

class KMeans {
    let k: Int
    var means: [[Double]]
    var assignments: [Int]

    
    init(k: Int) {
        self.k = k
        self.means = Array(count: k, repeatedValue: [0.0, 0.0])
        self.assignments = Array(count: k, repeatedValue: 0)
    }
    
    // return the index of the cluster closest to the input
    func classify(input: [Double]) -> Int {
        return minIndex(means) { (mean: [Double]) -> Double in
            squaredDistance(input, mean)
        }
    }
    
    func train(inputs: [[Double]]) {
        // choose k random points as the initial means
        means = inputs.sample(k)
        
        while true {
            let newAssignments = inputs.map { classify($0) }
            
            // if no assignments have changed, we're done
            if assignments == newAssignments {
                return
            }
            
            // otherwise keep the new assignements and compute new means based on the new assignments
            assignments = newAssignments
            for i in 0..<k {
                // find all points assigned to cluster i
                let filtered = zip(inputs, assignments).filter { $0.1 == i }
                let iPoints = filtered.map { $0.0 }
                
                // make sure iPoints is not empty, so we don't divide by zero
                if iPoints.count > 0 {
                    means[i] = vectorMean(iPoints)
                }
            }
        }
    }
    
    // how much does the initial sampling matter?
    func train(inputs: [[Double]], iterations: Int) -> [[Int]] {
        var bestAssignments = [Int]()
        var bestMeans = [[Double]]()
        var lowestError = Double(UINT32_MAX)
        var allAssignments = [[Int]]()
        
        for _ in 0..<iterations {
            train(inputs)
            allAssignments.append(assignments)
            let error = totalError(inputs)
            print("total error = \(error)")
            
            if error < lowestError {
                lowestError = error
                bestAssignments = assignments
                bestMeans = means
            }
        }
        
        print("lowest error = \(lowestError)")
        self.assignments = bestAssignments
        self.means = bestMeans
        return allAssignments
    }
    
    func totalError(inputs: [[Double]]) -> Double {
        let errors = zip(inputs, assignments).map { (input, cluster) -> Double in
            return squaredDistance(input, means[cluster])
        }
        return sum(errors)
    }
    
    func squaredClusteringErrors(inputs: [[Double]], k: Int) -> Double {
        let clusterer = KMeans(k: k)
        clusterer.train(inputs)
        return clusterer.totalError(inputs)
    }
    
    func trainWithDifferentKValues(inputs: [[Double]], maxK: Int) -> [(Int, Double)] {
        let max = maxK > inputs.count ? inputs.count : maxK
        let kValues = Array(1...max)
        
        let errors = kValues.map { ($0, squaredClusteringErrors(inputs, k: $0)) }
        return errors
    }

    
}


class ImageClustering {

    
    func posterize(image: UIImage, k: Int) -> UIImage {
        
        var pixels = getPixelsFromImage(image).map {
            $0.map {
                Double($0)
            }
        }
        
        let clusterer = KMeans(k: k)
        clusterer.train(pixels, initialMeans: nil)
        
        for i in 0..<pixels.count {
            let assignment = clusterer.assignments[i]
            let values = clusterer.means[assignment]
            pixels[i] = values
        }
        
        let newImage = imageFromArray(pixels, width: Int(image.size.width), height: Int(image.size.height))
        return newImage
    }
    
    func getPixelsFromImage(image: UIImage) -> [[UInt8]] {
        let imageRef = image.CGImage
        let width = CGImageGetWidth(imageRef)
        let height = CGImageGetHeight(imageRef)
        let colorspace = CGColorSpaceCreateDeviceRGB()
        
        let bytesPerRow = (4 * width)
        let bitsPerComponent = 8
        let pixels = UnsafeMutablePointer<UInt8>(malloc(width * height * 4))
        
        let bitmapInfo = CGBitmapInfo.ByteOrder32Big.rawValue | CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue).rawValue
        
        let context = CGBitmapContextCreate(pixels, width, height,
            bitsPerComponent, bytesPerRow, colorspace,
            bitmapInfo)
        
        CGContextDrawImage(context, CGRectMake(0, 0, CGFloat(width), CGFloat(height)), imageRef)
        
        var arr = [[UInt8]]()
        for var i=0; i < width*height*4; i+=4 {
            let red = pixels[i+0]
            let green = pixels[i+1]
            let blue = pixels[i+2]
            
            arr.append([red, green, blue])
        }
        return arr
    }
    

    
    func imageFromArray(pixelArray: [[Double]], width: Int, height: Int) -> UIImage {
        
        let colorspace = CGColorSpaceCreateDeviceRGB()
        var rawData = UnsafeMutablePointer<UInt8>(malloc(width * height * 4))
        
        let bytesPerRow = (4 * width)
        let bitsPerComponent = 8
        let bitmapInfo = CGBitmapInfo.ByteOrder32Big.rawValue | CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue).rawValue
        
        let context = CGBitmapContextCreate(rawData, width, height,
            bitsPerComponent, bytesPerRow, colorspace,
            bitmapInfo)
        
        var byteIndex = 0
        for pixel in pixelArray {
            let red = UInt8(pixel[0])
            let green = UInt8(pixel[1])
            let blue = UInt8(pixel[2])
            
            rawData[byteIndex] = red
            rawData[byteIndex+1] = green
            rawData[byteIndex+2] = blue
            rawData[byteIndex+3] = UInt8(255)
            
            byteIndex += 4
        }
        
        let newImage = CGBitmapContextCreateImage(context)
        let newUIImage = UIImage(CGImage: newImage!)
        
        return newUIImage
        
    }
    
}




