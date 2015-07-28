//
//  ApartmentData.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/28/15.
//  Copyright © 2015 Grace Avery. All rights reserved.
//

import Foundation

struct Apartment {
    static let keys = ["lotsOfLight", "bigKitchen", "expensive", "bigRooms", "roofDeck"]
    
    let lotsOfLight: Bool
    let bigKitchen: Bool
    let expensive: Bool
    let bigRooms: Bool
    let roofDeck: Bool
    
    subscript(key: String) -> Bool? {
        get {
            if key == "lotsOfLight" {
                return lotsOfLight
            } else if key == "bigKitchen" {
                return bigKitchen
            } else if key == "expensive" {
                return expensive
            } else if key == "bigRooms" {
                return bigRooms
            } else if key == "roofDeck" {
                return roofDeck
            }
            return nil
        }
    }
}

func getApartmentData() -> [(Apartment, Bool)] {
    var arr = [(Apartment, Bool)]()
    arr.append((Apartment(lotsOfLight: true, bigKitchen: true, expensive: true, bigRooms: true, roofDeck: true), true))
    arr.append((Apartment(lotsOfLight: true, bigKitchen: false, expensive: true, bigRooms: true, roofDeck: true), true))
    arr.append((Apartment(lotsOfLight: true, bigKitchen: false, expensive: false, bigRooms: true, roofDeck: true), true))
    arr.append((Apartment(lotsOfLight: true, bigKitchen: false, expensive: true, bigRooms: false, roofDeck: true), false))
    arr.append((Apartment(lotsOfLight: true, bigKitchen: false, expensive: false, bigRooms: false, roofDeck: true), true))
    arr.append((Apartment(lotsOfLight: true, bigKitchen: true, expensive: true, bigRooms: false, roofDeck: true), true))
    arr.append((Apartment(lotsOfLight: true, bigKitchen: false, expensive: false, bigRooms: false, roofDeck: true), true))
    arr.append((Apartment(lotsOfLight: false, bigKitchen: true, expensive: true, bigRooms: true, roofDeck: true), false))
    arr.append((Apartment(lotsOfLight: false, bigKitchen: true, expensive: false, bigRooms: false, roofDeck: true), false))
    arr.append((Apartment(lotsOfLight: false, bigKitchen: false, expensive: false, bigRooms: true, roofDeck: true), false))
    arr.append((Apartment(lotsOfLight: false, bigKitchen: false, expensive: true, bigRooms: false, roofDeck: true), false))
    arr.append((Apartment(lotsOfLight: true, bigKitchen: true, expensive: true, bigRooms: true, roofDeck: false), true))
    arr.append((Apartment(lotsOfLight: true, bigKitchen: false, expensive: true, bigRooms: true, roofDeck: false), true))
    arr.append((Apartment(lotsOfLight: true, bigKitchen: false, expensive: false, bigRooms: true, roofDeck: false), true))
    arr.append((Apartment(lotsOfLight: true, bigKitchen: false, expensive: true, bigRooms: false, roofDeck: false), false))
    arr.append((Apartment(lotsOfLight: true, bigKitchen: false, expensive: false, bigRooms: false, roofDeck: false), false))
    arr.append((Apartment(lotsOfLight: true, bigKitchen: true, expensive: true, bigRooms: false, roofDeck: false), false))
    arr.append((Apartment(lotsOfLight: true, bigKitchen: false, expensive: false, bigRooms: false, roofDeck: false), true))
    arr.append((Apartment(lotsOfLight: false, bigKitchen: true, expensive: true, bigRooms: true, roofDeck: false), false))
    arr.append((Apartment(lotsOfLight: false, bigKitchen: true, expensive: false, bigRooms: false, roofDeck: false), false))
    arr.append((Apartment(lotsOfLight: false, bigKitchen: false, expensive: false, bigRooms: true, roofDeck: false), false))
    arr.append((Apartment(lotsOfLight: false, bigKitchen: false, expensive: true, bigRooms: false, roofDeck: false), false))
    return arr
}