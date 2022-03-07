//
//  UIColor.swift
//  Weather
//
//  Created by Никита Троян on 15.01.2022.
//  Copyright © 2022 JonFir. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let brandOrange = UIColor(red: 255.0 / 255.0, green: 100.0 / 255.0, blue: 20.0 / 255.0, alpha: 1.0)
    
    static let brandWhite = UIColor(red: 250.0 / 255.0, green: 250.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    
    static let brandGreyRed = UIColor(red: 220.0 / 255.0, green: 110.0 / 255.0, blue: 110.0 / 255.0, alpha: 1.0)
    
    static let brandGrey = UIColor(red: 150.0 / 255.0, green: 150.0 / 255.0, blue: 150.0 / 255.0, alpha: 1.0)
}

extension UIColor {
    private static var colorsCached: [String: UIColor] = [:]
    
    public static func rgba (_ r: CGFloat, _ g: CGFloat, b: CGFloat, a:CGFloat) -> UIColor {
        
        let key = "\(r)\(g)\(b)\(a)"
        if let cachedColor = colorsCached[key] {
            return cachedColor
        }
        
        self.clearCacheIfNeeded()
        
        let color = UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
        self.colorsCached[key] = color
        
        return color
    }
    
    private static func clearCacheIfNeeded(){
        let maxObjectCount = 100
        guard self.colorsCached.count >= maxObjectCount else {return}
        colorsCached = [:]
    }
}
