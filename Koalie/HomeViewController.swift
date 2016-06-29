//
//  HomeViewController.swift
//  Koalie
//
//  Created by Tony Mu on 5/8/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import DKCamera

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var eventTableView: UITableView!
    
    var numberOfRows = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = Constants.backgroundColor.light
//        
//        eventTableView.backgroundColor = Constants.backgroundColor.light
        eventTableView.delegate = self
        eventTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150;
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            numberOfRows -= 1
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventTableViewCell
        
        if (indexPath.row == 0) {
            cell.labelEvent.text = "#THANKSGIVINGDAY"
        } else if (indexPath.row == 1) {
            cell.labelEvent.text = "#HikingTrip"
        } else {
            cell.labelEvent.text = "#JustARandomEventForFun"
        }
        
        
        return cell;
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        let camVC = self.storyboard!.instantiateViewControllerWithIdentifier("CameraView")
        
        self.presentViewController(camVC, animated: true, completion: nil)
        
        return indexPath

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
