//
//  SoundPlayController.swift
//  KrillKiller
//
//  Created by Dan Hoang on 9/11/14.
//  Copyright (c) 2014 CodeFellows. All rights reserved.
//

import UIKit
import SpriteKit

class SoundPlayManager {
    init() {
        
    }
    func playEatSound(whaleNode : SKNode) {
        var whaleEatNum = arc4random() % 10 + 1
        println(whaleEatNum)
        var sfx = SKAction.playSoundFileNamed("whaleeat_10.caf", waitForCompletion: false)
        if whaleEatNum == 10 {
            sfx = SKAction.playSoundFileNamed("whaleeat_10.caf", waitForCompletion: false)
        }
        else {
            sfx = SKAction.playSoundFileNamed("whaleeat_0\(whaleEatNum).caf", waitForCompletion: false)
        }
        whaleNode.runAction(sfx)
    }
}
