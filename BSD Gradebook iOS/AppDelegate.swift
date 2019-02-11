//
//  AppDelegate.swift
//  BSD Gradebook iOS
//
//  Created by Alan Chu on 1/28/19.
//  Copyright © 2019 Aeta. All rights reserved.
//

import UIKit
import EDUPointServices
import os.log

var services: PXPWebServices!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        if EDUPStorageController.shared.container.viewContext.hasChanges {
            do {
                try EDUPStorageController.shared.container.viewContext.save()
            } catch (let error as NSError) {
                os_log("An error occurred while trying to save viewContext (Core Data): ", log: .default, type: .error, error)
            }
        }
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

