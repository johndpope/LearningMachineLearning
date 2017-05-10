//
//  NaturalLanguageProcessing.swift
//  LearningMachineLearning
//
//  Created by Grace on 8/5/15.
//

import Foundation

class NaturalLanguageProcessing {
    func doTheThing() {
        if let wordString = textFromBundle("words") {
            var words = wordString.components(separatedBy: " ")
            let lower = words.map { $0.lowercased() }
            let counts = Counter(lower)
            print(counts.mostFrequent(50))
            
            words = clean(separatePeriodsFromWords(words))
            
            print(generateUsingTrigrams(words, numberOfSentences: 15))
        }
    }
    
    func bigram(_ words: [String]) -> [String : [String]] {
        let bigrams = zip(words, words[1..<words.count])
        var transitions = [String : [String]]()
        
        for (prev, current) in bigrams {
            if var value = transitions[prev] {
                value.append(current)
                transitions[prev] = value
            }
            else {
                transitions[prev] = [current]
            }
        }
        return transitions
    }
    
    func trigram(_ words: [String]) -> (transitions: [String : [String]], starts: [String]) {
        let trigrams = zip(words, Array(words[1..<words.count]), Array(words[2..<words.count]))
        var transitions = [String : [String]]()
        var starts = [String]()
        
        for (prev, current, next) in trigrams {
            if prev == "." {
                starts.append(current)
            }
            let key = keyFromTuple((prev, current))
            if var value = transitions[key] {
                value.append(next)
                transitions[key] = value
            }
            else {
                transitions[key] = [next]
            }
        }
        return (transitions, starts)
    }
    
    func keyFromTuple(_ tuple: (String, String)) -> String {
        return "\(tuple.0) \(tuple.1)"
    }
    
    func generateUsingBigrams(_ words: [String], numberOfSentences: Int = 1) -> String {
        let transitions = bigram(words)
        var current = "."
        var result = [String]()
        var n = 0
        
        while n < numberOfSentences {
            let nextWordCandidates = transitions[current]!
            current = nextWordCandidates.random()
            
            if current == "." {
                n += 1
                let last = result.removeLast()
                let newLast = last + "."
                result.append(newLast)
            }
            else {
                result.append(current)
            }
        }
        let space = " "
        return space.join(result)
    }
    
    func generateUsingTrigrams(_ words: [String], numberOfSentences: Int = 1) -> String {
        let (transitions, starts) = trigram(words)
        var current = starts.random()
        var prev = "."
        var result = [current]
        var n = 0
        
        while n < numberOfSentences {
            let key = keyFromTuple((prev, current))
            let nextWordCandidates = transitions[key]!
            prev = current
            current = nextWordCandidates.random()
            
            if current == "." {
                n += 1
                let last = result.removeLast()
                let newLast = last + "."
                result.append(newLast)
                
                if Int.randomIntBetween(0, 4) == 0 {
                    result.append("\n\n")
                }
            }
            else {
                result.append(current)
            }
        }
        let space = " \(result)"
        return space
    }
    
    func separatePeriodsFromWords(_ words: [String]) -> [String] {
        var words = words
        var insertionPoints = [Int]()
        for i in 0..<words.count {
            let word = words[i]
            if word.hasSuffix(".") {
                let justWord = word.substring(to: word.characters.index(before: word.endIndex))
                words[i] = justWord
                insertionPoints.append(i)
            }
        }
        
        for i in 0..<insertionPoints.count {
            let index = insertionPoints[i] + i + 1
            words.insert(".", at: index)
        }
        
        return words
    }
    
    func clean(_ words: [String]) -> [String] {
        var words = words
        var dashedWords = [(Int, String)]()
        for i in 0..<words.count {
            let word = words[i]
            if word.hasSuffix(")") || word.hasSuffix("]") || word.hasSuffix("\"") || word.hasSuffix("\'") || word.hasSuffix("!") {
                let justWord = word.substring(to: word.characters.index(before: word.endIndex))
                words[i] = justWord
            }
            if word.hasPrefix("(") || word.hasPrefix("[") || word.hasPrefix("\"") || word.hasPrefix("\'") {
                let justWord = word.substring(from: word.characters.index(after: word.startIndex))
                words[i] = justWord
            }
            if word == "-" {
                words[i] = "--"
            }
            else if word.range(of: "-") != nil || word.range(of: "—") != nil {
                dashedWords.append((i, word))
            }
        }
        
        for i in 0..<dashedWords.count {
            let (index, word) = dashedWords[i]
            var part1 = ""
            var part2 = ""
            var part3 = ""
            
            print("TODO FIX THIS CODE")
           /* if let range = word.range(of: "-") {
                part1 = word.substring(to: <#T##String.CharacterView corresponding to your index##String.CharacterView#>.index(before: range.upperBound))
                part2 = "-"
                part3 = word.substring(from: <#T##String.CharacterView corresponding to your index##String.CharacterView#>.index(after: range.lowerBound))
            }
            else if let range = word.range(of: "—") {
                part1 = word.substring(to: <#T##String.CharacterView corresponding to your index##String.CharacterView#>.index(before: range.upperBound))
                part2 = "—"
                part3 = word.substring(from: <#T##String.CharacterView corresponding to your index##String.CharacterView#>.index(after: range.lowerBound))
            }*/
            
            words[i + index] = part1
            words.insert(part2, at: i + index + 1)
            words.insert(part3, at: i + index + 2)
        }
        return words
    }
}






