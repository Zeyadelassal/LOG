//
//  AppDelegate.swift
//  LOG
//
//  Created by zeyadel3ssal on 6/8/19.
//  Copyright © 2019 zeyadel3ssal. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataController = DataController(modelName: "LOG")


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Load data from persistent store on launching the application
        dataController.load()
        
        //Inject data controller to the navigation controller
        let navigationController = window?.rootViewController as! UINavigationController
        let tabBarViewController = navigationController.topViewController as! TabBarViewController
        tabBarViewController.dataController = dataController
     
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        saveViewContext()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveViewContext()
    }
    
    func saveViewContext(){
        try? dataController.viewContext.save()
    }


}

