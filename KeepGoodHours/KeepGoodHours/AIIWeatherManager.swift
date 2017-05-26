//
//  AIIWeatherManager.swift
//  KeepGoodHours
//
//  Created by JustinChou on 26/05/2017.
//  Copyright © 2017 JustinChou. All rights reserved.
//

import UIKit

class AIIWeatherManage: NSObject {
    
    static let sharedManager = AIIWeatherManage()
    
    private override init() {
        super.init()
    }
    
    /// 获取天气信息
    ///
    /// - Parameters:
    ///   - city: 城市
    ///   - finished: 成功回调
    func getWeatherInformation(city: String!, finished: @escaping (WeatherModel?) -> ()) {
        
        let key = "l987cawg3owbgi3u"
        
        guard let cityStr = city else {
            return
        }
        
        let urlStr: String = "https://api.seniverse.com/v3/weather/now.json?key=\(key)&location=\(cityStr)&language=zh-Hans&unit=c"
        let url = URL(string: urlStr)!
        let request: URLRequest! = URLRequest(url: url)
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        let session: URLSession = URLSession(configuration: configuration)
        let sessionTask: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error:Error?) in
            
            if error != nil {
                print("网络访问失败")
                return
            }
            
            do {
                let responseData: NSDictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                let results = responseData["results"] as! NSArray
                let result = results.firstObject as! NSDictionary
                let now = result["now"] as! NSDictionary
                
                let weather: WeatherModel = WeatherModel()
                weather.code = now["code"] as? String
                weather.text = now["text"] as? String
                weather.temperature = now["temperature"] as? String
                
                finished(weather)
                
            } catch {}
            
        }
        
        sessionTask.resume()
        
    }
    
}

