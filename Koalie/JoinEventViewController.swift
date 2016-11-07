//
//  JoinEventViewController.swift
//  Koalie
//
//  Created by Tony Mu on 9/3/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import Alamofire
import SCLAlertView

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
                    self.presentNotFoundScreen()
                } else {
                    // if a list of events with same names, default to joining the first event in the list.
                    let dict = dataArray[0] as! NSDictionary
                    let eventId = dict.object(forKey: "_id") as! String
                    let idDict = ["eventId": eventId]
                    Alamofire.request(Constants.URIs.baseUri+Constants.routes.joinEvent, method: .post, parameters: idDict, encoding: URLEncoding.default).responseJSON { response in switch response.result {
                    case .success(let data):
                        let dict = data as! NSDictionary
                        let message = String(describing: dict.object(forKey: "message")!)
                        if message == Constants.messages.alreadyJoined {
                            self.presentFailureScreen()
                        } else if message == Constants.messages.eventfull {
                            self.presentEventFullScreen()
                        } else if message == Constants.messages.success {
                            self.presentSuccessScreen()
                        }
                    case .failure(let error):
                        print(error)
                        }
                    }
                }

            case .failure(let error):
                print(error)
            }
        }
    }
    
    func dismissKeyboard() {
        textfieldHashtag.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func presentSuccessScreen() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VCJoinSuccess")
        self.present(vc!, animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func presentFailureScreen() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AlreadyJoinedVC")
        self.present(vc!, animated: true, completion: nil)
    }
    
    func presentNotFoundScreen() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventNotFoundVC")
        self.present(vc!, animated: true, completion: nil)

//        let alert = SCLAlertView()
//        alert.showTitle("Event Not Found", subTitle: "Did you type in the correct #HashTag", duration: 1.0, completeText: "Done", style: .error, colorStyle: Constants.backgroundColor.hexDark, colorTextButton: Constants.backgroundColor.hexLight)
//        SCLAlertView().showInfo("Event Not Found", subTitle: "Did you type in the correct #HashTag?")
    }
    
    func presentEventFullScreen() {
        SCLAlertView().showError("Event Full", subTitle: "The Event is full, would you like to add yourself?")
    }

}
