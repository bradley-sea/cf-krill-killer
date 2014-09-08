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
    var whale = SKSpriteNode(imageNamed: "newWhale")
    var currentYDirection : Double = 0.0
    var previousYDirection : Double!
    
    override func didMoveToView(view: SKView) {
        
        if let theSize = self.view?.bounds.size {
            self.scene?.size = theSize
        }
        else {
            //crash it:
            assert(1 == 2)
        }
        
        //add whale
        self.whale.position = CGPoint(x: 35, y: 150)
        self.addChild(self.whale)
        
        //set background to blue
        self.backgroundColor = UIColor(red: 51.0/255.0, green: 153.0/255.0, blue: 255.0/255.0, alpha: 0.3)
 
        self.setupMotionDetection()
    }
    
    func setupMotionDetection() {
        
        self.mManager.accelerometerUpdateInterval = 0.05
        self.mManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) { (accelerometerData : CMAccelerometerData!, error) in
            
            //keeping track of the devices orientation in relation to our gameplay. we will use this property in our update loop to figure out which way the wale should be pointing
            
            self.currentYDirection = accelerometerData.acceleration.y
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
   
        
        // sample of changing the background color as we go deeper
        //var alpha = CGColorGetAlpha(self.backgroundColor.CGColor)
        //            alpha = alpha + 0.002
        //            //set background to blue
        //            self.backgroundColor = UIColor(red: 51.0/255.0, green: 153.0/255.0, blue: 255.0/255.0, alpha: alpha)

        
        var newValue = self.translate(self.currentYDirection)
        //println(newValue)
        var newRadian : CGFloat = CGFloat(M_PI * newValue / 180.0)
        
        //var y = 1 + (self.currentYDirection - 45) * (.8-1)/ (-45-45)
        
        
      self.whale.zRotation = newRadian
        
        println(self.whale.zRotation)
    }
    
    //method used to take a our current motion value and translate it to degrees between -45 and 45
    func translate(value : Double) -> Double {
        
        var leftSpan = -0.7 - (0.7) //1.4
        var rightSpan = 45.0 - (-45.0) // 90
        
        //convert left range into a 0-1 range 
        var valueScale = (value - 0.7) / leftSpan
    
        return -45 + (valueScale * rightSpan)
        
        //at end of all, set this to previousYDirection:
        self.previousYDirection = self.currentYDirection
    }
}
