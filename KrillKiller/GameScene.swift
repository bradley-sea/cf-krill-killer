//
//  GameScene.swift
//  KrillKiller
//
//  Created by Bradley Johnson on 9/8/14.
//  Copyright (c) 2014 CodeFellows. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene {
    
    var mManager = CMMotionManager()
    var krill = SKSpriteNode(imageNamed: "krill")
    var whale = SKSpriteNode(imageNamed: "KillerWhale")
    var walePointingDown = false
    var walePointingUp = false
    var currentYDirection : Double = 0.0
    
    override func didMoveToView(view: SKView) {
        
        self.scene.size = self.view.bounds.size
        
        //add whale
        self.whale.position = CGPoint(x: 35, y: 150)
        self.addChild(self.whale)
        
        //add krill
        self.krill.position = CGPoint(x: self.size.width + -50, y: 150)
        
        self.addChild(self.krill)
        
        var mover = SKAction.moveToX(-100, duration: 10.0)
        self.krill.runAction(mover)
        
        
        //set background to blue
        self.backgroundColor = UIColor(red: 51.0/255.0, green: 153.0/255.0, blue: 255.0/255.0, alpha: 0.6)
        
        var alpha = CGColorGetAlpha(self.backgroundColor.CGColor)
        println(alpha)
        
        self.setupMotionDetection()
    }
    
    func setupMotionDetection() {
        
        self.mManager.accelerometerUpdateInterval = 0.05
        self.mManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) { (accelerometerData : CMAccelerometerData!, error) in
            
            self.currentYDirection = accelerometerData.acceleration.y
            
            println(accelerometerData.acceleration.y)
            
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            println(location)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        
        
        
        
        //test to see if we can smoothly move the krill even while an action is being run on them
        //self.krill.position = CGPoint(x: self.krill.position.x,y: self.krill.position.y + 0.5)
        
        if self.currentYDirection > 0.35 {
            
            println("going down!")
            
            //make color darker
            var alpha = CGColorGetAlpha(self.backgroundColor.CGColor)
            alpha = alpha - 0.002
            //set background to blue
            self.backgroundColor = UIColor(red: 51.0/255.0, green: 153.0/255.0, blue: 255.0/255.0, alpha: alpha)
            self.krill.position = CGPoint(x: self.krill.position.x,y: self.krill.position.y + 0.5)
            if !self.walePointingDown {
                self.walePointingDown = true
                var radian : CGFloat = CGFloat(M_PI * -25.0 / 180.0)
                let rotate = SKAction.rotateByAngle(radian, duration: 0.2)
                self.whale.runAction(rotate)
            }
            
        } else if self.currentYDirection < 0.35 && self.currentYDirection > 0 {
            
            //make color lighter
            
            if self.walePointingDown {
                self.walePointingDown = false
                var radian : CGFloat = CGFloat(M_PI * 25 / 180.0)
                let rotate = SKAction.rotateByAngle(radian, duration: 0.2)
                self.whale.runAction(rotate)
            }
            
            if self.walePointingUp {
                self.walePointingUp = false
                var radian : CGFloat = CGFloat(M_PI * -25 / 180.0)
                let rotate = SKAction.rotateByAngle(radian, duration: 0.2)
                self.whale.runAction(rotate)
            }
            
        } else if self.currentYDirection < -0.35 {
            println("going down")
            //make color darker
            var alpha = CGColorGetAlpha(self.backgroundColor.CGColor)
            alpha = alpha + 0.002
            //set background to blue
            self.backgroundColor = UIColor(red: 51.0/255.0, green: 153.0/255.0, blue: 255.0/255.0, alpha: alpha)
            self.krill.position = CGPoint(x: self.krill.position.x,y: self.krill.position.y - 0.5)
            if !self.walePointingUp {
                self.walePointingUp = true
                var radian : CGFloat = CGFloat(M_PI * 45.0 / 180.0)
                let rotate = SKAction.rotateByAngle(radian, duration: 0.2)
                self.whale.runAction(rotate)
            }
            
        }
        
        
        
    }
}
