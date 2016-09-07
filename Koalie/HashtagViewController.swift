//
//  HashtagViewController.swift
//  Koalie
//
//  Created by Tony Mu on 5/10/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit

class HashtagViewController: UIViewController {
    
    @IBOutlet weak var textfieldHashtag: UITextField!
    
    @IBAction func buttonNextClick(sender: AnyObject) {
        
    }
    
    @IBAction func buttonBackClick(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let newEvent = Event()
        newEvent.eventName = textfieldHashtag.text
        
        let destinationVC = segue.destinationViewController as! TimeViewController
        destinationVC.newEvent = newEvent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
