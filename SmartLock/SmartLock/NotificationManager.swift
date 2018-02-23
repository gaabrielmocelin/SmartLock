//
//  NotificationUtil.swift
//  Notification Challenge
//
//  Created by Gabriel Mocelin on 17/10/17.
//  Copyright © 2017 Gabriel Mocelin. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

enum NotificationType {
    case text
    case action
}

class NotificationUtil: NSObject {
    
    let requestIdentifier:String
    let center: UNUserNotificationCenter
    
    override init() {
        requestIdentifier = "notification"
        center = UNUserNotificationCenter.current()
        
        super.init()
        
        UNUserNotificationCenter.current().delegate = self
        
        registerCategories()
    }
    
    func requestAuthorization(completionHandler: ((Bool) -> Void)?) {
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            completionHandler?(granted)
        }
    }
    
    func sendNotification(title: String, subtitle: String, body: String, type: NotificationType, timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = String(type.hashValue)
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier:requestIdentifier, content: content, trigger: trigger)
        center.add(request){(error) in
            if (error != nil){
                print(error?.localizedDescription ?? "error sending notification")
            }
        }
    }
    
    func removeAllNotifications() {
        center.removeAllPendingNotificationRequests()
    }
    
    private func registerCategories() {
        let textCategory = getTextCategory()
        let actionCategory = getActionCategory()
        
        center.setNotificationCategories([textCategory, actionCategory])
    }
    
    private func getActionCategory() -> UNNotificationCategory {
        let openAction = UNNotificationAction(identifier: "open", title: "Open", options: .foreground)
        let type: NotificationType = .action
        return UNNotificationCategory(identifier: String(type.hashValue), actions: [openAction], intentIdentifiers: [], options: .customDismissAction)
    }
    
    private func getTextCategory() -> UNNotificationCategory {
        let textaction = UNTextInputNotificationAction(identifier: "keyboard", title: "keyboard", options: .destructive)
        let type: NotificationType = .text
        return UNNotificationCategory(identifier: String(type.hashValue), actions: [textaction], intentIdentifiers: [], options: .customDismissAction)
    }
    
//   private func openExecutionTaskViewController() {
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//
//        if let tabBar = storyboard.instantiateInitialViewController() as? UITabBarController{
//            if let navBar = tabBar.viewControllers?[0] as? UINavigationController, let viewController = storyboard.instantiateViewController(withIdentifier: "taskList") as? TasksExecutionViewController {
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                appDelegate.window?.rootViewController = tabBar
//
//                navBar.pushViewController(viewController, animated: false)
//                appDelegate.window?.makeKeyAndVisible()
//            }
//        }
//    }

}

extension NotificationUtil: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == requestIdentifier{
            print("clicked on")
//            openExecutionTaskViewController()
        }
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //You can either present alert ,sound or increase badge while the app is in foreground too
        //to distinguish between notifications
        if notification.request.identifier == requestIdentifier{
            completionHandler( [.alert,.sound,.badge])
        }
    }
}
