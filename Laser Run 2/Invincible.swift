//
//  File.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 03/07/2020.
//

import Foundation
import SpriteKit

class Invincible: Powerup{
    var counter: Int!
    var switchTexture: Int!
    var timer: Timer!
    
    override func run(){
        object.physicsBody?.categoryBitMask = PhysicsCatagory.IAmInvincible
        counter = 0
        switchTexture = 1
        object.setTexture(texture: SKTexture(imageNamed: object.name! + " Yellow"))
        timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(flash), userInfo: nil, repeats: true)        
    }
    @objc func flash(){
        counter += 1
        if counter > 24 && counter < 36{
            if switchTexture == 1{
                object.setTexture(texture: SKTexture(imageNamed: object.name!))
                switchTexture = 0
            }
            else{
                object.setTexture(texture: SKTexture(imageNamed: object.name! + " Yellow"))
                switchTexture = 1
            }
        }
        else if counter >= 36{
            timer.invalidate()
            expire()
        }
    }
    
    func expire(){
        object.physicsBody?.categoryBitMask = PhysicsCatagory.Object
        object.setTexture(texture: SKTexture(imageNamed: object.name!))
        object.setPowerup()
        object.setPowerupPosition()
    }
}
