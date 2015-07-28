//
//  ApartmentData.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/28/15.
//  Copyright © 2015 Grace Avery. All rights reserved.
//

import Foundation

struct Apartment {
    let lotsOfLight: Bool
    let bigKitchen: Bool
    let expensive: Bool
    let bigRooms: Bool
    
    func asDict() -> [String: Bool] {
        return ["lotsOfLight" : lotsOfLight,
            "bigKitchen" : bigKitchen,
            "expensive" : expensive,
            "bigRooms" : bigRooms]
    }
}

func getApartmentData() -> [(Apartment, Bool)] {
    var arr = [(Apartment, Bool)]()
    arr.append((Apartment(lotsOfLight: true, bigKitchen: true, expensive: true, bigRooms: true), true))
    arr.append((Apartment(lotsOfLight: true, bigKitchen: false, expensive: true, bigRooms: true), true))
    arr.append((Apartment(lotsOfLight: true, bigKitchen: false, expensive: false, bigRooms: true), true))
    arr.append((Apartment(lotsOfLight: true, bigKitchen: false, expensive: true, bigRooms: false), false))
    arr.append((Apartment(lotsOfLight: true, bigKitchen: false, expensive: false, bigRooms: false), true))
    arr.append((Apartment(lotsOfLight: true, bigKitchen: true, expensive: true, bigRooms: false), false))
    arr.append((Apartment(lotsOfLight: true, bigKitchen: false, expensive: false, bigRooms: false), true))
    arr.append((Apartment(lotsOfLight: false, bigKitchen: true, expensive: true, bigRooms: true), false))
    arr.append((Apartment(lotsOfLight: false, bigKitchen: true, expensive: false, bigRooms: false), false))
    arr.append((Apartment(lotsOfLight: false, bigKitchen: false, expensive: false, bigRooms: true), false))
    arr.append((Apartment(lotsOfLight: false, bigKitchen: false, expensive: true, bigRooms: false), false))
    return arr
}