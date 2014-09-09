//
//  WhaleNode.swift
//  KrillKiller
//
//  Created by Michael Tirenin on 9/9/14.
//  Copyright (c) 2014 CodeFellows. All rights reserved.
//

import UIKit
import SpriteKit

enum WhaleAngle {

    case Zero
    case SlightUp
    case SharpUp
    case SlightDown
    case SharpDown
}

class WhaleNode: SKSpriteNode {
    
    var angle : WhaleAngle = .Zero
   
}
