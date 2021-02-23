//
//  Character.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 30/06/2020.
//

import Foundation

class Character{
    
    var locked: Bool!
    var imageNamed: String!
    var unlockDescription: String!
    var lockedDescription: String!
    var barrier: Int32!
    var progress: Int32!
    var id: Int32!
    
    init(locked: Bool, imageNamed: String, unlockDescription: String, lockedDescription: String, barrier: Int32, progress: Int32!, id: Int32) {
        self.locked = locked
        self.imageNamed = imageNamed
        self.unlockDescription = unlockDescription
        self.lockedDescription = lockedDescription
        self.barrier = barrier
        self.progress = progress
        self.id = id
    }
    
}
