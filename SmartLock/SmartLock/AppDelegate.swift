//
//  AppDelegate.swift
//  SmartLock
//
//  Created by Gabriel Mocelin on 21/02/18.
//  Copyright © 2018 Gabriel Mocelin. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var session: WCSession?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let notificationManager = NotificationManager()
        notificationManager.requestAuthorization(completionHandler: nil)
        
        if (WCSession.isSupported()) {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension UIViewController {
    func breakNavigationItemTitle() {
        for navItem in (self.navigationController?.navigationBar.subviews)! {
            for itemSubView in navItem.subviews {
                if let largeLabel = itemSubView as? UILabel {
                    largeLabel.text = self.title
                    largeLabel.numberOfLines = 0
                    largeLabel.lineBreakMode = .byWordWrapping
                }
            }
        }
    }
}

extension AppDelegate: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
    
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
       updateContext()
    }
    
    func updateContext() {
        guard let user = Session.shared.user else { return }
        guard let selectedHome = Session.shared.selectedHome else { return }
        
//        let selectedLockIndex = user.homes.enumerated().filter {
//            $0.element === selectedHome
//            }.first!.offset
        let locks: [[String : Any]] = user.homes.map {
            var lock: [String: Any] = [:]
            lock["lockName"] = $0.lock.name
            lock["lockStatus"] = $0.lock.status.rawValue
            lock["isSelected"] = $0.lock === selectedHome.lock
            
            return lock
        }
        
        var context: [String : Any] = [:]
        context["locks"] = locks
        
        do {
            try WCSession.default.updateApplicationContext(context)
        } catch {
            print(error)
        }
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        if let message = NSKeyedUnarchiver.unarchiveObject(with: messageData) as? [String : String] {
            guard let lockName = message[WatchLockMessageKey.name.rawValue], let command = message[WatchLockMessageKey.command.rawValue], let user = Session.shared.user else { return }
            if let lock = user.homes.map({ $0.lock }).filter({ $0.name == lockName }).first, let lockCommand = LockCommand(rawValue: command) {
                print("Message from watch: \(message)")
                
                DispatchQueue.main.async {
                    switch lockCommand {
                    case .lock:
                        lock.lock()
                    case .unlock:
                        lock.unlock()
                    default: break
                    }
                }
            }
        }
    }
}
