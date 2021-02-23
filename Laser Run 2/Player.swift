//
//  File.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 03/07/2020.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode{
    private var hasPowerup: Powerup!
    private var powerupPosition: Int!
    var gameScene: GameScene!
    var isAlive: Bool!
    
    init(imageName: String, gameScene: GameScene) {
        isAlive = true
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        self.name = imageName
        self.gameScene = gameScene
        
        self.size = CGSize(width: gameScene.frame.width / 12, height: gameScene.frame.width / 12)
        
        //Object Physics
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.frame.height / 2)
        self.physicsBody?.categoryBitMask = PhysicsCatagory.Object
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = PhysicsCatagory.Laser | PhysicsCatagory.score
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        
        setPowerup()
        powerupPosition = Int.random(in: 20..<25)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTexture(texture: SKTexture){
        self.texture = texture
    }
    
    func setPowerup(){
        let randomInt = Int.random(in: 1..<5)
        switch randomInt {
        case 1:
            hasPowerup = Invincible(onObject: self)
        case 2:
            hasPowerup = Slow(onObject: self)
        case 3:
            hasPowerup = Split(onObject: self)
        default:
            hasPowerup = Double(onObject: self)
        }
    }
    
    func getPowerup() -> Powerup{
        return self.hasPowerup
    }
    
    func runPowerup(){
        self.getPowerup().run()
    }
    
    func getPowerupPosition() -> Int{
        return powerupPosition
    }
    
    func setPowerupPosition(){
        powerupPosition = gameScene.score + Int.random(in: 10..<20) + Int(gameScene.score / 2)
    }
}
