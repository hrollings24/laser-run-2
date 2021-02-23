//
//  Double.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 03/07/2020.
//

import Foundation
import SpriteKit

class Double: Powerup{
    
    override func run(){
        object.gameScene.scoreIncrementer = 2
        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(expire), userInfo: nil, repeats: false)
        object.gameScene.increaseScoreSize()

    }
    
    @objc func expire(){
        object.gameScene.scoreIncrementer = 1
        object.setPowerup()
        object.setPowerupPosition()
        object.gameScene.decreaseScoreSize()
    }
}
