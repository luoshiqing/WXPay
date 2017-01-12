//
//  AppDelegate.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/14.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,WXApiDelegate{

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        let vc = RootViewController()
        let nav = BaseNavigationController(rootViewController: vc)
        
        
        nav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        nav.navigationBar.barTintColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
        self.window?.rootViewController = nav
        
        
        WXApi.registerApp(WX_APPID, withDescription: "apppay")

        
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        

        if let urlsc = url.scheme {
            
            if urlsc == WX_APPID {
                
                return WXApi.handleOpen(url, delegate: self)
            }
        }
        
        print("回调失败")
        return false
    }
    
    func onResp(_ resp: BaseResp!) {

        print(resp.errCode)

        switch resp.errCode {
        case WXSuccess.rawValue:
            let strMsg = "支付结果：成功！"
            let alret = UIAlertView(title: nil, message: "支付成功！", delegate: nil, cancelButtonTitle: "确定")
            alret.show()
            print(strMsg)
            
        case WXErrCodeUserCancel.rawValue:
            let alret = UIAlertView(title: nil, message: "取消支付", delegate: nil, cancelButtonTitle: "确定")
            alret.show()
            
        default:
            
            print("支付错误，其他处理")
            
            let alret = UIAlertView(title: nil, message: "支付取消", delegate: nil, cancelButtonTitle: "确定")
            alret.show()
            
            
            break
        }
    
        
    }
    
    
   

}

