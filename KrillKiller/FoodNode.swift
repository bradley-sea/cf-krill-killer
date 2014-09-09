//
//  FoodNode.swift
//  KrillKiller
//
//  Created by Michael Tirenin on 9/9/14.
//  Copyright (c) 2014 CodeFellows. All rights reserved.
//

import UIKit
import SpriteKit

class FoodNode: SKSpriteNode {
    
    var score : Int = 0
    
    var endPoint : CGPoint?
    var startPoint : CGPoint?
    
    var driftLowNearPoint : CGPoint?
    var driftLowFarPoint : CGPoint?
    var driftHighNearPoint : CGPoint?
    var driftHighFarPoint : CGPoint?
    
    var endPoints = [CGPoint]()

    func fillPointsArray() {
        self.endPoints = [self.startPoint!, self.driftLowNearPoint!, self.driftLowFarPoint!, self.driftHighNearPoint!, self.driftHighFarPoint!]
    }
    
}


