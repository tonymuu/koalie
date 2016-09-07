//
//  PeopleViewController.swift
//  Koalie
//
//  Created by Tony Mu on 5/11/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKLoginKit

class PeopleViewController: UIViewController {
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var centerConstraints: NSLayoutConstraint!
    @IBOutlet weak var buttonFirst: UIButton!
    @IBOutlet weak var buttonSecond: UIButton!
    @IBOutlet weak var buttonCreate: UIButton!
    @IBOutlet weak var textfieldNumOfPeople: UITextField!
    @IBOutlet weak var labelCost: UILabel!
    @IBOutlet weak var labelHowMany: UILabel!
    
    var newEvent: Event!
    
    
    @IBAction func ButtonBackClick(sender: AnyObject) {
        if buttonFirst.selected {
            print(1)
        }
        if buttonSecond.selected {
            print(2)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func ButtonCreateClick(sender: AnyObject) {
        newEvent?.eventSize = 10
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("VCOverview")
        self.presentViewController(vc!, animated: true, completion: nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
        
        let dict = [
            "eventName": self.newEvent!.eventName,
            "eventSize": String(self.newEvent!.eventSize),
            "startDate": String(self.newEvent!.startDate),
            "endDate": String(self.newEvent!.endDate),
        ]
        
        Alamofire.request(.POST, Constants.URIs.baseUri + Constants.routes.createEvent, parameters: dict, encoding: .URL, headers: nil).responseJSON { response in
            print(response.request)
        }
    }
    
    @IBAction func firstSelected(sender: AnyObject) {
        
        buttonSecond.backgroundColor = Constants.backgroundColor.dark
        buttonFirst.backgroundColor = Constants.backgroundColor.selected
        
        //update constraints + setNeedsUpdateConstraints + layoutIfNeeded in animation block to avoid jumping 
        self.topConstraint.constant = 32.0
        buttonCreate.setNeedsUpdateConstraints()
        
        if (!labelCost.hidden) {
            UIView.animateWithDuration(0.35, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    () -> Void in
//                    self.buttonCreate.center.x -= 80.0
                self.buttonCreate.layoutIfNeeded()
                    }, completion: nil)
            UIView.animateWithDuration(0.1, delay: 0.35, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                () -> Void in
                self.labelHowMany.hidden = true
                self.textfieldNumOfPeople.hidden = true
                self.labelCost.hidden = true
                }, completion: nil)
        }
    }
    
    @IBAction func secondSelected(sender: AnyObject) {
        
        buttonFirst.backgroundColor = Constants.backgroundColor.dark
        buttonSecond.backgroundColor = Constants.backgroundColor.selected
        
        self.topConstraint.constant = 150.0
        buttonCreate.setNeedsUpdateConstraints()
        
        if (labelCost.hidden) {
            UIView.animateWithDuration(0.35, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                () -> Void in
//                self.buttonCreate.center.x += 80.0
                self.buttonCreate.layoutIfNeeded()
                }, completion: nil)
            UIView.animateWithDuration(0.1, delay: 0.35, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                () -> Void in
                
                self.labelHowMany.hidden = false
                self.textfieldNumOfPeople.hidden = false
                self.labelCost.hidden = false
                }, completion: nil)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if newEvent != nil {
            print("Received new event object: \(newEvent?.eventName)")
        }
    }
}
