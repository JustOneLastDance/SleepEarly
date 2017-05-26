//
//  WeatherModel.swift
//  SleepEarly
//
//  Created by JustinChou on 5/18/17.
//  Copyright © 2017 JustinChou. All rights reserved.
//

import UIKit

class WeatherModel: NSObject {
    
    /// 天气现象文字
    var text: String?
    /// 温度
    var temperature: String?
    /// 天气现象代码
    var code: String?
    
    // 方便查看 model 内部数据信息
    override var description: String {
        let keys = ["text", "temperature", "code"]
        return dictionaryWithValues(forKeys: keys).description
    }
}
