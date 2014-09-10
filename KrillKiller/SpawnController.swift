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
    var previousTime = 0.0
    var foodYDelta = 0.0
    
    init(spawnArea : CGRect, depthLevel : Int, frequency : Double, theOcean : SKSpriteNode) {
        self.spawnArea = spawnArea
        self.frequency = frequency
        self.ocean = theOcean
    }
    func update(currentTime: CFTimeInterval) {
        
        //grab delta time
        self.deltaTime = currentTime - self.previousTime
        self.previousTime = currentTime
        self.timeSinceLastSpawn += self.deltaTime
        
        //see if enough time has passed to spawn food
        if self.timeSinceLastSpawn > self.frequency {
            self.spawnFood()
            self.timeSinceLastSpawn = 0
        }
    }
    func spawnFood() {
        
        var krill = SKSpriteNode(imageNamed: "krill")
        
        var xCoord = CGFloat(arc4random() % UInt32(spawnArea.width) + UInt32(spawnArea.origin.x))
        var yCoord = CGFloat(arc4random() % UInt32(spawnArea.height) + UInt32(spawnArea.origin.y))
        
        //for now get middle of spawn area
        var midX = xCoord
        var midY = yCoord
        
        krill.position = CGPoint(x: midX, y: midY)
        
        self.ocean.addChild(krill)
        
        var mover = SKAction.moveTo(CGPoint(x: krill.position.x - 800, y: krill.position.y - 100), duration: 2.0)
        krill.runAction(mover)
    }
}
