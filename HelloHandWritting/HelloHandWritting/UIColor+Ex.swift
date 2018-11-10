//
//  UIColor+Ex.swift
//  HelloHandWritting
//
//  Created by 謝佳瑋 on 2018/11/10.
//  Copyright © 2018 ml. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex: Int, alpha: CGFloat = 1.0) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff, alpha: alpha)
    }
    
    static let mainGreen = UIColor(netHex: 0x4ba83b)
    static let unselectedGray = UIColor(netHex: 0x999999)
    static let backgroundGray = UIColor(netHex: 0xf2f2f2)
    static let mainBlack = UIColor(netHex: 0x4D4D4D)
    static let textBlack = UIColor(netHex: 0x1a1a1a)
}
