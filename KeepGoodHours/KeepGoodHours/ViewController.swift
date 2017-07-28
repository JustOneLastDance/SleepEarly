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
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var bedTimeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var confirmTimeButton: UIButton!
    
    var insistDaysView = AIIBounceInsistDaysView()
    
    // MARK:- button
    @IBAction func didClickConfirmTimeButton(_ sender: Any) {
        // todo:-
        xmt_createClock()
    }
    
    @IBAction func didClickShareButton(_ sender: Any) {
        // UMeng SDK
        xmt_Umeng_Share()
        
//        insistDaysView.days = "123"
        
//        xmt_changeTheTheme()
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
        
        view.backgroundColor = UIColor.white
        
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
        insistDaysView = AIIBounceInsistDaysView.init(frame: CGRect.init(x: 0, y: 200, width: 200, height: 80))
//        insistDaysView.isUserInteractionEnabled = false
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
        
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, UIScreen.main.scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    
    // MARK:- 闹铃相关
    func xmt_createClock() {
        
        if #available(iOS 10.0, *) {
            let notifyContent = UNMutableNotificationContent()
            notifyContent.title = "该起床啦"
            notifyContent.body = "太阳晒屁股啦！！！"
            notifyContent.sound = UNNotificationSound.init(named: "sea&seagull.wav")
//            notifyContent.categoryIdentifier = "ClockCategoryIndentifier"
            
            let date = datePicker.date
            let calendar = Calendar.current
            let componments = calendar.dateComponents([.hour, .minute], from: date)
//            let trigger = UNCalendarNotificationTrigger.init(dateMatching: componments, repeats: true)
            
            // following code -> test
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest.init(identifier: "ClockNotification", content: notifyContent, trigger: trigger)
            
            let userNotificationCenter = UNUserNotificationCenter.current()
            userNotificationCenter.add(request, withCompletionHandler: nil)
            
        } else {
            let fireDate = datePicker.date
            let localNotication = UILocalNotification()
            localNotication.fireDate = fireDate
            localNotication.timeZone = NSTimeZone.default
            localNotication.alertTitle = "该起床啦"
            localNotication.alertBody = "太阳晒屁股啦！！！"
            localNotication.soundName = "sea&seagull.wav"
            UIApplication.shared.scheduleLocalNotification(localNotication)
        }
    }
    
    // MARK:- about Theme
    func xmt_changeTheTheme() {
        
        let color = UIColor.randomColor()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: { 
            self.topView.backgroundColor = color
        }) { (true) in
            UIView.animate(withDuration: 0.3, animations: { 
                self.bedTimeLabel.backgroundColor = color
            })
        }
        UIView.animate(withDuration: 0.3, delay: 0.6, options: .curveLinear, animations: {
            self.confirmTimeButton.backgroundColor = color
        }, completion: nil)
    }
}


















