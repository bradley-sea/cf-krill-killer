//
//  PowerupNode.swift
//  KrillKiller
//
//  Created by Dan Hoang on 9/11/14.
//  Copyright (c) 2014 CodeFellows. All rights reserved.
//

import UIKit
import SpriteKit

class PowerupNode: SKSpriteNode {
    
    var imageName : String!
    
    init(depthLevel : Int) {
        var name = "bubble"
        var imageName = "bubble"
        var texture = SKTexture(imageNamed: "bubble_01")
        var foodRandomizer = FoodRandomizer()
        (name,imageName) = foodRandomizer.spawnRandomPowerup(depthLevel)
        texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.name = name
        self.imageName = imageName
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
}