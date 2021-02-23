//
//  GameScene.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 29/06/2020.
//

import SpriteKit
import GameplayKit

//Set up the physics
struct PhysicsCatagory {
    static let Object : UInt32 = 0x1 << 1
    static let Laser : UInt32 = 0x1 << 3
    static let score : UInt32 = 0x1 << 4
    static let Lightning: UInt32 = 0x1 << 5
    static let IAmInvincible: UInt32 = 0x1 << 6

}


class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var score: Int!
    var playerObject: Player!
    var mode: Mode!
    var scoreLB: SKLabelNode!
    var rootNode: SKNode!
    var gameStarted: Bool!
    var speedChanger: CGFloat!
    weak var gameVC: GameViewController!
    var backgroundNode: SKNode!
    var scoreIncrementer: Int!
    var gap: CGFloat!
    var startNode: SKLabelNode!
    
    func addBackground(){
        self.addChild(backgroundNode)
    }
        
    override init(size:CGSize){
        super.init(size:size)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func setupGame(){
        
        startNode = SKLabelNode(fontNamed: "Potra")
        startNode.text = "Tap to Start"
        startNode.fontColor = .black
        startNode.fontSize = FontSizer.init().setCustomFont(baseFont: 42)
        startNode.zPosition = 11
        startNode.position = CGPoint(x: self.frame.width / 2 , y: self.frame.height / 3 * 2)
        self.addChild(startNode)

        
        //Play
        gameStarted = false
        if mode == .dash{
            speedChanger = 2.0
        }
        else{
            speedChanger = 1.0
        }
        self.physicsWorld.contactDelegate = self

        //Object
        let ob = UserDefaults.standard.value(forKey: "character") as! String
        playerObject = Player(imageName: ob, gameScene: self)
        if mode != .reverse{
            playerObject.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 5 + 20)
        }
        else{
            playerObject.position = CGPoint(x: self.frame.width / 2, y: ((self.frame.height / 5) * 4))
        }
        playerObject.zPosition = 5
        
        self.addChild(playerObject)
        
        //Score
        score = 0
        scoreLB = SKLabelNode(fontNamed: "Potra")
        scoreLB.fontSize = 84
        scoreLB.setScale(0.5)
        scoreLB.position = CGPoint(x: (self.frame.width + 40) - self.frame.width , y: self.frame.height - 50)
        scoreLB.text = "\(String(describing: score!))"
        scoreLB.zPosition = 10
        scoreLB.fontColor = SKColor.black
        scoreIncrementer = 1
        self.addChild(scoreLB)
        
        if !root.isInitialTheme{
            let arrayOfThemes: [String] = ["theme1", "theme2", "theme3", "theme4"]
            theme = arrayOfThemes.randomElement()
        }
        else{
            root.isInitialTheme = false
        }
      
        
        backgroundNode = SKNode()
        
        let background = SKSpriteNode(imageNamed: theme)
        background.size = CGSize(width: self.frame.width, height: self.frame.width*10)
        background.position = CGPoint(x: frame.size.width / 2, y: self.frame.width*5)
        backgroundNode.addChild(background)
        
        let background2 = SKSpriteNode(imageNamed: theme)
        background2.size = CGSize(width: self.frame.width, height: self.frame.width*10 + 2)
        background2.position = CGPoint(x: frame.size.width / 2, y: self.frame.width*5 - 1)
        backgroundNode.addChild(background2)
        root.backgroundImage.image = UIImage(named: theme)

                
        self.scene?.backgroundColor = .clear
        self.view?.backgroundColor = .clear
        self.view?.allowsTransparency = true
        
        let moveBackground = SKAction.moveBy(x: 0, y: -self.frame.width*10, duration: TimeInterval(60))
        let moveBackgroundSide = SKAction.moveBy(x: self.frame.width*2, y: 0, duration: TimeInterval(0))
        let moveBackgroundUp = SKAction.moveBy(x: 0, y: self.frame.width*10, duration: TimeInterval(0))
        let moveBackgroundSide2 = SKAction.moveBy(x: -self.frame.width*2, y: 0, duration: TimeInterval(0))

        let moveseq = SKAction.sequence([moveBackground, moveBackgroundSide, moveBackgroundUp, moveBackgroundSide2])
        let moveseq2 = SKAction.sequence([moveBackgroundSide, moveBackgroundUp, moveBackgroundSide2, moveBackground])
        
        let moveseqForever = SKAction.repeatForever(moveseq)
        let moveseqForever2 = SKAction.repeatForever(moveseq2)
        
        background.run(moveseqForever)
        background2.run(moveseqForever2)
        
        backgroundNode.isPaused = true

        //Lasers
        rootNode = SKNode()
        gap = (self.frame.width / 10) * 6
        self.addChild(rootNode)
    }
    
    func setPositionOfObject(x: CGFloat){
        if mode != .reverse{
            playerObject.position = CGPoint(x: x, y: self.frame.height / 5 + 20)
        }
        else{
            playerObject.position = CGPoint(x: x, y: ((self.frame.height / 5) * 4))
        }
    }
    
    func spawnLaser(atHeight: CGFloat, timeInt: Int){
        let laserRow = SKNode()
        
        // declare the score node
        let scoreNode = SKSpriteNode()
        //set the score node size
        scoreNode.size = CGSize(width: self.frame.width, height: 1)
        scoreNode.position = CGPoint(x: self.frame.width / 2, y: atHeight)
        
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        //not affected by collisions
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCatagory.score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCatagory.Object
        
        let rightLaser = SKSpriteNode(imageNamed: "laser")
        let leftLaser = SKSpriteNode(imageNamed: "laser")
        
        rightLaser.size = CGSize(width: self.frame.width, height: (self.frame.height / 45))
        leftLaser.size = CGSize(width: self.frame.width, height: (self.frame.height / 45))
        
        rightLaser.position = CGPoint(x: self.frame.width / 2 + gap, y: atHeight)
        leftLaser.position = CGPoint(x: self.frame.width / 2 - gap, y: atHeight)
       
        let rec = CGSize(width: rightLaser.frame.width - 8, height: rightLaser.frame.height - 4)
        rightLaser.physicsBody = SKPhysicsBody(rectangleOf: rec)
        rightLaser.physicsBody?.categoryBitMask = PhysicsCatagory.Laser
        rightLaser.physicsBody?.collisionBitMask = PhysicsCatagory.Object
        rightLaser.physicsBody?.contactTestBitMask = PhysicsCatagory.Object
        rightLaser.physicsBody?.isDynamic = false
        rightLaser.physicsBody?.affectedByGravity = false
        
        let rec2 = CGSize(width: leftLaser.frame.width - 8, height: leftLaser.frame.height - 4)
        leftLaser.physicsBody = SKPhysicsBody(rectangleOf: rec2)
        leftLaser.physicsBody?.categoryBitMask = PhysicsCatagory.Laser
        leftLaser.physicsBody?.collisionBitMask = PhysicsCatagory.Object
        leftLaser.physicsBody?.contactTestBitMask = PhysicsCatagory.Object
        leftLaser.physicsBody?.isDynamic = false
        leftLaser.physicsBody?.affectedByGravity = false
        
        rightLaser.name = "rightLaser"
        leftLaser.name = "leftLaser"
        
        laserRow.addChild(rightLaser)
        laserRow.addChild(leftLaser)
        laserRow.addChild(scoreNode)
        
        var distance = CGFloat(atHeight + laserRow.frame.height)
    
        if mode == .reverse{
            distance = CGFloat(atHeight - laserRow.frame.height - self.frame.height)
        }
        
        let randomPosition = CGFloat.random(in: -self.frame.width / 3..<self.frame.width / 3)
        
        laserRow.position.x = laserRow.position.x + randomPosition
        
        laserRow.zPosition = 4

        var randomXPosition = CGFloat()
        if mode == .arcade{
        
            switch score!{
                case 0..<18:
                    if randomPosition < 0{
                        randomXPosition = self.frame.width / 4
                    }
                    else{
                        randomXPosition = -(self.frame.width / 4)
                    }
                case 18..<35:
                    if randomPosition < 0{
                        randomXPosition = self.frame.width / 3
                    }
                    else{
                        randomXPosition = -(self.frame.width / 3)
                    }
                default:
                    if randomPosition < 0{
                        randomXPosition = self.frame.width / 2
                    }
                    else{
                        randomXPosition = -(self.frame.width / 2)
                    }
            }
        }
        else{
            randomXPosition = 0
        }
        
        if score == playerObject.getPowerupPosition(){
            let lightning = SKSpriteNode(imageNamed: "lightning")
            lightning.size = CGSize(width: 32, height: 32)
            lightning.physicsBody = SKPhysicsBody(circleOfRadius: lightning.frame.height / 2)
            lightning.physicsBody?.categoryBitMask = PhysicsCatagory.Lightning
            lightning.physicsBody?.collisionBitMask = PhysicsCatagory.Object
            lightning.physicsBody?.contactTestBitMask =  PhysicsCatagory.Object
            lightning.physicsBody?.affectedByGravity = false
            lightning.physicsBody?.isDynamic = false
            
            lightning.position = CGPoint(x: self.frame.width / 2, y: atHeight)
            
            laserRow.addChild(lightning)
        }
        
        let moveLaser = SKAction.moveBy(x: randomXPosition, y: -distance, duration: TimeInterval(timeInt))
        let removeLaser = SKAction.removeFromParent()
        let laserAction = SKAction.sequence([moveLaser, removeLaser])

        rootNode.addChild(laserRow)
        laserRow.run(laserAction)
        
    }
    
    func playGame() {
        
        backgroundNode.isPaused = false
        
        let createInitialLasers = SKAction.run({
            () in
            if self.mode != .reverse{
                self.spawnLaser(atHeight: self.frame.height, timeInt: 6)
            }
            else{
                self.spawnLaser(atHeight: 0, timeInt: 6)
            }
        })
        
        let createLaser = SKAction.run({
            () in
            if self.mode != .reverse{
                self.spawnLaser(atHeight: self.frame.height * 2, timeInt: 12)
            }
            else{
                self.spawnLaser(atHeight: -self.frame.height, timeInt: 12)
            }
        })
        
        let delay = SKAction.wait(forDuration: 1.2)
        let spawnLasers = SKAction.sequence([createLaser, delay])
        let spawnLasersForever = SKAction.repeatForever(spawnLasers)
        let spawnInitialLasers = SKAction.sequence([createInitialLasers, delay])
        let initialLasers = SKAction.repeat(spawnInitialLasers, count: 5)

        rootNode.run(initialLasers)
        rootNode.run(spawnLasersForever)
        rootNode.speed = speedChanger
        
    }
    
    func died(){
        rootNode.speed = 0.02
        playerObject.isAlive = false
        self.gameVC.removePan()
        let act1 = SKAction.wait(forDuration: 1)
        self.run(act1){
            self.removeAllActions()
            self.removeAllChildren()
            self.gameVC.died()
        }
        
        
    }
    
    func changeSpeed(){
        if playerObject.isAlive{
            if speedChanger >= 5.0{
                rootNode.speed = speedChanger
            }
            else{
                if mode == .dash{
                    speedChanger += 0.04
                }
                else{
                    speedChanger += 0.02
                }
                rootNode.speed = speedChanger
            }
        }
       
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contact1 = contact.bodyA
        let contact2 = contact.bodyB
        
        //if the contact is between the laser and the object or the object and the laser
        if (contact1.categoryBitMask == PhysicsCatagory.Laser && contact2.categoryBitMask == PhysicsCatagory.Object) || (contact1.categoryBitMask == PhysicsCatagory.Object && contact2.categoryBitMask == PhysicsCatagory.Laser){
            
            died()
            
        }
        
        if (contact1.categoryBitMask == PhysicsCatagory.score && contact2.categoryBitMask == PhysicsCatagory.Object) || (contact1.categoryBitMask == PhysicsCatagory.Object && contact2.categoryBitMask == PhysicsCatagory.score){
            
            if playerObject.isAlive{
                score += scoreIncrementer
                scoreLB.text = "\(score!)"
                changeSpeed()
            }
           
        }
        
        if (contact1.categoryBitMask == PhysicsCatagory.score && contact2.categoryBitMask == PhysicsCatagory.IAmInvincible) || (contact1.categoryBitMask == PhysicsCatagory.IAmInvincible && contact2.categoryBitMask == PhysicsCatagory.score){
            
            if playerObject.isAlive{
                score += scoreIncrementer
                scoreLB.text = "\(score!)"
                changeSpeed()
            }
           
        }
        
        if (contact1.categoryBitMask == PhysicsCatagory.Lightning && contact2.categoryBitMask == PhysicsCatagory.Object){
            contact1.node?.removeFromParent()
            
            if !(UserDefaults.standard.value(forKey: "powerup") as! Bool) {
                DispatchQueue.main.async{
                    //first time recieving a powerup!
                    //PAUSE GAME
                    UserDefaults.standard.set(true, forKey: "powerup")
                    self.pause()
                    let alert = UIAlertController(title: "Powerup!", message: "You've recieved a powerup! Powerups can double your score, make you invincible, increase the laser gap or slow the game down", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
                        //run your function here
                        self.unpause()
                        self.playerObject.runPowerup()
                    }))
                    self.gameVC.present(alert, animated: true, completion: nil)
                }
            }
            else{
                playerObject.runPowerup()
            }
            
            //ACTIVATE POWERUP
        }
        if (contact1.categoryBitMask == PhysicsCatagory.Object && contact2.categoryBitMask == PhysicsCatagory.Lightning){
            contact2.node?.removeFromParent()
            //ACTIVATE POWERUP
            if !(UserDefaults.standard.value(forKey: "powerup") as! Bool) {
                DispatchQueue.main.async{
                    //first time recieving a powerup!
                    //PAUSE GAME
                    UserDefaults.standard.set(true, forKey: "powerup")
                    self.pause()
                    let alert = UIAlertController(title: "Powerup!", message: "You've recieved a powerup! Powerups can double your score, make you invincible, increase the laser gap or slow the game down", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
                        //run your function here
                        self.unpause()
                        self.playerObject.runPowerup()
                    }))
                    self.gameVC.present(alert, animated: true, completion: nil)
                }
            }
            else{
                playerObject.runPowerup()
            }
        }
        
    }
    
    func pause(){
        rootNode.isPaused = true
    }
    
    func unpause(){
        rootNode.isPaused = false
    }
    
    
    func increaseScoreSize(){
        let action = SKAction.moveBy(x: 30, y: -60, duration: 1)
        let scaleAction = SKAction.scale(by: 1.5, duration: 1)

        scoreLB.run(action)
        scoreLB.run(scaleAction)

    }
    
    func decreaseScoreSize(){
        let action = SKAction.moveBy(x: -30, y: 60, duration: 1)
        let scaleAction = SKAction.scale(by: 0.66, duration: 1)

        scoreLB.run(action)
        scoreLB.run(scaleAction)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameStarted{
            gameStarted = true
            startNode.removeFromParent()
            playGame()
        }
    }
}
