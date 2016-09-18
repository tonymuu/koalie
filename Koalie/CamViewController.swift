//
//  CamViewController.swift
//  Koalie
//
//  Created by Tony Mu on 5/30/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit

class CamViewController: DKCamera, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func buttonCancelClick() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        self.didCancel = { () in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.didFinishCapturingImage = { (image: UIImage) in
            print("DKCamera: didFinishCapturingImage")
            
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .Camera
            
            self.presentViewController(picker, animated: true, completion: nil)
            
            
        }
    }

    override func setupUI() {
        super.setupUI()
        
        let bottomView = self.cameraSwitchButton.superview
        let galleryButton: UIButton = {
            let galleryButton = UIButton()
            galleryButton.addTarget(self, action: #selector(galleryButtonClick), for: .touchUpInside)
            galleryButton.setImage(UIImage(named: "Gallery Icon.png"), for: UIControlState())
            galleryButton.setTitle("Gallery", for: UIControlState())
//            galleryButton.sizeToFit()
            return galleryButton
        }()
        
        galleryButton.frame.origin = CGPoint(x: 40.0, y: ((bottomView?.bounds.height)! - galleryButton.bounds.height) / 2)
        galleryButton.bounds.size = CGSize(width: cameraSwitchButton.bounds.width, height: cameraSwitchButton.bounds.height)
        galleryButton.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin, .flexibleTopMargin]
        bottomView!.addSubview(galleryButton)
    }
    
    internal func galleryButtonClick() {
        let galleryVC = self.storyboard!.instantiateViewControllerWithIdentifier("GalleryVC")
        self.presentViewController(galleryVC, animated: true, completion: nil)
    }
    
    
    
    
}
