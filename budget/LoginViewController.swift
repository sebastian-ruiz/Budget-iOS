//
//  LoginViewController.swift
//  budget
//
//  Created by Sebastian Ruiz on 25/12/2014.
//  Copyright (c) 2014 Sebastian Ruiz. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, FBLoginViewDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var connectionStatusLight: UIImageView!
    @IBOutlet weak var connectionStatusText: UILabel!
    
    let meteorData = MeteorData.sharedInstance;
    
    
    @IBOutlet weak var fbLoginView: FBLoginView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
        
    }
    
    // Facebook Delegate Methods
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        println("User: \(user)")
        println("User ID: \(user.objectID)")
        println("User Name: \(user.name)")
        var userEmail = user.objectForKey("email") as NSString
        println("User Email: \(userEmail)")
        
        var userToken = FBSession.activeSession().accessTokenData.accessToken
        println("User Access Token: \(userToken)")
        
        // TODO: fix bug that requires tiny delay.
//        let delay = 0.01 * Double(NSEC_PER_SEC)
//        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//        dispatch_after(time, dispatch_get_main_queue()) { self.sendUserToken(userEmail, userToken: userToken) }
        
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    override func viewWillAppear(animated: Bool) {
        var observingOption = NSKeyValueObservingOptions.New
        meteorData.meteorClient.addObserver(self, forKeyPath:"websocketReady", options: observingOption, context:nil)
    }
    
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<()>) {
        
        if (keyPath == "websocketReady" && meteorData.meteorClient.websocketReady) {
            println("Connected!")
            connectionStatusText.text = "Connected to Todo Server"
            var image:UIImage = UIImage(named: "green_light.png")!
            connectionStatusLight.image = image
        }
    }
    
    func sendUserToken(userEmail:NSString, userToken:NSString) {
        self.meteorData.meteorClient.callMethodName("setUserAccessToken", parameters:[userEmail, userToken], responseCallback: {(response, error) -> Void in
            var message:NSString! = response["result"] as NSString
            UIAlertView(title: "Meteor Todos", message: message, delegate: nil, cancelButtonTitle:"Great").show()
        })
    }
    
    
    @IBAction func didTapLoginButton(sender: AnyObject) {
        if (!meteorData.meteorClient.websocketReady) {
            let notConnectedAlert = UIAlertView(title: "Connection Error", message: "Can't find the Todo server, try again", delegate: nil, cancelButtonTitle: "OK")
            notConnectedAlert.show()
            return
        }
        
        meteorData.meteorClient.logonWithEmail(self.email.text, password: self.password.text, responseCallback: {(response, error) -> Void in
            
            if((error) != nil) {
                self.handleFailedAuth(error)
                return
            }
            self.handleSuccessfulAuth()
        })
    }
    
    func handleSuccessfulAuth() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var vc : MainTabBarController = storyboard.instantiateViewControllerWithIdentifier("MainTabBarController") as MainTabBarController
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func handleFailedAuth(error: NSError) {
        UIAlertView(title: "Meteor Todos", message:error.localizedDescription, delegate: nil, cancelButtonTitle: "Try Again").show()
    }
    
    @IBAction func didTapSayHiButton(sender: AnyObject) {
        self.meteorData.meteorClient.callMethodName("sayHelloTo", parameters:[self.email.text], responseCallback: {(response, error) -> Void in
            var message:NSString! = response["result"] as NSString
            UIAlertView(title: "Meteor Todos", message: message, delegate: nil, cancelButtonTitle:"Great").show()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}