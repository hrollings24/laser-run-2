//
//  FontSizer.swift
//  Laser Run 2
//
//  Created by Harry Rollings on 29/06/2020.
//

import Foundation
import UIKit

class FontSizer{
    
    func setCustomFont(baseFont: CGFloat) -> CGFloat {

        //Current runable device/simulator width find
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width

        //basewidth of the phone
        //iPhone XS has 375px
        let baseWidth: CGFloat = 375

        // "14" font size is defult font size
        let fontSize = baseFont * (width / baseWidth)

        return fontSize
    }
    
}
