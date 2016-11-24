//
//  MorePeopleViewController.swift
//  Koalie
//
//  Created by Tony Mu on 11/5/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import Alamofire
import SCLAlertView

class MorePeopleViewController: PeopleViewController {

    var eventId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction override func ButtonBackClick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonAddClick(_ sender: AnyObject) {
        let dict = ["eventId": self.eventId,
                    "size": self.size] as [String : Any]
        Alamofire.request(Constants.URIs.baseUri + Constants.routes.addPeople, method: .post, parameters: dict, encoding: URLEncoding.default).responseJSON { response in
            print(response.request ?? "Response")
            SCLAlertView().showSuccess("Success!", subTitle: "Congratz! You just added \(self.size!) people!")
        }
    }
}
