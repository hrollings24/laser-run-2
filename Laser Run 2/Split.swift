//
//  Split.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 03/07/2020.
//

import Foundation
import SpriteKit

class Split: Powerup{
    
    override func run(){
        let gap = (object.gameScene.frame.width / 8) * 6
        changeSize(withGap: gap)
        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(expire), userInfo: nil, repeats: false)

    }
    
    func changeSize(withGap: CGFloat){
        let rows = object.gameScene.rootNode.children
        for row in rows{
            for element in row.children{
                if element.name == "rightLaser"{
                    let actionRight = SKAction.moveBy(x: 40, y: 0, duration: 0.5)
                    element.run(actionRight)
                }
                else if element.name == "leftLaser"{
                    let actionLeft = SKAction.moveBy(x: -40, y: 0, duration: 0.5)
                    element.run(actionLeft)
                }
            }
        }
        object.gameScene.gap = object.gameScene.gap + 40
    }
    
    @objc func stop(){
        
    }
    
    @objc func expire(){
        object.gameScene.gap = (object.gameScene.frame.width / 10) * 6
        let rows = object.gameScene.rootNode.children
        for row in rows{
            for element in row.children{
                if element.name == "rightLaser"{
                    let actionRight = SKAction.moveBy(x: -40, y: 0, duration: 2)
                    element.run(actionRight)
                }
                else if element.name == "leftLaser"{
                    let actionLeft = SKAction.moveBy(x: 40, y: 0, duration: 2)
                    element.run(actionLeft)
                }
            }
        }
        object.setPowerup()
        object.setPowerupPosition()
    }
    
}
