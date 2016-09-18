//
//  PreviewImageViewController.swift
//  Koalie
//
//  Created by Tony Mu on 9/10/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import AWSS3

class PreviewImageViewController: UIViewController {
    var image = UIImage();
    var imageView = UIImageView();
    var infoLabel = UILabel();
    var cancelButton = UIButton();
    
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
        
        let holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(savePicture))
        self.view.addGestureRecognizer(holdGesture)
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PreviewImageViewController.viewTapped(_:)))
        self.view!.addGestureRecognizer(tapGesture)
    }
    
    func viewTapped(_ gesture: UIGestureRecognizer) {
        self.dismiss(animated: false, completion: { _ in })
    }
    
    func savePicture(_ gesture: UIGestureRecognizer) {
        if gesture.state == .ended {
            print("ended")
            uploadImageToS3()
        }
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
                }
                return nil
            })
            
            
        }
    }
    
}
