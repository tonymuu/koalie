//
//  PreviewImageViewController.swift
//  Koalie
//
//  Created by Tony Mu on 9/10/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import AWSS3
import Alamofire

class PreviewImageViewController: UIViewController {
    var image = UIImage()
    var imageView = UIImageView()
    var infoLabel = UILabel()
    var cancelButton = UIButton()
    var eventId: String!
    var storedPath: String!
    
    convenience init(image: UIImage) {
        self.init(nibName: nil, bundle: nil)
        self.image = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.imageView.backgroundColor = UIColor.black
        let screenRect: CGRect = UIScreen.main.bounds
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height))
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.backgroundColor = UIColor.clear
        self.imageView.image = self.image
        self.view!.addSubview(self.imageView)
        
        let confirmButton = UIButton(type: .custom)
        confirmButton.frame = CGRect(x: screenRect.size.width - 72.0, y: screenRect.size.height - 90, width: 60.0, height: 60.0)
        confirmButton.tintColor = UIColor.white
        confirmButton.setImage(UIImage(named: "Keep_Icon") , for: UIControlState())
        confirmButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        confirmButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        self.view.addSubview(confirmButton)
        
        let cancelButton = UIButton(type: .custom)
        cancelButton.frame = CGRect(x: 12.0, y: screenRect.size.height - 90, width: 60.0, height: 60.0)
        cancelButton.tintColor = UIColor.white
        cancelButton.setImage(UIImage(named: "Discard_Icon") , for: UIControlState())
        cancelButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        self.view.addSubview(cancelButton)

        
//        let galleryButton = UIButton(type: .system)
//        self.galleryButton.frame = CGRect(x: 12.0, y: screenRect.size.height - 60, width: 29.0 + 20.0, height: 22.0 + 20.0)
//        self.galleryButton.tintColor = UIColor.white
//        self.galleryButton.setImage(UIImage(named: "Gallery Icon.png"), for: UIControlState())
//        self.galleryButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
//        self.galleryButton.addTarget(self, action: #selector(galleryButtonClick), for: .touchUpInside)
//        self.view!.addSubview(self.galleryButton)

        
//        let holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(savePicture))
//        self.view.addGestureRecognizer(holdGesture)
//        
//        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PreviewImageViewController.viewTapped(_:)))
//        self.view!.addGestureRecognizer(tapGesture)
    }
    
    func cancel(_ gesture: UIGestureRecognizer) {
        self.dismiss(animated: false, completion: { _ in })
    }
    
    func save() {
        uploadImageToS3()
        self.dismiss(animated: false, completion: { _ in })
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.imageView.frame = self.view.bounds
    }
    
    func uploadImageToS3() {
        let transferManager = AWSS3TransferManager.default()
        
        if let data = UIImageJPEGRepresentation(self.image, 0.8) {
            let uploadRequest = AWSS3TransferManagerUploadRequest()
            let filename = ConvenientMethods.getDocumentsDirectory() + ("/"+UUID().uuidString+".jpg")
            print(filename)
            try? data.write(to: URL(fileURLWithPath: filename), options: [.atomic])
            uploadRequest?.bucket = "koalie-test-bucket"
            uploadRequest?.key = filename
            uploadRequest?.body = URL(fileURLWithPath: filename)
            
            // upload request
            
            transferManager?.upload(uploadRequest).continue( {(task: AWSTask!) -> AnyObject! in
                if (task.error != nil) {
                    print(task.error)
                }
                if (task.result != nil) {
                    let uploadOutput = task.result
                    print(uploadOutput)
                    let dict = ["eventId": self.eventId!, "storedPath": filename]
                    Alamofire.request(Constants.URIs.baseUri.appending(Constants.routes.createMedia), method: .post, parameters: dict, encoding: URLEncoding.default).responseJSON { response in
                        print(response)
                    }
                }
                return nil
            })
            
            
        }
    }
    
}
