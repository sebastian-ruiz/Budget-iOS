//
//  OverviewsEditViewController.swift
//  budget
//
//  Created by Sebastian Ruiz on 29/12/2014.
//  Copyright (c) 2014 Sebastian Ruiz. All rights reserved.
//

import UIKit

class OverviewsEditViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    let meteorData = MeteorData.sharedInstance;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func barBtnSave(sender: AnyObject) {
        //        if (fieldTitle?.text != "")  {
        //            if(fieldFriends?.text != "") {
        //
        //            }
        //            if(fieldAdmins?.text != "") {
        //
        //            }
        //            if(fieldInitialBudget?.text != ""){
        //
        //            }
        //            self.dismissViewControllerAnimated(true, completion: nil)
        //            var parameters:NSArray = [["_id": NSUUID().UUIDString,
        //                "name":fieldTitle?.text,
        //                "owner":self.meteorData.meteorClient.userId]]
        //
        //            self.meteorData.meteorClient.callMethodName("/lists/insert", parameters: parameters, responseCallback: nil)
        //        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
