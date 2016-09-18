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
    
    @IBAction func buttonBackClick(_ sender: AnyObject) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dict = ["eventName": "a"]
        
        Alamofire.request(Constants.URIs.baseUri+Constants.routes.searchEvents, method: .get, parameters: dict, encoding: URLEncoding.default).responseJSON {
            response in switch response.result {
                case .success(let data):
                    print("Found the following event with name a: \n")
                    print(data)
                    let dataArray = data as! NSArray
                    let dict = dataArray[0] as! NSDictionary
                    let eventId = dict.object(forKey: "_id") as! String
                    let idDict = ["eventId": eventId]
                    Alamofire.request(Constants.URIs.baseUri+Constants.routes.joinEvent, method: .post, parameters: idDict, encoding: URLEncoding.default).responseJSON { response in switch response.result {
                            case .success(let data):
                                print(data)
                            case .failure(let error):
                                print(error)
                        }
                }
                case .failure(let error):
                    print(error)
            }
        }

    }
}
