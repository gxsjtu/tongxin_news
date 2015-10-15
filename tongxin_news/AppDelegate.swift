//
//  AppDelegate.swift
//  tongxin_news
//
//  Created by 郭轩 on 15/8/20.
//  Copyright (c) 2015年 郭轩. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var manager: Manager?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
//        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound |
//            UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
        UITabBar.appearance().tintColor = UIColor(red: 36/255, green: 190/255, blue: 242/255, alpha: 1.0)
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        manager = Manager(configuration: configuration)

        if #available(iOS 8.0, *) {
            UIApplication.sharedApplication().registerForRemoteNotifications()
            let userNotificationSettings : UIUserNotificationSettings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Sound, UIUserNotificationType.Badge], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(userNotificationSettings)

        } else {
            UIApplication.sharedApplication().registerForRemoteNotificationTypes([UIRemoteNotificationType.Alert, UIRemoteNotificationType.Sound, UIRemoteNotificationType.Badge])
        }
        
        
        if let isLoggedIn = NSUserDefaults.standardUserDefaults().stringForKey("isLoggedIn")
        {
            if isLoggedIn == "yes"
            {
                let mobile: String? = NSUserDefaults.standardUserDefaults().stringForKey("mobile")
                let password: String? = NSUserDefaults.standardUserDefaults().stringForKey("password")
                let token: String? = NSUserDefaults.standardUserDefaults().stringForKey("token")
                
                manager!.request(.GET, EndPoints.SignIn.rawValue, parameters: ["mobile": mobile!, "password": password!, "method": "checkuser", "token": token!])
                    .responseJSON { response in
                        switch response.result {
                        case .Success:
                            let res = JSON(response.result.value!)
                            if let result = res["result"].string
                            {
                                if result == "error"
                                {
                                    if let loginVC = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("LogIn") as? LogInViewController
                                    {
                                        self.window?.rootViewController = loginVC
                                    }
                                }
                                else
                                {
                                    //转向home页面
                                    if let homeVC = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("HomeTabBarVC") as? HomeTabBarViewController
                                    {
                                        self.window?.rootViewController = homeVC
                                    }
                                }
                            }
                        case .Failure:
                            if let loginVC = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("LogIn") as? LogInViewController
                            {
                                self.window?.rootViewController = loginVC
                            }
                        }
                }
            }
            else
            {
                if let loginVC = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("LogIn") as? LogInViewController
                {
                    self.window?.rootViewController = loginVC
                }
            }
        }
        else
        {
            if let loginVC = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("LogIn") as? LogInViewController
            {
                self.window?.rootViewController = loginVC
            }
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        //校验是否退出登录
        let mobile: String? = NSUserDefaults.standardUserDefaults().stringForKey("mobile")
        let token: String? = NSUserDefaults.standardUserDefaults().stringForKey("token")
        
        if mobile == nil
        {
            if let loginVC = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("LogIn") as? LogInViewController
            {
                self.window?.rootViewController = loginVC
                return
            }
        }
        
        if token == nil
        {
            if let loginVC = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("LogIn") as? LogInViewController
            {
                self.window?.rootViewController = loginVC
                return
            }
        }
        
        manager!.request(.GET, EndPoints.SignIn.rawValue, parameters: ["mobile": mobile!, "token": token!, "method": "checkToken"])
            .responseJSON { response in
                switch response.result {
                case .Success:
                    let res = JSON(response.result.value!)
                    if let result = res["result"].string
                    {
                        if result == "error"
                        {
                            if let loginVC = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("LogIn") as? LogInViewController
                            {
                                loginVC.isForcedLogout = true
                                NSUserDefaults.standardUserDefaults().setObject("no", forKey: "isLoggedIn")
                                self.window?.rootViewController = loginVC
                            }
                        }
                    }
                case .Failure:
                    if let loginVC = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("LogIn") as? LogInViewController
                    {
                        self.window?.rootViewController = loginVC
                    }
                }
        }
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for var i = 0; i < deviceToken.length; i++ {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        NSUserDefaults.standardUserDefaults().setObject(tokenString, forKey: "token")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        if let logout = userInfo["shyr"] as? Int
        {
            if logout == 1
            {
                if let loginVC = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("LogIn") as? LogInViewController
                {
                    loginVC.isForcedLogout = true
                    NSUserDefaults.standardUserDefaults().setObject("no", forKey: "isLoggedIn")
                    self.window?.rootViewController = loginVC
                }
            }
        }
        else
        {
           NSNotificationCenter.defaultCenter().postNotificationName("Badge", object: nil, userInfo: userInfo)
        }
    }
}

