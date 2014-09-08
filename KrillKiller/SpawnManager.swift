//
//  SpawnManager.swift
//  KrillKiller
//
//  Created by Dan Hoang on 9/8/14.
//  Copyright (c) 2014 CodeFellows. All rights reserved.
//

import UIKit

class SpawnManager {
    init() {
    }
    func randomSpawnPoint() -> CGPoint {
        var xCoord = CGFloat(arc4random() % 100) + 580
        var yCoord = CGFloat(arc4random() % 520) - 100
        println("Begin x: \(xCoord)")
        println("y: \(yCoord)")
        print()
        return CGPointMake(xCoord, yCoord)
    }
    func randomEndPoint() -> CGPoint {
        var xCoord = CGFloat(arc4random() % 50) - 100
        var yCoord = CGFloat(arc4random() % 520) - 100
        println("End x: \(xCoord)")
        println("y: \(yCoord)")
        return CGPointMake(xCoord, yCoord)
    }
}