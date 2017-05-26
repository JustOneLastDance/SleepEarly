//
//  UIColor+Extension.swift
//  SleepEarly
//
//  Created by JustinChou on 5/22/17.
//  Copyright © 2017 JustinChou. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    /// 创建一个随机的颜色
    ///
    /// - Returns: 颜色
    class func randomColor() -> UIColor {
        let randomR: CGFloat = CGFloat(arc4random_uniform(255)) / CGFloat(255.0)
        let randomG: CGFloat = CGFloat(arc4random_uniform(255)) / CGFloat(255.0)
        let randomB: CGFloat = CGFloat(arc4random_uniform(255)) / CGFloat(255.0)
        
        let randomColor: UIColor = UIColor.init(red: randomR, green: randomG, blue: randomB, alpha: 1)
        return randomColor
    }
}
