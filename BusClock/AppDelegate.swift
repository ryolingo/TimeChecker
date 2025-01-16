//
//  AppDelegate.swift
//  BusClock
//
//  Created by matsumotoryota on 2025/01/16.
//

import Foundation
import UIKit

// UNUserNotificationCenterDelegateプロトコルを追加
class AppDelegate: NSObject, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    
    func sendPush(){
        let content = UNMutableNotificationContent()
        content.title = "Pushテスト"
        content.body = "アプリ起動から10秒後にPushが送信されます"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier:"notification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    
    /// アプリ起動時の処理
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        print("___application:didFinishLaunchingWithOptions")
        
        //=====追加========================================================
        // Push通知許諾処理
        let center = UNUserNotificationCenter.current()
        //Delegaetを背としている
        center.delegate = self // 追加
        center.requestAuthorization(options: [.alert, .sound, .badge]) { _, error in //
            if let error {
                // 通知が拒否された場合
                print(error.localizedDescription)
            } else {
                print("Push通知許諾OK")
                self.sendPush()
            }
        }
        application.registerForRemoteNotifications()

        // 5秒後にPushを送る
        sendPush()
        //===============================================================
        return true
    }
    // 追加
    /// Push通知押下時の処理
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("___userNotificationCenter:didReceive")
        print("Pushがタップされました。")
        completionHandler()
    }
}
