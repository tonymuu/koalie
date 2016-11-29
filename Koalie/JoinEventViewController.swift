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
import AWSS3
import NVActivityIndicatorView

class JoinEventViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textfieldHashtag: UITextField!
    
    @IBOutlet weak var buttonNext: UIButton!
    
    var activityIndicator: NVActivityIndicatorView!
    
    @IBAction func editingChanged(_ sender: UITextField) {
        buttonNext.isEnabled = sender.hasText
    }
    
    @IBAction func buttonBackClick(_ sender: AnyObject) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func buttonNextClick(_ sender: AnyObject) {
        let eventName: String = textfieldHashtag.text!
        let dict = ["eventName": eventName]
        
        Alamofire.request(Constants.URIs.baseUri+Constants.routes.searchEvents, method: .get, parameters: dict, encoding: URLEncoding.default).responseJSON {
            response in switch response.result {
            case .success(let data):
                let dict = data as! NSDictionary
                let message = String(describing: dict.object(forKey: "message")!)
                if message == Constants.messages.alreadyJoined {
                    self.presentFailureScreen()
                } else if message == Constants.messages.notFound {
                    self.presentNotFoundScreen()
                } else {
                    let eventId = String(describing: dict.object(forKey: "eventId")!)
                    self.presentSuccessScreen(event: dict, message: message, eventId: eventId)
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
        
        // tap gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        // activity indicator
        let rect = CGRect(origin: CGPoint(x: self.view.center.x - 40.0, y: self.view.center.y - 40.0), size: CGSize(width: 80.0, height: 80.0))
        activityIndicator = NVActivityIndicatorView(frame: rect, type: NVActivityIndicatorType.ballRotateChase, color: nil, padding: nil)
        activityIndicator.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.addSubview(activityIndicator)

        self.textfieldHashtag.delegate = self
        self.textfieldHashtag.returnKeyType = .done
    }
    
    func presentSuccessScreen(event: NSDictionary, message: String, eventId: String) {
        activityIndicator.startAnimating()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmJoinEventVC") as! ConfirmJoinEventViewController
        let coverPictureKey = event.object(forKey: "coverPicture")! as! String
        let totalSpots = String(describing: event.object(forKey: "peopleTotal")!)
        let spotsOpen = String(describing: event.object(forKey: "spotsOpen")!).appending("/").appending(totalSpots)
        let hoursLeft = String(describing: event.object(forKey: "timeLeft")!).appending(" Hours Left")
        let eventName = String(describing: event.object(forKey: "name")!)
        vc.coverPictureKey = coverPictureKey
        vc.spotsOpen = spotsOpen
        vc.hoursLeft = hoursLeft
        vc.eventName = eventName
        vc.message = message
        vc.eventId = eventId
        if coverPictureKey == "" {
            self.present(vc, animated: true, completion: nil)
        } else {
            loadCoverPicture(coverPictureKey: coverPictureKey, vc: vc)
        }
//        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func presentFailureScreen() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AlreadyJoinedVC") as! ErrorViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func presentNotFoundScreen() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventNotFoundVC") as! ErrorViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    func loadCoverPicture(coverPictureKey: String!, vc: ConfirmJoinEventViewController) {
        let transferManager = AWSS3TransferManager.default()
        
        ///// download
        let downloadingFilePath = ConvenientMethods.applicationDocumentsDirectory().appendingPathComponent("Cover Picture").appendingPathExtension("jpg")
        let downloadRequest = AWSS3TransferManagerDownloadRequest()
        downloadRequest?.bucket = "koalie-test-bucket"
        downloadRequest?.key = coverPictureKey
        downloadRequest?.downloadingFileURL = downloadingFilePath
        
        // download request
        
        transferManager?.download(downloadRequest).continue( {(task: AWSTask!) -> AnyObject! in
            if ((task.error) != nil) {
                print(task.error)
            }
            if ((task.result) != nil) {
                let downloadOutput: AWSS3TransferManagerDownloadOutput = task.result as! AWSS3TransferManagerDownloadOutput
                let image: UIImage! = UIImage(contentsOfFile: downloadingFilePath.relativePath)
                DispatchQueue.main.async {
                    vc.coverPicture = image
                    self.present(vc, animated: true, completion: nil)
                }
                return downloadOutput
            }
            return nil
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.activityIndicator.stopAnimating()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return (textField.text?.characters.count)! + string.characters.count > 1
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = "#"
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.characters.count == 1 {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
