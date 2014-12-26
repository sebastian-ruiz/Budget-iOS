//
//  OverviewsListViewController.swift
//  budget
//
//  Created by Sebastian Ruiz on 25/12/2014.
//  Copyright (c) 2014 Sebastian Ruiz. All rights reserved.
//

import Foundation
import UIKit


class OverviewsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableview: UITableView!
    var lists:M13MutableOrderedDictionary!
    
    let meteorData = MeteorData.sharedInstance;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        lists = meteorData.meteorClient.collections["lists"] as M13MutableOrderedDictionary
        println(meteorData.meteorClient.userId)
        println(lists.count())
        
    }
    
    override func viewWillAppear(animated: Bool) {
        meteorData.meteorClient.addObserver(self, forKeyPath: "websocketReady", options: NSKeyValueObservingOptions.New, context: nil)
        self.navigationItem.title = "My Lists"
        self.navigationController?.navigationBarHidden = false
        self.navigationItem.hidesBackButton = true
        
//        var logoutButton:UIBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout")
        
//        self.navigationItem.rightBarButtonItem = logoutButton
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveUpdate:", name: "added", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveUpdate:", name: "removed", object: nil)
        
    }
    
    func didReceiveUpdate(notification:NSNotification) {
        self.tableview.reloadData()
    }
    
    func logout() {
        self.meteorData.meteorClient.logout()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(self.lists.count())
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<()>) {
        
        if (keyPath == "websocketReady" && meteorData.meteorClient.websocketReady) {
            println("reseting, but not")
            
        }
    }
    
    var selectedList:NSDictionary!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("OverviewsCell", forIndexPath: indexPath) as OverviewsCell
        
//        var cellIdentifier:NSString = "OverviewsCell"
//        var cell:UITableViewCell
//        
//        if var tmpCell: AnyObject = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) {
//            cell = tmpCell as OverviewsCell
//        } else {
//            cell = OverviewsCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier) as OverviewsCell
//        }
        
//        let player = players[indexPath.row] as Player
//        cell.textLabel?.text = player.name
//        cell.detailTextLabel?.text = player.game
//        return cell
        cell.frame = CGRectMake(0,0,tableView.frame.size.width, cell.frame.size.height);
        println(tableView.frame.size.width)
        println(indexPath.row)
        var list:NSDictionary = self.lists.objectAtIndex(UInt(indexPath.row)) as NSDictionary
        selectedList = list
//        cell.textLabel?.text = list["name"] as NSString
        cell.cellTitle?.text = list["name"] as NSString
        cell.cellDetail?.text = "Some detail"
        cell.cellDetailRight?.text = "£7.99"
        cell.cellCircleImage?.backgroundColor = UIColor.brownColor()
        cell.cellCircleImage?.layer.cornerRadius = 5
        
//        var shareButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        
//        shareButton.frame = CGRectMake(255.0, 5.0, 55.0, 34.0)
//        shareButton.backgroundColor = UIColor.greenColor()
//        shareButton.setTitle("Share", forState: UIControlState.Normal)
//        shareButton.addTarget(self, action: "didClickShareButton:forEvent:", forControlEvents: .TouchUpInside)
        
//        cell.addSubview(shareButton)
        
        
        return cell
    }
    
    var shareWithTF:UITextField!
    
    func didClickShareButton(sender:AnyObject!,forEvent event:UIEvent!) {
        var touch:UITouch = event.allTouches()!.anyObject() as UITouch
        var location:CGPoint = touch.locationInView(self.view)
        
        var view:UIView = UIView(frame: CGRectMake(0.0, location.y, 320.0, 100.0))
        view.backgroundColor = UIColor.whiteColor()
        var shareWithTextField:UITextField = UITextField(frame: CGRectMake(10.0, 50.0, 240.0, 44.0))
        shareWithTF = shareWithTextField
        shareWithTextField.borderStyle = UITextBorderStyle.Line
        var button:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(255.0, 50.0, 60.0, 44.0)
        button.backgroundColor = UIColor.greenColor()
        button.setTitle("Send", forState: UIControlState.Normal)
        button.addTarget(self, action: "didClickShareWithButton", forControlEvents: .TouchUpInside)
        view .addSubview(shareWithTextField)
        view .addSubview(button)
        
        var modalBackground:UIView = UIView(frame: self.view.frame)
        modalBackground.backgroundColor = UIColor.blackColor()
        modalBackground.alpha = 0.7
        
        self.view .addSubview(modalBackground)
        self.view .addSubview(view)
        
    }
    
    func didClickShareWithButton(sender: AnyObject!) {
        var id = selectedList["_id"] as NSDictionary
        var parameters:NSArray = [["_id":id], ["set": ["share_with":shareWithTF.text]]]
        self.meteorData.meteorClient.callMethodName("/lists/update", parameters: parameters, responseCallback: nil)
        self.view.subviews.last?.removeFromSuperview()
        self.view.subviews.last?.removeFromSuperview()
        
    }
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        var list:NSDictionary = self.lists.objectAtIndex(UInt(indexPath.row)) as NSDictionary
        var id = list["_id"] as NSString
        self.meteorData.meteorClient.callMethodName("/lists/remove", parameters: [["_id":id]], responseCallback: nil)
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var list:NSDictionary = self.lists.objectAtIndex(UInt(indexPath.row)) as NSDictionary
//        var viewController:ViewController = ViewController(nibNameOrNil: "ViewController", bundle: nil, meteor: meteorData.meteorClient, listName: list["name"] as NSString)
//
//        viewController.userId = meteorData.meteorClient.userId
//        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}