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
    let enemyCategory = 0x1 << 2
    
    let spawnArea : CGRect
    var frequency : Double
    var enemyFrequency : Double
    var ocean : SKNode
    var depthLevel : Int
    var deltaTime = 0.0
    var timeSinceLastSpawn = 0.0
    var timeSinceLastEnemy = 0.0
    var previousTime = 0.0
    var foodYDelta = 0.0
    
    var squidSpawned = 0
    
    init(spawnArea : CGRect, depthLevel : Int, frequency : Double, theOcean : SKSpriteNode) {
        self.spawnArea = spawnArea
        self.depthLevel = depthLevel
        self.frequency = frequency
        self.ocean = theOcean
        self.enemyFrequency = 3.0
    }
    func update(currentTime: CFTimeInterval) {
        
        //grab delta time
        self.deltaTime = currentTime - self.previousTime
        self.previousTime = currentTime
        self.timeSinceLastSpawn += self.deltaTime
        self.timeSinceLastEnemy += self.deltaTime
        
        //see if enough time has passed to spawn food
        if self.timeSinceLastSpawn > self.frequency {
            self.spawnFood()
            var powerupProbability = arc4random() % 3
            if powerupProbability == 1 {
                self.spawnPowerup()
            }
            self.timeSinceLastSpawn = 0
        }
        if self.timeSinceLastEnemy > self.enemyFrequency {
            self.spawnEnemy()
            self.timeSinceLastEnemy = 0
        }
    }
    func spawnFood() {
        
        var krill = FoodNode(depthLevel: self.depthLevel)
        krill.name = "krill"
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
        var remover = SKAction.runBlock { () -> Void in
            krill.removeFromParent()
        }
        
        var sequence = SKAction.sequence([mover,remover])
        
        krill.runAction(sequence, withKey: "mover")
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
        var remover = SKAction.runBlock { () -> Void in
            powerup.removeFromParent()
        }
        var sequence = SKAction.sequence([mover,remover])
        powerup.runAction(sequence)
    }
    
    func spawnEnemy() {
    
      var enemy = SKSpriteNode(imageNamed: "enemySquid")
        enemy.name = "enemy"
        
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = UInt32(enemyCategory)
        enemy.physicsBody!.contactTestBitMask = UInt32(whaleCategory)
        enemy.physicsBody!.collisionBitMask = 0
        
        var xCoord = CGFloat(arc4random() % UInt32(spawnArea.width) + UInt32(spawnArea.origin.x))
        var yCoord = CGFloat(arc4random() % UInt32(spawnArea.height) + UInt32(spawnArea.origin.y))
        
        //for now get middle of spawn area
        var midX = xCoord
        var midY = yCoord
        
        enemy.position = CGPoint(x: midX, y: midY)
        
        self.ocean.addChild(enemy)
        
        var firstMove = SKAction.moveTo(CGPoint(x: enemy.position.x - 300, y: enemy.position.y - 30), duration: 0.5)
        var firstWait = SKAction.moveTo(CGPoint(x: enemy.position.x - 300, y: enemy.position.y - 30), duration: 0.5)
        var secondMove = SKAction.moveTo(CGPoint(x: enemy.position.x - 600, y: enemy.position.y - 30), duration: 0.5)
        var secondWait = SKAction.moveTo(CGPoint(x: enemy.position.x - 600, y: enemy.position.y - 30), duration: 0.5)
        var thirdMove = SKAction.moveTo(CGPoint(x: enemy.position.x - 900, y: enemy.position.y - 30), duration: 0.5)
        var remover = SKAction.runBlock { () -> Void in
            enemy.removeFromParent()
        }
        
        var sequence = SKAction.sequence([firstMove,firstWait,secondMove,secondWait,thirdMove,remover])
        
        enemy.runAction(sequence)
        
         self.squidSpawned++
        
        if self.squidSpawned > 5 {
            
            self.spawnShark()
            self.squidSpawned = 0
        }
    }
    
    func spawnShark() {
        
        var enemy = SKSpriteNode(imageNamed: "Shark")
        enemy.name = "enemy"
        
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = UInt32(enemyCategory)
        enemy.physicsBody!.contactTestBitMask = UInt32(whaleCategory)
        enemy.physicsBody!.collisionBitMask = 0
        
        var xCoord = CGFloat(arc4random() % UInt32(spawnArea.width) + UInt32(spawnArea.origin.x))
        var yCoord = CGFloat(arc4random() % UInt32(spawnArea.height) + UInt32(spawnArea.origin.y))
        
        //for now get middle of spawn area
        var midX = xCoord
        var midY = yCoord
        
        enemy.position = CGPoint(x: midX, y: midY)
        
        self.ocean.addChild(enemy)
        
        var firstMove = SKAction.moveTo(CGPoint(x: enemy.position.x - 900, y: enemy.position.y - 30), duration: 2.0)
        
        var remover = SKAction.runBlock { () -> Void in
            enemy.removeFromParent()
        }
        
        var sequence = SKAction.sequence([firstMove,remover])

        
        enemy.runAction(sequence)

    }
}
