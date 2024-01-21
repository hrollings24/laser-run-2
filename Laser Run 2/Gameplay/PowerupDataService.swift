//
//  PowerupDataService.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 21/01/2024.
//

import Foundation


public class PowerupDataService {
    static let shared = PowerupDataService()
    
    public var recieved: Bool = false
    private let identifierName = "powerup";
    
    init()
    {
        if UserDefaults.standard.value(forKey: identifierName) == nil{
            UserDefaults.standard.setValue(false, forKey: identifierName)
        }
        
        let value = UserDefaults.standard.value(forKey: identifierName) as? Bool ?? false
        
        recieved = value
    }
    
    public func updateToTrue()
    {
        UserDefaults.standard.setValue(true, forKey: identifierName)
        UserDefaults.standard.synchronize()
        recieved = true
    }
}
