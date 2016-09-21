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
    
    var newEvent: Event!
    
    
    @IBAction func ButtonBackClick(_ sender: AnyObject) {
        if buttonFirst.isSelected {
            print(1)
        }
        if buttonSecond.isSelected {
            print(2)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ButtonCreateClick(_ sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VCOverview")
        self.present(vc!, animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
        
        let dict = [
            "eventName": self.newEvent!.eventName!,
            "eventSize": String(self.newEvent!.eventSize!),
            "startDate": String(describing: self.newEvent!.startDate!),
            "endDate": String(describing: self.newEvent!.endDate!)
            ]
        
        Alamofire.request(Constants.URIs.baseUri + Constants.routes.createEvent, method: .post, parameters: dict, encoding: URLEncoding.default).responseJSON { response in
            print(response.request)
        }
        
    }
    
    @IBAction func firstSelected(_ sender: AnyObject) {
        
        buttonSecond.backgroundColor = Constants.backgroundColor.dark
        buttonFirst.backgroundColor = Constants.backgroundColor.selected
        
        newEvent.eventSize = 10
    }
    
    @IBAction func secondSelected(_ sender: AnyObject) {
        
        buttonFirst.backgroundColor = Constants.backgroundColor.dark
        buttonSecond.backgroundColor = Constants.backgroundColor.selected
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if newEvent != nil {
            print("Received new event object: \(newEvent?.eventName)")
        }
    }
}
