//
//  ItemsViewController.swift
//  budget
//
//  Created by Sebastian Ruiz on 29/12/2014.
//  Copyright (c) 2014 Sebastian Ruiz. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController, UITableViewDataSource  {

    @IBOutlet weak var tableview: UITableView!
    let meteorData = MeteorData.sharedInstance;
    
    var listName:String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(listName)

        // Do any additional setup after loading the view.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveSelectedGame" {
//            let cell = sender as UITableViewCell
//            let indexPath = tableView.indexPathForCell(cell)
//            selectedGameIndex = indexPath?.row
//            if let index = selectedGameIndex {
//                selectedGame = games[index]
//            }
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = self.listName
        UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "didTouchAdd:")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveUpdate:", name: "added", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didReceiveUpdate:", name: "removed", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func didReceiveUpdate(notification:NSNotification) {
        self.tableview.reloadData()
    }
    
    func computedList() -> NSArray {
        var pred:NSPredicate = NSPredicate(format: "(listName like %@)", self.listName!)!
        let temp = self.meteorData.meteorClient.collections["things"] as M13MutableOrderedDictionary
        let temp2 = temp.allObjects() as NSArray
        return temp2.filteredArrayUsingPredicate(pred)
    }
    
    @IBAction func didTouchAdd(sender: AnyObject) {
//        var addController = AddViewController(nibName: "AddViewController", bundle: nil)
        
//        addController.delegate = self
//        self.presentViewController(addController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.meteorData.meteorClient.collections["things"] != nil){
            
            return self.computedList().count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier:NSString! = "thing"
        var cell:UITableViewCell
        
        if var tmpCell: AnyObject = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) {
            cell = tmpCell as UITableViewCell
        } else {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier) as UITableViewCell
        }
        //If statement prevents crash
        if(self.meteorData.meteorClient.collections["things"] != nil){
            var thing:NSDictionary = self.computedList()[indexPath.row] as NSDictionary
            cell.textLabel?.text = thing["msg"] as? String
            return cell
        }
        cell.textLabel?.text = "dummy"
        return cell
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete) {
            //If statement prevents crash
            if(self.meteorData.meteorClient.collections["things"] != nil){
                var thing:NSDictionary = self.computedList()[indexPath.row] as NSDictionary
                let thingy = thing["_id"] as NSString
                self.meteorData.meteorClient.callMethodName("/things/remove", parameters: [["_id":thingy]], responseCallback: nil)
            }
        }
    }
    
    func didAddThing(message: NSString!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        var parameters:NSArray = [["_id": NSUUID().UUIDString,
            "msg":message,
            "owner":self.meteorData.meteorClient.userId,
            "listName":self.listName]]
        
        self.meteorData.meteorClient.callMethodName("/things/insert", parameters: parameters, responseCallback: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
