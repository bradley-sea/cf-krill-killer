//
//  GameScene.swift
//  KrillKiller
//
//  Created by Bradley Johnson on 9/8/14.
//  Copyright (c) 2014 CodeFellows. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var mManager = CMMotionManager()
    var whale = SKSpriteNode(imageNamed: "newWhale")
    var currentYDirection : Double = 0.0
    var currentDepth = 100.0
    var depthLabel = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var pauseButton = SKSpriteNode(imageNamed: "pause.jpg")
    var currentScore = 0
    var spawnManager : SpawnManager!
    var skAction = SKAction()
    var deltaTime = 0.0
    var timeSinceLastFood = 0.0
    var nextFoodTime = 0.0
    var previousTime = 0.0
    var foodYDelta = 0.0
    
    //categories:
    let whaleCategory = 0x1 << 0
    let krillCategory = 0x1 << 1
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        if let theSize = self.view?.bounds.size {
            self.scene?.size = theSize
        }
        else {
            //crash it:
            assert(1 == 2)
        }
        //add whale
        self.whale.position = CGPoint(x: 35, y: 150)
        self.whale.physicsBody = SKPhysicsBody(rectangleOfSize: self.whale.size)
        self.whale.physicsBody?.affectedByGravity = false
        self.whale.name = "whale"
//        self.whale.physicsBody?.contactTestBitMask = 1
        self.whale.physicsBody?.categoryBitMask = UInt32(whaleCategory)
        self.whale.physicsBody?.contactTestBitMask = UInt32(krillCategory)
        self.whale.physicsBody?.collisionBitMask = 0
        self.addChild(self.whale)
        
        //set background to blue
        self.backgroundColor = UIColor(red: 51.0/255.0, green: 153.0/255.0, blue: 255.0/255.0, alpha: 0.3)
        
        //adding label to keep track of the current depth
        self.depthLabel.position = CGPoint(x: 500, y: 20)
        self.depthLabel.text = "\(self.currentDepth)"
        self.addChild(self.depthLabel)
        if let theScene = self.scene {
            self.scoreLabel.position = CGPoint(x: theScene.frame.width - 80, y: theScene.frame.height - 50)
            self.scoreLabel.text = "Score: \(self.currentScore)"
            self.addChild(self.scoreLabel)
            self.pauseButton.position = CGPoint(x: theScene.frame.width - 20, y: theScene.frame.height - 70)
            self.pauseButton.size = CGSize(width: self.scoreLabel.frame.width / 4, height: self.scoreLabel.frame.height)
            self.addChild(self.pauseButton)
        }
        else {
            //crash it:
            assert(2 == 3)
        }
 
        self.setupMotionDetection()
    }
    
    func spawnKrill() {
        self.spawnManager = SpawnManager()
        var krill = SKSpriteNode(imageNamed: "krill")
        krill.frame.width
        krill.physicsBody = SKPhysicsBody(rectangleOfSize: krill.size)
        krill.physicsBody?.affectedByGravity = false
        krill.physicsBody?.categoryBitMask = UInt32(krillCategory)
        krill.physicsBody?.contactTestBitMask = UInt32(whaleCategory)
        krill.physicsBody?.collisionBitMask = 0
        krill.name = "food"
        krill.position = self.spawnManager.randomSpawnPoint()
        //        krill.position = CGPointMake(300, 200)
        var endPt = self.spawnManager.randomEndPoint()
//        var duration = (arc4random() % 10) + 5
//        var moveAction = SKAction.moveTo(endPt, duration: NSTimeInterval(duration))
        var moveAction = SKAction.moveTo(endPt, duration: 10)
        var removeAction = SKAction.runBlock { () -> Void in
            krill.removeFromParent()
        }
        //ensures krill removed from taking up memory:
        var actions = SKAction.sequence([moveAction,removeAction])
        krill.runAction(actions)
        self.addChild(krill)
        println("startpt: \(krill.position)")
        println("endpt: \(endPt)")
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
            
        }
        for eachTouch in touches {
        if CGRectContainsPoint(self.pauseButton.frame, eachTouch.locationInNode(self)) {
            //change image, before pausing:
            var newTexture = SKTexture(imageNamed: "play.jpg")
            
            self.pauseButton.texture = newTexture
            var timer1 = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: Selector("pausePressed"), userInfo: nil, repeats: false)
            }
        }
    }
    
    func pausePressed() {
        if self.view?.paused == true {
            //un-pause, before re-setting image:
            self.view?.paused = false
            var newTexture = SKTexture(imageNamed: "pause.jpg")
            self.pauseButton.texture = newTexture
        }
        else if self.view?.paused == false {
            //pause it. set image to play.
            
            self.view?.paused = true
            
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        self.deltaTime = currentTime - self.previousTime
        self.previousTime = currentTime
        self.timeSinceLastFood += self.deltaTime
        self.scoreLabel.text = "Score: \(self.currentScore)"
        if self.timeSinceLastFood > self.nextFoodTime {
            //spawn some food:
            self.spawnKrill()
            //generate random nextFood time:
            println("previous food time: \(self.nextFoodTime)")
            self.nextFoodTime = Double(arc4random() % 2000) / 1000
            println("new food time: \(self.nextFoodTime)")
            self.timeSinceLastFood = 0
            print()
        }
        
        
        /* Called before each frame is rendered */
   
        // sample of changing the background color as we go deeper
        //var alpha = CGColorGetAlpha(self.backgroundColor.CGColor)
        //            alpha = alpha + 0.002
        //            //set background to blue
        //            self.backgroundColor = UIColor(red: 51.0/255.0, green: 153.0/255.0, blue: 255.0/255.0, alpha: alpha)

        var newValue = self.translate(self.currentYDirection)
        var newRadian : CGFloat = CGFloat(M_PI * newValue / 180.0)
        self.whale.zRotation = newRadian
        self.updateDepth(newValue)
        
        //get whale's angle.
        //for eachObject:
        //move its currentposition (y-coordinate) oppositely.
        self.enumerateChildNodesWithName("food", usingBlock: { (child, stop) -> Void in
            //check what angle
            var getAngle = self.whale.zRotation
            var curPos = child.position
            child.position = CGPointMake(child.position.x, child.position.y + 10)
        })
    }
    
    //method used to take a our current motion value and translate it to degrees between -45 and 45
    func translate(value : Double) -> Double {
        
        var leftSpan = -0.7 - (0.7) //1.4
        var rightSpan = 45.0 - (-45.0) // 90
        
        //convert left range into a 0-1 range 
        var valueScale = (value - 0.7) / leftSpan
    
        return -45 + (valueScale * rightSpan)
    }
    
    func updateDepth (newValue : Double) {
        
        var newDepth : Double
        var deltaDepth : Double
        
        if newValue > 30 {
            deltaDepth = -1
                self.foodYDelta = -1
        } else if newValue > 15 && newValue < 30 {
            deltaDepth = -0.5
                self.foodYDelta = -0.5
        } else if newValue > 5 && newValue < 15 {
            deltaDepth = -0.25
                self.foodYDelta = -0.25

        } else if newValue > -5 && newValue < 5 {
            deltaDepth = 0
                self.foodYDelta = 0.0
        } else if newValue > -15 && newValue < -5 {
            deltaDepth = 0.25
                self.foodYDelta = 0.25
        } else if newValue > -30 && newValue < -15 {
            deltaDepth = 0.5
                self.foodYDelta = 0.5
        } else if newValue < -30 {
            deltaDepth = 1.0
                self.foodYDelta = 1.0
        } else {
            deltaDepth = 0
                self.foodYDelta = 0.0
        }
        self.currentDepth = self.currentDepth + deltaDepth
        self.depthLabel.text = "\(self.currentDepth)"
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        println("contact: \(contact.contactPoint) \(contact.bodyA.node?.name) \(contact.bodyB.node?.name)")
        if contact.bodyA.node?.name == "food" {
            contact.bodyA.node?.removeFromParent()
            self.currentScore++
        }
        if contact.bodyB.node?.name == "food" {
            contact.bodyB.node?.removeFromParent()
            self.currentScore++
        }
        print()
    }
}
