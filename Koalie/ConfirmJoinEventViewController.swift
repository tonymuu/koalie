//
//  ConfirmJoinEventViewController.swift
//  Koalie
//
//  Created by Tony Mu on 11/12/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import AWSS3
import Alamofire

class ConfirmJoinEventViewController: UIViewController {
    @IBOutlet weak var labelEventName: UILabel!
    @IBOutlet weak var labelTimeLeft: UILabel!
    @IBOutlet weak var labelSpotsOpen: UILabel!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var imageViewCoverPicture: UIImageView!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    
    
    var coverPictureKey: String!
    var spotsOpen: String!
    var hoursLeft: String!
    var coverPicture: UIImage!
    var eventName: String!
    var message: String!
    var eventId: String!
    var peopleTotal: String!
    
    @IBAction func buttonConfirmClick(_ sender: Any) {
        let dict = ["eventId": eventId!]
        Alamofire.request(Constants.URIs.baseUri + Constants.routes.joinEvent, method: .post, parameters: dict, encoding: URLEncoding.default).responseJSON {
            response in switch response.result {
            case .success(let data):
                print("successfully joined")
            case .failure(let error):
                print(error)
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "UnknownErrorVC")
//                self.present(vc!, animated: true, completion: nil)
            }
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VCOverview") as! OverviewViewController
        vc.eventName = self.eventName
        vc.labelString = Constants.labelStrings.joinSuccess
        self.present(vc, animated: true, completion: nil)

    }
    @IBAction func buttonCancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageViewCoverPicture.image = self.coverPicture
        self.labelTimeLeft.text = self.hoursLeft
        self.labelSpotsOpen.text = self.spotsOpen
        self.labelEventName.text = self.eventName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.message != "Success" {
            labelMessage.text = "The event is full!"
            
            buttonConfirm.isHidden = true
            buttonCancel.frame = buttonConfirm.frame
            buttonCancel.titleLabel?.text = "Back"
            buttonCancel.titleLabel?.textColor = Constants.backgroundColor.light
        }
    }
    
    
}
