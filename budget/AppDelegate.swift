//
//  AppDelegate.swift
//  budget
//
//  Created by Sebastian Ruiz on 23/12/2014.
//  Copyright (c) 2014 Sebastian Ruiz. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navController: UINavigationController!
    let meteorData = MeteorData.sharedInstance;
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        FBLoginView.self
        FBProfilePictureView.self
        
        var loginController:LoginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        self.navController = UINavigationController(rootViewController:loginController)
        self.navController.navigationBarHidden = true
        
        //This needs to be modified to fix the screen size issue. (Currently a Bug)
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = self.navController
        self.window!.makeKeyAndVisible()
//        println(self.window?.frame)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reportConnection", name: MeteorClientDidConnectNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reportDisconnection", name: MeteorClientDidDisconnectNotification, object: nil)
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: NSString?, annotation: AnyObject) -> Bool{
        var wasHandled:Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication)
        return wasHandled
    }

    
    func reportConnection() {
        println("================> connected to server!")
        
//        self.meteorData.meteorClient.callMethodName("sayHelloTo", parameters:["blah!"], responseCallback: {(response, error) -> Void in
//            println(error);
////          var message:NSString! = response["result"] as NSString
////          UIAlertView(title: "Meteor Todos", message: message, delegate: nil, cancelButtonTitle:"Great").show()
//        })
    }
    
    func reportDisconnection() {
        println("================> disconnected from server!")
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
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

