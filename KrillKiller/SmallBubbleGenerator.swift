//
//  SmallBubbleGenerator.swift
//  KrillKiller
//
//  Created by Bradley Johnson on 9/11/14.
//  Copyright (c) 2014 CodeFellows. All rights reserved.
//

import Foundation
import SpriteKit

class SmallBubbleGenerator {
    var screenSize : CGSize
    var currentDepth = 0.0
    var ocean : SKSpriteNode
    
    init( ocean : SKSpriteNode, screenSize : CGSize) {
        self.ocean = ocean
        self.screenSize = screenSize
    }
    
    func spawnBubble() -> Void {
        
                    var bubble = SKSpriteNode(imageNamed: "bubble_01")
        
                    var distanceFromGround = 2000 - self.currentDepth
        
        
                    var highestBound = CGFloat(distanceFromGround) + (self.screenSize.height / 2)
                    var lowestBound = CGFloat(distanceFromGround) - (self.screenSize.height / 2)
        
                    var yCoord = CGFloat(arc4random() % UInt32(screenSize.width) - UInt32(lowestBound))
        
                    bubble.position = CGPoint(x: screenSize.width + 30, y: yCoord)
        
                    var mover = SKAction.moveByX(self.screenSize.width + 30, y: 0, duration: 0.1)
                    var remove = SKAction.runBlock({ () -> Void in
                        bubble.removeFromParent()
                    })
                    self.ocean.addChild(bubble)
                    var sequence = SKAction.sequence([mover,remove])
                    bubble.runAction(sequence)
    }
}
