//
//  AdService.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 21/01/2024.
//

import Foundation

public class AdService {
    static let shared = AdService()
    
    public var removedAds: Bool = false
    private let identifierName = "removedAds";
    
    init()
    {
        if UserDefaults.standard.value(forKey: identifierName) == nil{
            UserDefaults.standard.setValue(false, forKey: identifierName)
        }
        
        let value = UserDefaults.standard.value(forKey: identifierName) as? Bool ?? false
        
        removedAds = value
    }
    
    public func updateToTrue()
    {
        UserDefaults.standard.setValue(true, forKey: identifierName)
        UserDefaults.standard.synchronize()
        removedAds = true
    }
}
