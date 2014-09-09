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
    var currentDepth = 100.0
    var depthLabel = SKLabelNode()
    var spawnManager : SpawnManager!
    var skAction = SKAction()
    var deltaTime = 0.0
    var timeSinceLastFood = 0.0
    var nextFoodTime = 0.0
    var previousTime = 0.0
    var foodYDelta = 0.0
    
    override func didMoveToView(view: SKView) {
        
        if let theSize = self.view?.bounds.size {
            self.scene?.size = theSize
        }
        else {
            //crash it:
            assert(1 == 2)
        }
        
        // Sky background
        var skyImage = SKSpriteNode(imageNamed: "sky.png")
        skyImage.position = CGPointMake(284, 290)
        self.addChild(skyImage)
        
        // Clouds
        self.setupClouds()

        // Wave background
        self.setupWaves()
        
        //add whale
        self.whale.position = CGPoint(x: 35, y: 150)
        self.addChild(self.whale)
        
        //set background to blue
        self.backgroundColor = UIColor(red: 51.0/255.0, green: 153.0/255.0, blue: 255.0/255.0, alpha: 0.3)
        
        //adding label to keep track of the current depth
        self.depthLabel.position = CGPoint(x: 500, y: 20)
        self.depthLabel.text = "\(self.currentDepth)"
        self.addChild(self.depthLabel)
 
        self.setupMotionDetection()

    }
    
    func setupWaves() {
        
        for var i = 0; i < 2; i++ {

            var newI = CGFloat(i)

            var wave3bg = SKSpriteNode(imageNamed: "wave3.png")
            wave3bg.anchorPoint = CGPointZero
            wave3bg.position = CGPointMake(newI * wave3bg.size.width, 250)
            wave3bg.name = "wave3"
            self.addChild(wave3bg)

            var wave2bg = SKSpriteNode(imageNamed: "wave2.png")
            wave2bg.anchorPoint = CGPointZero
            wave2bg.position = CGPointMake(-newI * wave2bg.size.width, 244)
            wave2bg.name = "wave2"
            self.addChild(wave2bg)

            var wave1bg = SKSpriteNode(imageNamed: "wave1.png")
            wave1bg.anchorPoint = CGPointZero
            wave1bg.position = CGPointMake(newI * wave1bg.size.width, 239)
            wave1bg.name = "wave1"
            self.addChild(wave1bg)
        }
    }
    
    func setupClouds() {
        
        for var i = 0; i < 1; i++ {
            
            var newI = CGFloat(i)

            var cloud1bg = SKSpriteNode(imageNamed: "cloud1.png")
            cloud1bg.anchorPoint = CGPointZero
            cloud1bg.position = CGPointMake(newI * cloud1bg.size.width - 100, 290) //3rd
            cloud1bg.name = "cloud1"
            self.addChild(cloud1bg)
 
            var cloud2bg = SKSpriteNode(imageNamed: "cloud2.png")
            cloud2bg.anchorPoint = CGPointZero
            cloud2bg.position = CGPointMake(newI * cloud2bg.size.width - 60, 300) //1st
            cloud2bg.name = "cloud2"
            self.addChild(cloud2bg)
 
            var cloud3bg = SKSpriteNode(imageNamed: "cloud3.png")
            cloud3bg.anchorPoint = CGPointZero
            cloud3bg.position = CGPointMake(newI * cloud3bg.size.width - 60, 293) //2nd
            cloud3bg.name = "cloud3"
            self.addChild(cloud3bg)
            
            var cloud4bg = SKSpriteNode(imageNamed: "cloud4.png")
            cloud4bg.anchorPoint = CGPointZero
            cloud4bg.position = CGPointMake(newI * cloud4bg.size.width - 60, 299)
            cloud4bg.name = "cloud4"
            self.addChild(cloud4bg)
        }
    }
    
    func spawnKrill() {
        self.spawnManager = SpawnManager()
        var krill = SKSpriteNode(imageNamed: "krill")
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
    }
    
    override func update(currentTime: CFTimeInterval) {
        self.deltaTime = currentTime - self.previousTime
        self.previousTime = currentTime
        self.timeSinceLastFood += self.deltaTime
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
            if let wave1bg = node as? SKSpriteNode {
                wave1bg.position = CGPointMake(wave1bg.position.x - 0.2, wave1bg.position.y) // sidescroll speed
                if wave1bg.position.x <= wave1bg.size.width * -1 {
                    wave1bg.position = CGPointMake(wave1bg.position.x + wave1bg.size.width * 2, wave1bg.position.y)
                }
            }
        })
        
        // eumerate through wave2
        self.enumerateChildNodesWithName("wave2", usingBlock: { (node, stop) -> Void in
            if let wave2bg = node as? SKSpriteNode {
                wave2bg.position = CGPointMake(wave2bg.position.x + 0.3, wave2bg.position.y) // sidescroll speed
                if wave2bg.position.x >= wave2bg.size.width * 1 {
                    wave2bg.position = CGPointMake(wave2bg.position.x - wave2bg.size.width * 2, wave2bg.position.y)
                }
            }
        })
        
        // eumerate through wave3
        self.enumerateChildNodesWithName("wave3", usingBlock: { (node, stop) -> Void in
            if let wave3bg = node as? SKSpriteNode {
                wave3bg.position = CGPointMake(wave3bg.position.x - 0.5, wave3bg.position.y) // sidescroll speed
                if wave3bg.position.x <= wave3bg.size.width * -1 {
                    wave3bg.position = CGPointMake(wave3bg.position.x + wave3bg.size.width * 2, wave3bg.position.y)
                }
            }
        })
        
        self.enumerateChildNodesWithName("cloud1", usingBlock: { (node, stop) -> Void in
            if let cloud1bg = node as? SKSpriteNode {
                cloud1bg.position = CGPointMake(cloud1bg.position.x - 0.13, cloud1bg.position.y) // sidescroll speed
                if cloud1bg.position.x <= cloud1bg.size.width * -1 {
                    cloud1bg.position = CGPointMake(cloud1bg.position.x + 1000, cloud1bg.position.y)
                }
            }
        })
        
        self.enumerateChildNodesWithName("cloud2", usingBlock: { (node, stop) -> Void in
            if let cloud2bg = node as? SKSpriteNode {
                cloud2bg.position = CGPointMake(cloud2bg.position.x - 0.10, cloud2bg.position.y) // sidescroll speed
                if cloud2bg.position.x <= cloud2bg.size.width * -1 {
                    cloud2bg.position = CGPointMake(cloud2bg.position.x + 650, cloud2bg.position.y)
                }
            }
        })
        
        self.enumerateChildNodesWithName("cloud3", usingBlock: { (node, stop) -> Void in
            if let cloud3bg = node as? SKSpriteNode {
                cloud3bg.position = CGPointMake(cloud3bg.position.x - 0.18, cloud3bg.position.y) // sidescroll speed
                if cloud3bg.position.x <= cloud3bg.size.width * -1 {
                    cloud3bg.position = CGPointMake(cloud3bg.position.x + 830, cloud3bg.position.y)
                }
            }
        })
        
        self.enumerateChildNodesWithName("cloud4", usingBlock: { (node, stop) -> Void in
            if let cloud4bg = node as? SKSpriteNode {
                cloud4bg.position = CGPointMake(cloud4bg.position.x - 0.08, cloud4bg.position.y) // sidescroll speed
                if cloud4bg.position.x <= cloud4bg.size.width * -1 {
                    cloud4bg.position = CGPointMake(cloud4bg.position.x + 910, cloud4bg.position.y)
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
}
