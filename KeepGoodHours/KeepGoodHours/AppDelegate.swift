//
//  AppDelegate.swift
//  KeepGoodHours
//
//  Created by JustinChou on 26/05/2017.
//  Copyright © 2017 JustinChou. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    private let uMeng_Key = "5928172a04e2053b29000692"
    private let shareInstance: UMSocialManager = UMSocialManager.default()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 友盟相关设置
        shareInstance.openLog(true)
        shareInstance.umSocialAppkey = uMeng_Key
        configUSharePlatforms()
        
        // 通知授权
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (success, error) in
                if success {
                    print("UserNotificationCenter_success")
                } else {
                    print("UserNotificationCenter_fail")
                }
            })
            UNUserNotificationCenter.current().delegate = self
            
        } else {
            let notifySettings = UIUserNotificationSettings(types: [.badge , .sound , .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notifySettings)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kStartLocationNotification), object: nil, userInfo: nil)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let result: Bool = shareInstance.handleOpen(url, options: options)
        
        if !result {
            
        }
        
        return result
    }
    
    
    // MARK:- UMENG 
    func configUSharePlatforms() {
        shareInstance.setPlaform(.wechatSession, appKey: "wx9394a0cc0b8e55a6", appSecret: "64f4187c692cf473ec9be289c3ce9e19", redirectURL: "http://mobile.umeng.com/social")
    }
    
    
    // MARK:- UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //  TODO:-
        print("userNotification_willPresent")
        completionHandler([.badge, .alert, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // todo:-
        print("userNotification_didReceive")
        // the following code must be added
        completionHandler()
    }
    
}

