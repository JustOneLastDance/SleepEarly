//
//  ViewController.swift
//  SleepEarly
//
//  Created by JustinChou on 5/18/17.
//  Copyright © 2017 JustinChou. All rights reserved.
//

import UIKit
import CoreLocation
import Social
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var atmosphereLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var insistDaysView = AIIBounceInsistDaysView()
    
    // MARK:- button
    @IBAction func didClickShareButton(_ sender: Any) {
        // UMeng SDK
        // TODO:-
        xmt_Umeng_Share()
        
        insistDaysView.days = "123"
        
    }
    
    var weather: WeatherModel? {
        
        didSet{
//            let result: Bool = Thread.isMainThread
//            print("ifMainThread:\(result)") // false
            // 为啥不是在主线程？
            DispatchQueue.main.async {
//                let result: Bool = Thread.isMainThread
//                print("ifMainThread:\(result)")
                
                self.atmosphereLabel.text = self.weather!.text
                self.temperatureLabel.text = self.weather!.temperature! + "º"
                self.imageView.image = UIImage.init(named: (self.weather?.code!)!)
                self.imageView.sizeToFit()
            }
        }
    }
    
    let locationManger: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        xmt_checkLocationAuthorization()
        
        NotificationCenter.default.addObserver(self, selector: #selector(startCLLocationManger), name: NSNotification.Name(rawValue: kStartLocationNotification), object: nil)
        
        xmt_setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("ViewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("ViewWillDisappear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: CLLocationManagerDelegate {
    
    /// 初始化界面
    func xmt_setupUI() {
        insistDaysView = AIIBounceInsistDaysView.init(frame: CGRect.init(x: 150, y: 250, width: 120, height: 40))
        view.addSubview(insistDaysView)
    }
    
    /// 检查位置授权状态
    func xmt_checkLocationAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedWhenInUse:
            locationManger.delegate = self
            locationManger.startUpdatingLocation()
            print("授权成功")
            break
        case .notDetermined:
            locationManger.requestWhenInUseAuthorization()
            break
        case .authorizedAlways, .denied, .restricted:
            print("授权失败")
            break
        }
    }
    
    // MARK:- CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation: CLLocation = locations.last!
        
        let geoCoder: CLGeocoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(currentLocation) { (placeMarks: [CLPlacemark]?, error: Error?) in
            
            guard let placemark = placeMarks?.first else {
                print("did not get information")
                return
            }
            var city: String = placemark.locality!
            city = city.replacingOccurrences(of: "市", with: "")
            self.cityLabel.text = city
            
            self.locationManger.stopUpdatingLocation()
            
            city = city.transferFromChineseToPinYin()
            print("\(city)")
            
            AIIWeatherManage.sharedManager.getWeatherInformation(city: city, finished: { (weather: WeatherModel?) in
                self.weather = weather
            })
            
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "火星"
        atmosphereLabel.text = "气象局休假～"
        temperatureLabel.text = "你猜现在多少度？"
        temperatureLabel.sizeToFit()
    }
    
    
    // MARK:- 通知监听
    func startCLLocationManger() {
        locationManger.startUpdatingLocation()
    }
    
    
    // MARK:- Umeng share
    func xmt_Umeng_Share() {
        let messageObject: UMSocialMessageObject = UMSocialMessageObject.init()
        let shareObejct = UMShareImageObject()
        shareObejct.shareImage = xmt_snipScreen()
        messageObject.shareObject = shareObejct
        
        UMSocialManager.default().share(to: .wechatTimeLine, messageObject: messageObject, currentViewController: self) { (data: Any?, error: Error?) in
            
            if let err = error {
                print("err:\(err)")
            }
            print("\(String(describing: data))")
        }
    }
    
    
    // MARK:- 截取当前屏幕
    func xmt_snipScreen() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, UIScreen.main.scale)
        UIApplication.shared.keyWindow?.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    
    // MARK:- 闹铃相关
    func xmt_createClock() {
        if #available(iOS 10.0, *) {
        
            let notifyContent = UNMutableNotificationContent()
            notifyContent.title = "该起床了"
            
            
        } else {
            
            
            
        }
    }
}


















