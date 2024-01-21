//
//  Slow.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 03/07/2020.
//

import Foundation
import SpriteKit

class Slow: Powerup{
    
    var oldSpeed: CGFloat!
    var timer: Timer!
    
    override func run(){
        oldSpeed = object.gameScene.speedChanger!
        object.gameScene.speedChanger *= 0.6
        object.gameScene.rootNode.speed = object.gameScene.speedChanger!
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(stop), userInfo: nil, repeats: false)
    }
    
    @objc func stop(){
        object.gameScene.speedChanger = oldSpeed
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(increase), userInfo: nil, repeats: true)
        object.gameScene.rootNode.speed = object.gameScene.speedChanger!
    }
    
    @objc func increase(){
        if object.gameScene.speedChanger < oldSpeed{
            object.gameScene.speedChanger *= 1.05
            object.gameScene.rootNode.speed = object.gameScene.speedChanger!
        }
        else{
            timer.invalidate()
            object.setPowerup()
            object.setPowerupPosition()
        }
       
    }
    
}
