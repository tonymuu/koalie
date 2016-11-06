//
//  MoreTimeViewController.swift
//  Koalie
//
//  Created by Tony Mu on 11/5/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import Alamofire

class MoreTimeViewController: TimeViewController {
    
    var eventId: String!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction override func buttonBackClick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonAddClick(_ sender: AnyObject) {
        let num: Int = Int(labelNumber.text!)!
        let unit = labelUnit.text
        if (unit == "week") {
            self.length = 168
        } else if (unit == "days") {
            self.length = num * 24
        } else if (unit == "hours") {
            self.length = num
        }
        
        let dict = ["eventId": self.eventId,
                    "length": self.length] as [String : Any]
        Alamofire.request(Constants.URIs.baseUri + Constants.routes.addTime, method: .post, parameters: dict, encoding: URLEncoding.default).responseJSON { response in
            print(response.request)
        }
        dismiss(animated: true, completion: nil)
    }
}
