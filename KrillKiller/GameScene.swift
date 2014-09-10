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
    var whale = WhaleNode(imageNamed: "newWhale")
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
        
        // Ocean background
        self.setupOcean()

        // Sky background
        var skyBG = SKSpriteNode(imageNamed: "sky.png")
        skyBG.position = CGPointMake(284, 290)
        self.addChild(skyBG)
        
        // Clouds
        self.setupClouds()

        // Wave background
        self.setupWaves()
        
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
    
    func setupOcean() {
        
        for var i = 0; i < 2; i++ {

            var newI = CGFloat(i)

            var oceanBG = SKSpriteNode(imageNamed: "ocean.png")
            oceanBG.anchorPoint = CGPointZero
            oceanBG.position = CGPointMake(newI * oceanBG.size.width, -720)
            oceanBG.name = "ocean"
            self.addChild(oceanBG)
        }
    }
    
    func setupWaves() {
        
        for var i = 0; i < 2; i++ {

            var newI = CGFloat(i)

            var wave3BG = SKSpriteNode(imageNamed: "wave3.png")
            wave3BG.anchorPoint = CGPointZero
            wave3BG.position = CGPointMake(newI * wave3BG.size.width, 250)
            wave3BG.name = "wave3"
            self.addChild(wave3BG)

            var wave2BG = SKSpriteNode(imageNamed: "wave2.png")
            wave2BG.anchorPoint = CGPointZero
            wave2BG.position = CGPointMake(-newI * wave2BG.size.width, 244)
            wave2BG.name = "wave2"
            self.addChild(wave2BG)

            var wave1BG = SKSpriteNode(imageNamed: "wave1.png")
            wave1BG.anchorPoint = CGPointZero
            wave1BG.position = CGPointMake(newI * wave1BG.size.width, 239)
            wave1BG.name = "wave1"
            self.addChild(wave1BG)
        }
    }
    
    func setupClouds() {
        
        for var i = 0; i < 1; i++ {
            
            var newI = CGFloat(i)

            var cloud1BG = SKSpriteNode(imageNamed: "cloud1.png")
            cloud1BG.anchorPoint = CGPointZero
            cloud1BG.position = CGPointMake(newI * cloud1BG.size.width - 100, 290) //3rd
            cloud1BG.name = "cloud1"
            self.addChild(cloud1BG)
 
            var cloud2BG = SKSpriteNode(imageNamed: "cloud2.png")
            cloud2BG.anchorPoint = CGPointZero
            cloud2BG.position = CGPointMake(newI * cloud2BG.size.width - 60, 300) //1st
            cloud2BG.name = "cloud2"
            self.addChild(cloud2BG)
 
            var cloud3BG = SKSpriteNode(imageNamed: "cloud3.png")
            cloud3BG.anchorPoint = CGPointZero
            cloud3BG.position = CGPointMake(newI * cloud3BG.size.width - 60, 293) //2nd
            cloud3BG.name = "cloud3"
            self.addChild(cloud3BG)
            
            var cloud4BG = SKSpriteNode(imageNamed: "cloud4.png")
            cloud4BG.anchorPoint = CGPointZero
            cloud4BG.position = CGPointMake(newI * cloud4BG.size.width - 60, 299)
            cloud4BG.name = "cloud4"
            self.addChild(cloud4BG)
        }
    }
    
    func spawnKrill() {
        self.spawnManager = SpawnManager(screenFrame: self.frame)
        var krill = FoodNode(imageNamed: "krill")
        krill.frame.width
        krill.physicsBody = SKPhysicsBody(rectangleOfSize: krill.size)
        krill.physicsBody?.affectedByGravity = false
        krill.physicsBody?.categoryBitMask = UInt32(krillCategory)
        krill.physicsBody?.contactTestBitMask = UInt32(whaleCategory)
        krill.physicsBody?.collisionBitMask = 0
        krill.name = "food"
        
        krill.startPoint = self.spawnManager.randomSpawnPoint()
        
        krill.position = krill.startPoint!
        
        var endPt = self.spawnManager.randomEndPoint()
        krill.endPoint = endPt

        krill.driftLowNearPoint = spawnManager.generateDriftLowNearPoint(endPt)
        krill.driftLowFarPoint = spawnManager.generateDriftLowFarPoint(endPt)
        krill.driftHighNearPoint = spawnManager.generateDriftHighNearPoint(endPt)
        krill.driftHighFarPoint = spawnManager.generateDriftHighFarPoint(endPt)
        
        krill.fillPointsArray()
        
        var index = self.indexForAngle()
        
        var endPoint = krill.endPoints[index]
        
//        var duration = (arc4random() % 10) + 5
//        var moveAction = SKAction.moveTo(endPt, duration: NSTimeInterval(duration))
        var moveAction = SKAction.moveTo(endPoint, duration: 2)
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
    func pauseAfterDelay() {
        var timer1 = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: Selector("pauseGame"), userInfo: nil, repeats: false)
        print()
        timer1.fire()
    }
    func pauseGame() {
        self.view?.paused = true
        print()
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
        
        // Artwork
        // eumerate through wave1
        self.enumerateChildNodesWithName("wave1", usingBlock: { (node, stop) -> Void in
            if let wave1BG = node as? SKSpriteNode {
                wave1BG.position = CGPointMake(wave1BG.position.x - 0.2, wave1BG.position.y) // sidescroll speed
                if wave1BG.position.x <= wave1BG.size.width * -1 {
                    wave1BG.position = CGPointMake(wave1BG.position.x + wave1BG.size.width * 2, wave1BG.position.y)
                }
            }
        })
        
        // eumerate through wave2
        self.enumerateChildNodesWithName("wave2", usingBlock: { (node, stop) -> Void in
            if let wave2BG = node as? SKSpriteNode {
                wave2BG.position = CGPointMake(wave2BG.position.x + 0.3, wave2BG.position.y) // sidescroll speed
                if wave2BG.position.x >= wave2BG.size.width * 1 {
                    wave2BG.position = CGPointMake(wave2BG.position.x - wave2BG.size.width * 2, wave2BG.position.y)
                }
            }
        })
        
        // eumerate through wave3
        self.enumerateChildNodesWithName("wave3", usingBlock: { (node, stop) -> Void in
            if let wave3BG = node as? SKSpriteNode {
                wave3BG.position = CGPointMake(wave3BG.position.x - 0.5, wave3BG.position.y) // sidescroll speed
                if wave3BG.position.x <= wave3BG.size.width * -1 {
                    wave3BG.position = CGPointMake(wave3BG.position.x + wave3BG.size.width * 2, wave3BG.position.y)
                }
            }
        })
        
        self.enumerateChildNodesWithName("cloud1", usingBlock: { (node, stop) -> Void in
            if let cloud1BG = node as? SKSpriteNode {
                cloud1BG.position = CGPointMake(cloud1BG.position.x - 0.13, cloud1BG.position.y) // sidescroll speed
                if cloud1BG.position.x <= cloud1BG.size.width * -1 {
                    cloud1BG.position = CGPointMake(cloud1BG.position.x + 1000, cloud1BG.position.y)
                }
            }
        })
        
        self.enumerateChildNodesWithName("cloud2", usingBlock: { (node, stop) -> Void in
            if let cloud2BG = node as? SKSpriteNode {
                cloud2BG.position = CGPointMake(cloud2BG.position.x - 0.10, cloud2BG.position.y) // sidescroll speed
                if cloud2BG.position.x <= cloud2BG.size.width * -1 {
                    cloud2BG.position = CGPointMake(cloud2BG.position.x + 650, cloud2BG.position.y)
                }
            }
        })
        
        self.enumerateChildNodesWithName("cloud3", usingBlock: { (node, stop) -> Void in
            if let cloud3BG = node as? SKSpriteNode {
                cloud3BG.position = CGPointMake(cloud3BG.position.x - 0.18, cloud3BG.position.y) // sidescroll speed
                if cloud3BG.position.x <= cloud3BG.size.width * -1 {
                    cloud3BG.position = CGPointMake(cloud3BG.position.x + 830, cloud3BG.position.y)
                }
            }
        })
        
        self.enumerateChildNodesWithName("cloud4", usingBlock: { (node, stop) -> Void in
            if let cloud4BG = node as? SKSpriteNode {
                cloud4BG.position = CGPointMake(cloud4BG.position.x - 0.08, cloud4BG.position.y) // sidescroll speed
                if cloud4BG.position.x <= cloud4BG.size.width * -1 {
                    cloud4BG.position = CGPointMake(cloud4BG.position.x + 910, cloud4BG.position.y)
                }
            }
        })

        // ocean
        self.enumerateChildNodesWithName("ocean", usingBlock: { (node, stop) -> Void in
            if let oceanBG = node as? SKSpriteNode {
                oceanBG.position = CGPointMake(oceanBG.position.x - 2.5, oceanBG.position.y) // sidescroll speed
                if oceanBG.position.x <= oceanBG.size.width * -1 {
                    oceanBG.position = CGPointMake(oceanBG.position.x + oceanBG.size.width * 2, oceanBG.position.y)
                }
            }
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
            if self.whale.angle != .SharpDown {
                self.whale.angle = .SharpDown
                self.applyNewAngle()
            }
            deltaDepth = -1
            self.foodYDelta = -1
        } else if newValue > 15 && newValue < 30 {
            if self.whale.angle != .SlightDown {
                self.whale.angle = .SlightDown
                self.applyNewAngle()
            }
            deltaDepth = -0.5
            self.foodYDelta = -0.5
        } else if newValue > 5 && newValue < 15 {
            if self.whale.angle != .Zero {
                self.whale.angle = .Zero
                self.applyNewAngle()
            }
            deltaDepth = -0.25
            self.foodYDelta = -0.25
        } else if newValue > -5 && newValue < 5 {
            if self.whale.angle != .Zero {
                self.whale.angle = .Zero
                self.applyNewAngle()
            }
            deltaDepth = 0
            self.foodYDelta = 0.0
        } else if newValue > -15 && newValue < -5 {
            if self.whale.angle != .Zero {
                self.whale.angle = .Zero
                self.applyNewAngle()
            }
            deltaDepth = 0.25
            self.foodYDelta = 0.25
        } else if newValue > -30 && newValue < -15 {
            if self.whale.angle != .SlightUp {
                self.whale.angle = .SlightUp
                self.applyNewAngle()
            }
            deltaDepth = 0.5
            self.foodYDelta = 0.5
        } else if newValue < -30 {
            if self.whale.angle != .SharpUp {
                self.whale.angle = .SharpUp
                self.applyNewAngle()
            }
            deltaDepth = 1.0
            self.foodYDelta = 1.0
        } else {
            if self.whale.angle != .Zero {
                self.whale.angle = .Zero
                self.applyNewAngle()
            }
            deltaDepth = 0
            self.foodYDelta = 0.0
        }
        self.currentDepth = self.currentDepth + deltaDepth
        self.depthLabel.text = "\(self.currentDepth)"
    }
    
    func applyNewAngle() {
        
        var index = self.indexForAngle()
        
        self.enumerateChildNodesWithName("food", usingBlock: { (node, stop) -> Void in
            if let foodNode = node as? FoodNode {
                var endPoint = foodNode.endPoints[index]
                
                foodNode.removeAllActions()
                
                var mover = SKAction.moveTo(endPoint, duration: 2)
                var removeMoverAction = SKAction.runBlock({ () -> Void in
                    foodNode.removeFromParent()
                })
                
                var actions = SKAction.sequence([mover, removeMoverAction])
                foodNode.runAction(actions)
            }
        })
        
        
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
    
    func indexForAngle() -> Int {
 
        var index = 0

        switch self.whale.angle {
        case .Zero : index = 0
        case .SharpDown : index = 1
        case .SlightDown : index = 2
        case .SharpUp : index = 3
        case .SlightUp : index = 4
        }
        return index
    }
}
