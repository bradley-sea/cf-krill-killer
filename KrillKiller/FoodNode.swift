//
//  FoodNode.swift
//  KrillKiller
//
//  Created by Michael Tirenin on 9/9/14.
//  Copyright (c) 2014 CodeFellows. All rights reserved.
//

import UIKit
import SpriteKit

enum Food {
    case fishSmall1
    case fishSmall2
    case fishSmall3
    case fishMed1
    case fishMed2
    case fishMed3
    case fishLarge1
    case fishLarge2
    case fishLarge3
}

class FoodNode: SKSpriteNode {
    
    var score : Int = 0
    
    var endPoint : CGPoint?
    var startPoint : CGPoint?
    
    var driftLowNearPoint : CGPoint?
    var driftLowFarPoint : CGPoint?
    var driftHighNearPoint : CGPoint?
    var driftHighFarPoint : CGPoint?
    var foodType : Food!
    
    var endPoints = [CGPoint]()
    var imageName : String!
    
    init(depthLevel : Int) {
        var foodNum = (arc4random() % 4)
        var texture = SKTexture(imageNamed: "krill")
        var name = "krill"
        var imageName = "krill"
        var foodRandomizer = FoodRandomizer()
        (name, imageName) = foodRandomizer.spawnRandom(depthLevel)
        
        texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.name = name
        self.imageName = imageName
    }
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }

    func fillPointsArray() {
        self.endPoints = [self.endPoint!, self.driftLowNearPoint!, self.driftLowFarPoint!, self.driftHighNearPoint!, self.driftHighFarPoint!]
    }
    
}


