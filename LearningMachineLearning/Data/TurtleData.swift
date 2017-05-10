//
//  TurtleData.swift
//  LearningMachineLearning
//
//  Created by Grace on 7/28/15.
//

import Foundation

func getTurtleData() ->  [(Subscriptable, Bool)] {
    var turtles = [(Subscriptable, Bool)]()
    turtles.append((makeTurtle(.Cm20, yellowStripesOnSkin: true, redSpotOnSidesOfHead: true, darkShell: false), false))
    turtles.append((makeTurtle(.Cm20, yellowStripesOnSkin: true, redSpotOnSidesOfHead: false, darkShell: true), false))
    turtles.append((makeTurtle(.Cm20, yellowStripesOnSkin: false, redSpotOnSidesOfHead: true, darkShell: true), false))
    turtles.append((makeTurtle(.Cm20, yellowStripesOnSkin: false, redSpotOnSidesOfHead: false, darkShell: false), false))
    turtles.append((makeTurtle(.Cm15, yellowStripesOnSkin: true, redSpotOnSidesOfHead: true, darkShell: false), true))
    turtles.append((makeTurtle(.Cm15, yellowStripesOnSkin: false, redSpotOnSidesOfHead: false, darkShell: false), false))
    turtles.append((makeTurtle(.Cm15, yellowStripesOnSkin: true, redSpotOnSidesOfHead: false, darkShell: false), false))
    turtles.append((makeTurtle(.Cm15, yellowStripesOnSkin: true, redSpotOnSidesOfHead: true, darkShell: true), true))
    turtles.append((makeTurtle(.Cm10, yellowStripesOnSkin: false, redSpotOnSidesOfHead: true, darkShell: true), false))
    turtles.append((makeTurtle(.Cm10, yellowStripesOnSkin: true, redSpotOnSidesOfHead: true, darkShell: false), true))
    turtles.append((makeTurtle(.Cm10, yellowStripesOnSkin: true, redSpotOnSidesOfHead: true, darkShell: true), true))
    turtles.append((makeTurtle(.Cm10, yellowStripesOnSkin: true, redSpotOnSidesOfHead: false, darkShell: true), true))
    turtles.append((makeTurtle(.Cm10, yellowStripesOnSkin: true, redSpotOnSidesOfHead: false, darkShell: false), false))
    turtles.append((makeTurtle(.Cm10, yellowStripesOnSkin: false, redSpotOnSidesOfHead: false, darkShell: true), false))
    turtles.append((makeTurtle(.Cm10, yellowStripesOnSkin: false, redSpotOnSidesOfHead: false, darkShell: false), false))
    turtles.append((makeTurtle(.Cm5, yellowStripesOnSkin: false, redSpotOnSidesOfHead: true, darkShell: false), false))
    turtles.append((makeTurtle(.Cm5, yellowStripesOnSkin: true, redSpotOnSidesOfHead: true, darkShell: false), true))
    turtles.append((makeTurtle(.Cm5, yellowStripesOnSkin: true, redSpotOnSidesOfHead: false, darkShell: false), false))
    turtles.append((makeTurtle(.Cm5, yellowStripesOnSkin: true, redSpotOnSidesOfHead: true, darkShell: true), true))
    turtles.append((makeTurtle(.Cm5, yellowStripesOnSkin: false, redSpotOnSidesOfHead: false, darkShell: true), false))
    return turtles
}

func makeTurtle(_ size: ShellSize, yellowStripesOnSkin: Bool, redSpotOnSidesOfHead: Bool, darkShell: Bool) -> Subscriptable {
    // Red Eared Sliders:
    // males are 10cm max, females 15cm max
    // old males have darker shells, and their ear color can fade
    // females ear color stays the same
    // yellow stripes never fade, but lots of other turtle species have yellow stripes
    // young RES turtles should always have bright red ears
    // basks should give no information.  most turtle species bask.
    // plastron can have a lot of yellow or a little yellow
    
    let darkPlastron = Double.randomZeroToOne() < 0.5
    let dict = ["size": size.rawValue,
        "yellowStripesOnSkin" : String(yellowStripesOnSkin),
        "redSpotOnSidesOfHead" : String(redSpotOnSidesOfHead),
        "darkShell" : String(darkShell),
        "basks" : String(true),
        "darkPlastron" : String(darkPlastron)]
    
    return Turtle(dict: dict)
}

enum ShellSize: String {
    case Cm20 = "20 centimeters"
    case Cm15 = "15 centimeters"
    case Cm10 = "10 centimeters"
    case Cm5 = "5 centimeters"
}

struct Turtle: Subscriptable {
    static let knownKeys = ["size", "yellowStripesOnSkin", "redSpotOnSidesOfHead", "darkShell", "basks"]
    let dict: [String: String]
    
    subscript(key: String) -> String {
        get {
            if let value = dict[key] {
                return value
            }
            return "None"
        }
    }
}

