//
//  ApartmentData.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/28/15.
//

import Foundation

protocol Subscriptable {
    subscript(key: String) -> String { get }
}

struct Apartment: Subscriptable {
    static let keys = ["lotsOfLight", "bigKitchen", "expensive", "bigRooms", "roofDeck"]
    
    let lotsOfLight: Bool
    let bigKitchen: Bool
    let expensive: Bool
    let bigRooms: Bool
    let roofDeck: Bool
    
    subscript(key: String) -> String {
        get {
            if key == "lotsOfLight" {
                return String(lotsOfLight)
            } else if key == "bigKitchen" {
                return String(bigKitchen)
            } else if key == "expensive" {
                return String(expensive)
            } else if key == "bigRooms" {
                return String(bigRooms)
            } else if key == "roofDeck" {
                return String(roofDeck)
            }
            return "None"
        }
    }
}

func getApartmentData() -> [(Subscriptable, Bool)] {
    // (Apartment, Bool = would i wanna live there)
    var arr = [(Subscriptable, Bool)]()
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
    arr.append((Apartment(lotsOfLight: true, bigKitchen: false, expensive: false, bigRooms: false, roofDeck: false), false))
    arr.append((Apartment(lotsOfLight: false, bigKitchen: true, expensive: true, bigRooms: true, roofDeck: false), false))
    arr.append((Apartment(lotsOfLight: false, bigKitchen: true, expensive: false, bigRooms: false, roofDeck: false), false))
    arr.append((Apartment(lotsOfLight: false, bigKitchen: false, expensive: false, bigRooms: true, roofDeck: false), false))
    arr.append((Apartment(lotsOfLight: false, bigKitchen: false, expensive: true, bigRooms: false, roofDeck: false), false))
    return arr
}


