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
    var whale = WhaleNode(imageNamed: "orca_01.png")
    var currentYDirection : Double = 0.0
    var currentDepth = 50.0
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
    
    // health bar
    var oxygen = 100.0
    var healthBarLocation : CGPoint!
    var healthBarWidth = 200
    var healthBarHeight = 20
    var healthBar : SKSpriteNode!
    
    // view properties
    var oceanDepth = 2000
    var ocean : SKSpriteNode!
    var middleXPosition : Int!
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        var area1 = CGRect()
        if let theView = self.view?.frame.width {
            area1 = CGRect(x: theView + 20, y: 1334, width: 600, height: 666)
        }
        var spawnController1 = SpawnController(spawnArea: area1, depthLevel: 1, frequency: 1.0, theOcean: self.ocean)
        if let theSize = self.view?.bounds.size {
            self.scene?.size = theSize
        }
        else {
            //crash it:
            assert(1 == 2)
        }
        
        self.ocean = SKSpriteNode(color: UIColor(red: 28.0/255.0, green: 84.0/255.0, blue: 192.0/255.0, alpha: 0.5), size: CGSize(width: 600, height: oceanDepth))
        middleXPosition = Int(scene!.size.height / 2)
        
        // Ocean background
//        self.setupOcean()
        self.ocean.anchorPoint = CGPoint(x: 0, y: 0)
        //self.ocean.position = CGPoint(x: 0, y: 0)
        self.ocean.position = CGPoint(x: 0, y: -oceanDepth + middleXPosition + 50 + Int(self.currentDepth))
        self.addChild(ocean)
        
        // Sky background
        var skyBG = SKSpriteNode(imageNamed: "sky_01.png")
        skyBG.position = CGPointMake(284, 290)
//        self.addChild(skyBG)
        
        // Clouds
//        self.setupClouds()

        // Wave background
//        self.setupWaves()
        
        //add whale
        self.whale.position = CGPoint(x: 35, y: self.middleXPosition)
        self.whale.physicsBody = SKPhysicsBody(rectangleOfSize: self.whale.size)
        self.whale.physicsBody?.affectedByGravity = false
        self.whale.name = "whale"
//        self.whale.physicsBody?.contactTestBitMask = 1
        self.whale.physicsBody?.categoryBitMask = UInt32(whaleCategory)
        self.whale.physicsBody?.contactTestBitMask = UInt32(krillCategory)
        self.whale.physicsBody?.collisionBitMask = 0
        self.addChild(self.whale)
        
        //add krill
//        self.krill.position = CGPoint(x: self.size.width + -50, y: 150)
//        
//        self.addChild(self.krill)
//        
//        var mover = SKAction.moveToX(-100, duration: 10.0)
//        self.krill.runAction(mover)
        
        
        //set background to blue
        self.backgroundColor = UIColor.grayColor()
        
        //adding label to keep track of the current depth
        self.depthLabel.position = CGPoint(x: 280, y: 10)
        self.depthLabel.text = "\(self.currentDepth)"
        self.addChild(self.depthLabel)
        if let theScene = self.scene {
//            self.scoreLabel.position = CGPoint(x: theScene.frame.width - 80, y: theScene.frame.height - 50)
            self.scoreLabel.position = CGPoint(x: 30, y: 18)
            self.scoreLabel.fontName = "Copperplate"
            self.scoreLabel.fontSize = 20
            self.scoreLabel.fontColor = UIColor(red: 128.0/255.0, green: 179.0/255.0, blue: 252.0/255.0, alpha: 1.0)
            self.scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            //self.scoreLabel.text = "\(self.currentScore)"
            self.addChild(self.scoreLabel)
            self.pauseButton.position = CGPoint(x: theScene.frame.width - 20, y: 48)
            self.pauseButton.size = CGSize(width: 25, height: 25)
            self.addChild(self.pauseButton)
            
        // Score bar
        var scoreBar = SKSpriteNode(imageNamed: "scorebar_01.png")
        scoreBar.position = CGPointMake(45, 24)
        self.addChild(scoreBar)
        
        // Lifemeter bar
        var lifeMeterBar = SKSpriteNode(imageNamed: "lifemeterbar_01.png")
        lifeMeterBar.position = CGPointMake(theScene.frame.width - 46, 24)
        self.addChild(lifeMeterBar)
            
        }
        else {
            //crash it:
            assert(2 == 3)
        }
        
        //add health bar
        var oxygen : Double = 100
        var oxygenMask : SKSpriteNode!
        var healthCropNode = SKCropNode()
        healthBarLocation = CGPoint(x: 110, y: self.scene!.size.height - 20)
        var healthBarBackground = SKSpriteNode(color: UIColor.grayColor(), size: CGSize(width: healthBarWidth, height: healthBarHeight))
        healthBarBackground.position = healthBarLocation
        self.addChild(healthBarBackground)
        healthBar = SKSpriteNode(color: UIColor.greenColor(), size: CGSize(width: healthBarWidth, height: healthBarHeight))
        healthBar.position = CGPoint(x: (healthBarLocation.x - CGFloat(healthBarWidth/2)),
                                     y: (healthBarLocation.y - CGFloat((healthBarHeight/2))))
        self.addChild(healthBar)
        healthBar.anchorPoint = CGPoint(x: 0, y: 0)

 
        self.setupMotionDetection()

    }
    
    
    
    func setupOcean() {
        
        for var i = 0; i < 2; i++ {

            var newI = CGFloat(i)

            var oceanBG = SKSpriteNode(imageNamed: "ocean_01.png")
            oceanBG.anchorPoint = CGPointZero
            oceanBG.position = CGPointMake(newI * oceanBG.size.width, -720)
            oceanBG.name = "ocean"
            self.addChild(oceanBG)
        }
    }
    
    func setupWaves() {
        
        for var i = 0; i < 2; i++ {

            var newI = CGFloat(i)

            var wave3BG = SKSpriteNode(imageNamed: "wave_03.png")
            wave3BG.anchorPoint = CGPointZero
            wave3BG.position = CGPointMake(newI * wave3BG.size.width, 250)
            wave3BG.name = "wave3"
            self.addChild(wave3BG)

            var wave2BG = SKSpriteNode(imageNamed: "wave_02.png")
            wave2BG.anchorPoint = CGPointZero
            wave2BG.position = CGPointMake(-newI * wave2BG.size.width, 244)
            wave2BG.name = "wave2"
            self.addChild(wave2BG)

            var wave1BG = SKSpriteNode(imageNamed: "wave_01.png")
            wave1BG.anchorPoint = CGPointZero
            wave1BG.position = CGPointMake(newI * wave1BG.size.width, 239)
            wave1BG.name = "wave1"
            self.addChild(wave1BG)
        }
    }
    
    func setupClouds() {
        
        for var i = 0; i < 1; i++ {
            
            var newI = CGFloat(i)

            var cloud1BG = SKSpriteNode(imageNamed: "cloud_01.png")
            cloud1BG.anchorPoint = CGPointZero
            cloud1BG.position = CGPointMake(newI * cloud1BG.size.width - 100, 290) //3rd
            cloud1BG.name = "cloud1"
            self.addChild(cloud1BG)
 
            var cloud2BG = SKSpriteNode(imageNamed: "cloud_02.png")
            cloud2BG.anchorPoint = CGPointZero
            cloud2BG.position = CGPointMake(newI * cloud2BG.size.width - 60, 300) //1st
            cloud2BG.name = "cloud2"
            self.addChild(cloud2BG)
 
            var cloud3BG = SKSpriteNode(imageNamed: "cloud_03.png")
            cloud3BG.anchorPoint = CGPointZero
            cloud3BG.position = CGPointMake(newI * cloud3BG.size.width - 60, 293) //2nd
            cloud3BG.name = "cloud3"
            self.addChild(cloud3BG)
            
            var cloud4BG = SKSpriteNode(imageNamed: "cloud_04.png")
            cloud4BG.anchorPoint = CGPointZero
            cloud4BG.position = CGPointMake(newI * cloud4BG.size.width - 60, 299)
            cloud4BG.name = "cloud4"
            self.addChild(cloud4BG)
        }
    }
    
    func spawnKrill() {
        self.spawnManager = SpawnManager(screenFrame: self.frame)
        //check current depth
        var depthLevel = 1
        if self.currentDepth < 600 {
            depthLevel = 1
        }
        else if self.currentDepth < 1200 {
            depthLevel = 2
        }
        else {
            depthLevel = 3
        }
        var krill = FoodNode(depthLevel: depthLevel)
//        var foodNum = (arc4random() % 100)
//        var newTexture = SKTexture(imageNamed: "fish.jpg")
        krill.frame.width
        krill.physicsBody = SKPhysicsBody(rectangleOfSize: krill.size)
        krill.physicsBody?.affectedByGravity = false
        krill.physicsBody?.categoryBitMask = UInt32(krillCategory)
        krill.physicsBody?.contactTestBitMask = UInt32(whaleCategory)
        krill.physicsBody?.collisionBitMask = 0
//        krill.name = "food"
        
        krill.startPoint = self.spawnManager.randomSpawnPoint()
        
        krill.position = krill.startPoint!
        
        var endPoint = self.spawnManager.randomEndPoint()
        krill.endPoint = endPoint
        
        
//        var duration = (arc4random() % 10) + 5
//        var moveAction = SKAction.moveTo(endPt, duration: NSTimeInterval(duration))
        var moveAction = SKAction.moveTo(endPoint, duration: 2)
        var removeAction = SKAction.runBlock { () -> Void in
        krill.removeFromParent()
        }
        //ensures krill removed from taking up memory:
        var actions = SKAction.sequence([moveAction,removeAction])
        krill.runAction(actions)
        self.ocean.addChild(krill)
        println("startpt: \(krill.position)")
        println("endpt: \(endPoint)")
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
        self.scoreLabel.text = "\(self.currentScore)"
        
        //init(spawnArea : CGRect, depthLevel : Int, frequency : Double, theOcean : SKSpriteNode)
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
//        self.enumerateChildNodesWithName("food", usingBlock: { (child, stop) -> Void in
//            //check what angle
//            var getAngle = self.whale.zRotation
//            var curPos = child.position
//            child.position = CGPointMake(child.position.x, child.position.y + 10)
//        })
        
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

        updateHealthBar()
    }
    
    //method used to take a our current motion value and translate it to degrees between -45 and 45
    func translate(value : Double) -> Double {
        
        var leftSpan = -0.7 - (0.7)
        var rightSpan = 45.0 - (-45.0)
        
        //convert left range into a 0-1 range 
        var valueScale = (value - 0.7) / leftSpan
    
        return -45 + (valueScale * rightSpan)
    }
    
    func updateDepth (angle : Double) {
        // angle = ~ current angle, value between -30 and 30

        self.depthLabel.text = "Current Depth: \(self.currentDepth)"
        self.currentDepth -= (angle / 10)
        self.ocean.position = CGPoint(x: 0, y: -oceanDepth + middleXPosition + 50 + Int(self.currentDepth))
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
    
    func updateHealthBar() {
        oxygen -= 0.1
        
        if currentDepth < 1 {
            if oxygen < 100 {
                oxygen += 5
            }
        }
        
        if oxygen > 0 {
            healthBar.size.width = CGFloat((healthBarWidth / 100)) * CGFloat(oxygen)
        } else {
            healthBar.size.width = 0
        }
    }
}
