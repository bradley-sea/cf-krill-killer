//
//  FoodRandomizer.swift
//  KrillKiller
//
//  Created by Dan Hoang on 9/10/14.
//  Copyright (c) 2014 CodeFellows. All rights reserved.
//

import UIKit
import SpriteKit

class FoodRandomizer {
    
    init() {
        
    }
    
    func spawnRandom(depthLevel : Int) -> (String, String) {
        var name = "krill"
        var imageName = "krill"
        var foodNum = (arc4random() % 4)
        if depthLevel == 1 {
            switch foodNum {
            case 0:
                imageName = "fishsmall_01"
                name = "food"
            case 1:
                imageName = "fishsmall_02"
                name = "food"
            case 2:
                imageName = "fishsmall_03"
                name = "food"
            case 3:
                imageName = "krill"
                name = "food"
            default:
                print()
            }
        }
        else if depthLevel == 2 {
            switch foodNum {
            case 0:
                imageName = "fishmed_01"
                name = "food"
            case 1:
                imageName = "fishmed_02"
                name = "food"
            case 2:
                imageName = "fishmed_03"
                name = "food"
            case 3:
                imageName = "krill"
                name = "food"
            default:
                print()
            }
        }
        else {
            switch foodNum {
            case 0:
                imageName = "fishlarge_01"
                name = "food"
            case 1:
                imageName = "fishlarge_02"
                name = "food"
            case 2:
                imageName = "fishlarge_03"
                name = "food"
            case 3:
                imageName = "krill"
                name = "food"
            default:
                print()
            }
        }
        return (name, imageName)
    }
}