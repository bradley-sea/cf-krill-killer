//
//  SpawnController.swift
//  KrillKiller
//
//  Created by Dan Hoang on 9/10/14.
//  Copyright (c) 2014 CodeFellows. All rights reserved.
//

import UIKit
import SpriteKit

class SpawnController {
    let spawnArea : CGRect
    var frequency : Double
    var ocean : SKNode
    var deltaTime = 0.0
    var timeSinceLastSpawn = 0.0
    var nextFoodTime = 0.0
    var previousTime = 0.0
    var foodYDelta = 0.0
    
    init(spawnArea : CGRect, depthLevel : Int, frequency : Double, theOcean : SKSpriteNode) {
        self.spawnArea = spawnArea
        self.frequency = frequency
        self.ocean = theOcean
    }
    func update(currentTime: CFTimeInterval) {
        self.deltaTime = currentTime - self.previousTime
        self.previousTime = currentTime
        self.timeSinceLastSpawn += self.deltaTime
        
        if self.timeSinceLastSpawn > self.nextFoodTime {
            self.spawnFood()
            self.nextFoodTime = Double(arc4random() % 2000) / 1000
            self.timeSinceLastSpawn = 0
            print()
        }
    }
    func spawnFood() {
        
    }
}
