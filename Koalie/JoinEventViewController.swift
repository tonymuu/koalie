//
//  JoinEventViewController.swift
//  Koalie
//
//  Created by Tony Mu on 9/3/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import Alamofire

class JoinEventViewController: UIViewController {
    
    @IBOutlet weak var textfieldHashtag: UITextField!
    
    @IBOutlet weak var buttonNext: UIButton!
    
    @IBAction func buttonBackClick(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict = ["eventName": "a"]
        
        Alamofire.request(.GET, Constants.URIs.baseUri+Constants.routes.searchEvents, parameters: dict, encoding: .URL, headers: nil).responseJSON {
            response in switch response.result {
                case .Success(let data):
                    print("Found the following event with name a: \n")
                    print(data)
                    let dataArray = data as! NSArray
                    let dict = dataArray[0]
                    let eventId = dict.objectForKey("_id") as! String
                    let idDict = ["eventId": eventId]
                    Alamofire.request(.POST, Constants.URIs.baseUri+Constants.routes.joinEvent, parameters: idDict, encoding: .URL, headers: nil).responseJSON { response in switch response.result {
                            case .Success(let data):
                                print(data)
                            case .Failure(let error):
                                print(error)
                        }
                }
                case .Failure(let error):
                    print(error)
            }
        }

    }
}
