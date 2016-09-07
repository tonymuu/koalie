//
//  HomeViewController.swift
//  Koalie
//
//  Created by Tony Mu on 5/8/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import DKCamera
import Alamofire
import FBSDKLoginKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var labelInstructional: UILabel!
    
    var numberOfRows = 0
    
    var userData: NSDictionary!
    var eventDataList: [NSDictionary]!
    
    
    @IBAction func buttonLogoutClick(sender: AnyObject) {
        FBSDKLoginManager().logOut()
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.delegate = self
        eventTableView.dataSource = self
        
        eventDataList = userData.objectForKey("events") as! [NSDictionary]
        
        numberOfRows = eventDataList.count
        
        print(eventDataList)
        print(numberOfRows)
        
        if numberOfRows != 0 {
            labelInstructional.text = ""
        }
        
        self.navigationItem.titleView = generateProfileImageView(userData.objectForKey("picture") as! String)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
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
        
        let eventData = eventDataList[indexPath.row]
        
        cell.labelEvent.text = eventData.objectForKey("name") as? String
        
        return cell;
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        let camVC = self.storyboard!.instantiateViewControllerWithIdentifier("CameraView")
        
        self.presentViewController(camVC, animated: true, completion: nil)
        
        return indexPath

    }
    
    private func generateProfileImageView(urlString: String) -> UIView {
        let hw = self.navigationController?.navigationBar.frame.size.height
        let imgViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let imgView = UIImageView(frame: imgViewContainer.frame)
        let url = NSURL(string: urlString)
        if let imgData = NSData(contentsOfURL: url!) {
            imgView.image = UIImage(data: imgData)
        }
        imgViewContainer.layer.cornerRadius = hw! / 2
        imgViewContainer.layer.borderWidth = 1.5
        imgViewContainer.layer.borderColor = (UIColor.whiteColor()).CGColor
        imgViewContainer.clipsToBounds = true
        imgView.contentMode = .ScaleAspectFill
        
        imgViewContainer.addSubview(imgView)

        return imgViewContainer
    }
}
