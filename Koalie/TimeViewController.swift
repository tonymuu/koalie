//
//  TimeViewController.swift
//  Koalie
//
//  Created by Tony Mu on 5/22/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit

class TimeViewController: UIViewController {
    
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var labelUnit: UILabel!
    
    var newEvent: Event?
    
    @IBAction func buttonPlusClick(sender: AnyObject) {
        var num = Int(labelNumber.text!)!
        if (labelUnit.text == "hours" && num == 7) {
            labelNumber.text = String(1)
            labelUnit.text = "days"
        } else if (labelUnit.text == "days" && num == 5) {
            labelNumber.text = String(1)
            labelUnit.text = "week"
        } else if (labelUnit.text != "week") {
            num += 1
            labelNumber.text = String(num)
//            labelUnit.text = num > 1 ? labelUnit.text!+"s" : labelUnit.text
        }
    }
    
    @IBAction func buttonMinusClick(sender: AnyObject) {
        var num = Int(labelNumber.text!)!
        if (labelUnit.text == "week") {
            labelNumber.text = String(5)
            labelUnit.text = "days"
        } else if (labelUnit.text == "days" && num == 1) {
            labelNumber.text = String(7)
            labelUnit.text = "hours"
        } else if (num > 1) {
            num -= 1
            labelNumber.text = String(num)
            //            labelUnit.text = num > 1 ? labelUnit.text!+"s" : labelUnit.text
        }
    }
    
    @IBAction func buttonBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if newEvent != nil {
            print("Received new event object: \(newEvent?.eventName)")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        newEvent?.startDate = NSDate()
        newEvent?.endDate = NSDate()
        
        let destinationVC = segue.destinationViewController as! PeopleViewController
        destinationVC.newEvent = self.newEvent
    }

}
