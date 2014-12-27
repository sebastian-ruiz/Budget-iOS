//
//  OverviewsAddController.swift
//  budget
//
//  Created by Sebastian Ruiz on 27/12/2014.
//  Copyright (c) 2014 Sebastian Ruiz. All rights reserved.
//

import Foundation
import UIKit


class OverviewsAddController: UIViewController {

    @IBOutlet weak var fieldTitle: UITextField!
    @IBOutlet weak var fieldFriends: UITextField!
    @IBOutlet weak var fieldAdmins: UITextField!
    @IBOutlet weak var fieldInitialBudget: UITextField!
    

    
    let meteorData = MeteorData.sharedInstance;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func barBtnSave(sender: AnyObject) {
        if (fieldTitle?.text != "")  {
            if(fieldFriends?.text != "") {
                
            }
            if(fieldAdmins?.text != "") {
                
            }
            if(fieldInitialBudget?.text != ""){
                
            }
            self.dismissViewControllerAnimated(true, completion: nil)
            var parameters:NSArray = [["_id": NSUUID().UUIDString,
                "name":fieldTitle?.text,
                "owner":self.meteorData.meteorClient.userId]]
            
            self.meteorData.meteorClient.callMethodName("/lists/insert", parameters: parameters, responseCallback: nil)
        }
    }
    

}