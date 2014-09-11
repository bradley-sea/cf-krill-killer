//
//  GameScene.swift
//  KrillKiller
//
//  Created by Bradley Johnson on 9/8/14.
//  Copyright (c) 2014 CodeFellows. All rights reserved.
//

import SpriteKit
import CoreMotion
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var whale = WhaleNode(imageNamed: "orca_01.png")
    var currentDepth = 50.0
    var depthLabel = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var pauseButton = SKSpriteNode(imageNamed: "pause.jpg")
    var currentScore = 0
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
    var healthBarWidth = 60
    var healthBarHeight = 11
    var healthBar : SKSpriteNode!
    var barColorSpectrum : [UIColor]!
    
    // overlay
    var overlay : SKShapeNode!
    var clearColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
    
    // view properties
    var oceanDepth = 2000
    var ocean : SKSpriteNode!
    var middleXPosition : Int!
    
    //motion properties
    var mManager = CMMotionManager()
    var currentYDirection : Double = 0.0
    
    //spawn controllers
    var spawnControllers = [SpawnController]()
    
    // audio
    var backgroundAudioPlayer = AVAudioPlayer()
    
    override func didMoveToView(view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        if let theSize = self.view?.bounds.size {
            self.scene?.size = theSize
        }
        else {
            //crash it:
            assert(1 == 2)
        }
        
        var overlayRect = CGRect(origin: self.view!.frame.origin, size: self.view!.frame.size)
        overlay = SKShapeNode(rect: overlayRect)
        overlay.fillColor = clearColor
        self.addChild(overlay)
        overlay.zPosition = 99
        
        var color = UIColor(red: 28.0/255.0, green: 84.0/255.0, blue: 192.0/255.0, alpha: 0.5)
        var oceanWidth = CGFloat(self.view!.frame.width + 100)
           var oceanSize = CGSize(width: 900 , height: 2352)
        self.ocean = SKSpriteNode(color: UIColor.blueColor(), size: oceanSize)
        self.ocean.texture = SKTexture(imageNamed: "ocean")
        middleXPosition = Int(scene!.size.height / 2)
        
        self.ocean.anchorPoint = CGPoint(x: 0, y: 0)
        self.ocean.position = CGPoint(x: 0, y: -oceanDepth + middleXPosition + 50 + Int(self.currentDepth))
        self.addChild(ocean)
        
        self.setupOceanBackgrounds()
        
        // Sky background
        var skyBG = SKSpriteNode(imageNamed: "sky_01.png")
        skyBG.position = CGPointMake(284, 290)
//        self.addChild(skyBG)
        
        // Clouds
//        self.setupClouds()

        // Wave background
//        self.setupWaves()
        
        self.setupWhale()
        
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
            scoreLabel.zPosition = 100
            self.pauseButton.position = CGPoint(x: theScene.frame.width - 20, y: 48)
            self.pauseButton.size = CGSize(width: 25, height: 25)
            self.addChild(self.pauseButton)
            
        // Score bar
        var scoreBar = SKSpriteNode(imageNamed: "uiscorebar_01.png")
        scoreBar.position = CGPointMake(45, 24)
        self.addChild(scoreBar)
        scoreBar.zPosition = 100
        
        // Lifemeter bar
        var lifeMeterBar = SKSpriteNode(imageNamed: "uilifemeterbar_01.png")
        lifeMeterBar.position = CGPointMake(theScene.frame.width - 46, 24)
        self.addChild(lifeMeterBar)
        lifeMeterBar.zPosition = 103
            
        //add health bar
        var oxygen : Double = 100
        var oxygenMask : SKSpriteNode!
        var healthCropNode = SKCropNode()
        healthBarLocation = CGPoint(x: 110, y: self.scene!.size.height - 20)
        var healthBarBackground = SKSpriteNode(color: UIColor.lightGrayColor(), size: CGSize(width: healthBarWidth, height: healthBarHeight))
        healthBarBackground.position = lifeMeterBar.frame.origin
        healthBarBackground.anchorPoint = CGPoint(x: 0, y: 0)
        healthBarBackground.position.y += 5
        healthBarBackground.position.x += 4
        self.addChild(healthBarBackground)
        healthBar = SKSpriteNode(color: UIColor.greenColor(), size: CGSize(width: healthBarWidth, height: healthBarHeight))
        healthBar.position = lifeMeterBar.frame.origin
        healthBar.position.y += 5
        healthBar.position.x += 4
        healthBar.anchorPoint = CGPoint(x: 0, y: 0)
        self.addChild(healthBar)

        healthBarBackground.zPosition = 100
        healthBar.zPosition = 101
        lifeMeterBar.zPosition = 102
            
            
        //barColorSpectrum = [UIColor](count: 100, repeatedValue: UIColor.brownColor())
        barColorSpectrum = [UIColor]()
        for i in 0..<100 {
//            var redness : CGFloat = CGFloat(Double(i * 2.5) / 255.0)
//            var greenness : CGFloat = CGFloat(1 - redness)
            var greenness : CGFloat = CGFloat(Double(i * 2.5) / 255.0)
            var redness : CGFloat = CGFloat(1 - greenness)
            barColorSpectrum.append(UIColor(red: redness, green: greenness, blue: 0.0/255.0, alpha: 1.0))
            //barColorSpectrum.append( UIColor(red: red, green: green, blue: 0.0/255.0, alpha: 1.0) )
            //barColorSpectrum.append( UIColor.blueColor() )
        }
            
            println("spectrum count")
            println(barColorSpectrum.count)
        
        println(lifeMeterBar.frame)
        
        }
        else {
            //crash it:
            assert(2 == 3)
        }


        
        self.setupMotionDetection()
        
        self.setupSpawnControllers()
        
        self.startBackgroundMusic()
    }
    
    func setupOceanBackgrounds() {
        
        //total ocean size
        var oceanSize = CGSize(width: 900 , height: 2352)
        
        var imageHeightInPoints : CGFloat = 784
        
        //add top images
        var topOffset = CGFloat(oceanSize.height - imageHeightInPoints)
        var topImageOrigin = CGPoint(x: 0, y: topOffset)
        
        var top = SKSpriteNode(imageNamed: "oceantop_01")
        top.anchorPoint = CGPointZero
        top.position = topImageOrigin
        self.ocean.addChild(top)
        
        var top2 = SKSpriteNode(imageNamed: "oceantop_01")
        top2.anchorPoint = CGPointZero
        top2.position = CGPoint(x: 900, y: topOffset)
        self.ocean.addChild(top2)
        
        top.name = "ocean"
        top2.name = "ocean"
        
        //add middle images
        var middleOffset = CGFloat(oceanSize.height - (imageHeightInPoints * 2))
        var middleImageOrigin = CGPoint(x: 0, y: middleOffset)
        
        var middle = SKSpriteNode(imageNamed: "oceanmiddle_01")
        middle.anchorPoint = CGPointZero
        middle.position = middleImageOrigin
        self.ocean.addChild(middle)
        
        var middle2 = SKSpriteNode(imageNamed: "oceanmiddle_01")
        middle2.anchorPoint = CGPointZero
        middle2.position = CGPoint(x: 900, y: middleOffset)
        self.ocean.addChild(middle2)
        
        middle.name = "ocean"
        middle2.name = "ocean"
        
        
        //add bottom images
        var bottomOffset = CGFloat(0)
        var bottomImageOrigin = CGPoint(x: 0, y: bottomOffset)
        
        var bottom = SKSpriteNode(imageNamed: "oceanbottom_01")
        bottom.anchorPoint = CGPointZero
        bottom.position = bottomImageOrigin
        self.ocean.addChild(bottom)
        
        var bottom2 = SKSpriteNode(imageNamed: "oceanbottom_01")
        bottom2.anchorPoint = CGPointZero
        bottom2.position = CGPoint(x: 900, y: bottomOffset)
        self.ocean.addChild(bottom2)
        
        bottom.name = "ocean"
        bottom2.name = "ocean"
        
    }
    
    func setupSpawnControllers() {
        
        var area1 = CGRect(x: self.view!.frame.width + 20, y: 1334, width: 200, height: 666)
        var spawnController1 = SpawnController(spawnArea: area1, depthLevel: 1, frequency: 0.5, theOcean: self.ocean)
        self.spawnControllers.append(spawnController1)
        
        var area2 = CGRect(x: self.view!.frame.width + 20, y: 668, width: 200, height: 666)
        var spawnController2 = SpawnController(spawnArea: area2, depthLevel: 2, frequency: 1.0, theOcean: self.ocean)
        self.spawnControllers.append(spawnController2)
        
        var area3 = CGRect(x: self.view!.frame.width + 20, y: 0, width: 200, height: 666)
        var spawnController3 = SpawnController(spawnArea: area3, depthLevel: 3, frequency: 2.0, theOcean: self.ocean)
        self.spawnControllers.append(spawnController3)
    }
    
    func setupWhale() {
        self.whale.position = CGPoint(x: 35, y: self.middleXPosition)
        self.whale.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: whale.size.width - 30, height: whale.size.height - 30))
        self.whale.physicsBody?.affectedByGravity = false
        self.whale.name = "whale"
        //        self.whale.physicsBody?.contactTestBitMask = 1
        self.whale.physicsBody?.categoryBitMask = UInt32(whaleCategory)
        self.whale.physicsBody?.contactTestBitMask = UInt32(krillCategory)
        self.whale.physicsBody?.collisionBitMask = 0
        self.addChild(self.whale)
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
    
    
    func setupMotionDetection() {
        
        self.mManager.accelerometerUpdateInterval = 0.05
        self.mManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) { (accelerometerData : CMAccelerometerData!, error) in
            
            //keeping track of the devices orientation in relation to our gameplay. we will use this property in our update loop to figure out which way the wale should be pointing
            
            self.currentYDirection = accelerometerData.acceleration.y // CHECK: screen rotation changes whale rotation
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
        
        for node in self.children {
            println(node.zPosition)
        }

        //SET SCORE
        self.scoreLabel.text = "\(self.currentScore)"
        
        //Spawn Controllers
        
        for spawner in self.spawnControllers {
            spawner.update(currentTime)
        }
        
        //Calculate angle of whale to properly move ocean
        var newValue = self.translate(self.currentYDirection)
        var newRadian : CGFloat = CGFloat(M_PI * newValue / 180.0)
        self.whale.zRotation = newRadian
        var testValue = -35.0
        self.updateDepth(newValue)
        
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
        self.ocean.enumerateChildNodesWithName("ocean", usingBlock: { (node, stop) -> Void in
            if let oceanBG = node as? SKSpriteNode {
                oceanBG.position = CGPointMake(oceanBG.position.x - 0.5, oceanBG.position.y) // sidescroll speed
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
        //println("Angle = \(angle)")
        if ( angle < 0 ) {
            if currentDepth <= 2000 {
                currentDepth -= (angle / 10)
            }
        } else if (angle >= 0 ) {
            if currentDepth > 1 {
                currentDepth -= (angle / 10)
            }
        }
        //println("CurrentDepth = \(currentDepth)")
        self.ocean.position = CGPoint(x: 0, y: -oceanDepth + middleXPosition + 50 + Int(self.currentDepth))
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        //println("contact: \(contact.contactPoint) \(contact.bodyA.node?.name) \(contact.bodyB.node?.name)")
        var bodies = [contact.bodyA,contact.bodyB]
        for eachBody in bodies {
            if let foodNode = eachBody.node as? FoodNode {
                var foodName = foodNode.imageName
                if foodName == "krill" {
                    var sfx = SKAction.playSoundFileNamed("whaleeat_01.caf", waitForCompletion: false)
                    contact.bodyA.node?.runAction(sfx)
                    foodNode.removeFromParent()
                    self.currentScore += 0
                }
                else if foodName == "fishsmall_01" || foodName == "fishsmall_02" || foodName == "fishsmall_03" {
                    var sfx = SKAction.playSoundFileNamed("whaleeat_02.caf", waitForCompletion: false)
                    contact.bodyA.node?.runAction(sfx)
//                    eachBody.node?.removeFromParent()
                    self.currentScore += 1
                }
                else if foodName == "fishmed_01" || foodName == "fishmed_03" || foodName == "fishmed_03" {
                    var sfx = SKAction.playSoundFileNamed("whaleeat_02.caf", waitForCompletion: false)
                    contact.bodyA.node?.runAction(sfx)
//                    eachBody.node?.removeFromParent()
                    self.currentScore += 5
                }
                else if foodName == "fishlarge_01" || foodName == "fishlarge_04" || foodName == "fishlarge_03" {
                    var sfx = SKAction.playSoundFileNamed("whaleeat_02.caf", waitForCompletion: false)
                    contact.bodyA.node?.runAction(sfx)
//                    eachBody.node? .removeFromParent()
                    self.currentScore += 10
                }
                eachBody.node?.removeFromParent()
            }
        }
        print()
    }
    
    func updateHealthBar() {
        oxygen -= 0.1
        
        if currentDepth < 1 {
            if oxygen < 95 {
                oxygen += 5
            } else if oxygen < 100 {
                oxygen = 100
            }
        }
        
        if oxygen > 0 {
            healthBar.size.width = CGFloat((Double(healthBarWidth) / 100.0)) * CGFloat(oxygen)
            if oxygen > 99 {
                healthBar.color = barColorSpectrum[99]
            } else {
                healthBar.color = barColorSpectrum[Int(oxygen)]
            }
        } else {
            healthBar.size.width = 0
        }
        
        if oxygen < 30 {
            displayOxygenWarning()
        } else {
            overlay.fillColor = clearColor
        }
    }
    
    func startBackgroundMusic() {
        
        var error : NSError?
        var backgroundMusic = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("whalesong", ofType: "caf")!)
        self.backgroundAudioPlayer = AVAudioPlayer(contentsOfURL: backgroundMusic, error: &error)
        
        if (error != nil) {
//            println("error w background music player \(error?.userInfo)")
        }
        self.backgroundAudioPlayer.prepareToPlay()
        self.backgroundAudioPlayer.numberOfLoops = -1 // infinite
        self.backgroundAudioPlayer.play()
    }
    
    func displayOxygenWarning() {
        overlay.fillColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
    }
}
