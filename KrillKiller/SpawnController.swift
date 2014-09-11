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
    //categories:
    let whaleCategory = 0x1 << 0
    let krillCategory = 0x1 << 1
    
    let spawnArea : CGRect
    var frequency : Double
    var ocean : SKNode
    var depthLevel : Int
    var deltaTime = 0.0
    var timeSinceLastSpawn = 0.0
    var previousTime = 0.0
    var foodYDelta = 0.0
    
    init(spawnArea : CGRect, depthLevel : Int, frequency : Double, theOcean : SKSpriteNode) {
        self.spawnArea = spawnArea
        self.depthLevel = depthLevel
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
            self.spawnPowerup()
            self.timeSinceLastSpawn = 0
        }
    }
    func spawnFood() {
        
        var krill = FoodNode(depthLevel: self.depthLevel)
//        krill.name = "food"
        krill.physicsBody = SKPhysicsBody(rectangleOfSize: krill.size)
        krill.physicsBody?.affectedByGravity = false
        krill.physicsBody?.categoryBitMask = UInt32(krillCategory)
        krill.physicsBody?.contactTestBitMask = UInt32(whaleCategory)
        krill.physicsBody?.collisionBitMask = 0
        
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
    
    func spawnPowerup() {
        var powerup = PowerupNode(depthLevel: self.depthLevel)
        powerup.physicsBody = SKPhysicsBody(rectangleOfSize: powerup.size)
        powerup.physicsBody?.affectedByGravity = false
        powerup.physicsBody?.categoryBitMask = UInt32(krillCategory)
        powerup.physicsBody?.contactTestBitMask = UInt32(whaleCategory)
        powerup.physicsBody?.collisionBitMask = 0
        
        var xCoord = CGFloat(arc4random() % UInt32(spawnArea.width) + UInt32(spawnArea.origin.x))
        var yCoord = CGFloat(arc4random() % UInt32(spawnArea.height) + UInt32(spawnArea.origin.y))
        
        //for now get middle of spawn area
        var midX = xCoord
        var midY = yCoord
        
        powerup.position = CGPoint(x: midX, y: midY)
        
        self.ocean.addChild(powerup)
        
        var mover = SKAction.moveTo(CGPoint(x: powerup.position.x - 800, y: powerup.position.y - 100), duration: 2.0)
        powerup.runAction(mover)
    }
}
