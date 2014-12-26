//
//  LoginViewController.swift
//  budget
//
//  Created by Sebastian Ruiz on 25/12/2014.
//  Copyright (c) 2014 Sebastian Ruiz. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var connectionStatusLight: UIImageView!
    @IBOutlet weak var connectionStatusText: UILabel!
    
    let meteorData = MeteorData.sharedInstance;
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
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