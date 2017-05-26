//
//  String+ChineseToPinYin.swift
//  SleepEarly
//
//  Created by JustinChou on 5/19/17.
//  Copyright © 2017 JustinChou. All rights reserved.
//

import Foundation

extension String {
    
    /// 汉字转拼音
    ///
    /// - Parameter chinese: 汉字
    /// - Returns: 拼音
    func transferFromChineseToPinYin() -> String {
        
        let mutableString = NSMutableString(string: self)
        // 汉字转成拼音
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        // 去掉音标
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        // 去除字符串中的空格
        let finalStr = String(mutableString).replacingOccurrences(of: " ", with: "")
        
        return finalStr
    }

}
