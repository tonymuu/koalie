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

    @IBAction func buttonNextClick(_ sender: AnyObject) {
        let eventName: String = textfieldHashtag.text!
        let dict = ["eventName": eventName]
        
        Alamofire.request(Constants.URIs.baseUri+Constants.routes.searchEvents, method: .get, parameters: dict, encoding: URLEncoding.default).responseJSON {
            response in switch response.result {
            case .success(let data):
                print("Found the following event with name a: \n")
                print(data)
                let dataArray = data as! NSArray
                if dataArray.count == 0 {
                    print("Did not find any event with the name provided")
                } else {
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
                    self.presentSuccessScreen()
                }

            case .failure(let error):
                print(error)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func presentSuccessScreen() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VCJoinSuccess")
        self.present(vc!, animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func presentFailureScreen() {
        
    }
}
