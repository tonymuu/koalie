//
//  CamViewController.swift
//  Koalie
//
//  Created by Tony Mu on 5/30/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import DKCamera

class CamViewController: DKCamera {
    
    
    func buttonCancelClick() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.didCancel = { () in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.didFinishCapturingImage = { (image: UIImage) in
            print("DKCamera: didFinishCapturingImage")
        }
    }

    override func setupUI() {
        super.setupUI()
        
        let bottomView = self.cameraSwitchButton.superview
        let galleryButton: UIButton = {
            let galleryButton = UIButton()
            galleryButton.addTarget(self, action: #selector(galleryButtonClick), forControlEvents: .TouchUpInside)
            galleryButton.setImage(UIImage(named: "Gallery Icon.png"), forState: .Normal)
            galleryButton.setTitle("Gallery", forState: .Normal)
//            galleryButton.sizeToFit()
            return galleryButton
        }()
        
        galleryButton.frame.origin = CGPoint(x: 40.0, y: ((bottomView?.bounds.height)! - galleryButton.bounds.height) / 2)
        galleryButton.bounds.size = CGSize(width: cameraSwitchButton.bounds.width, height: cameraSwitchButton.bounds.height)
        galleryButton.autoresizingMask = [.FlexibleRightMargin, .FlexibleBottomMargin, .FlexibleTopMargin]
        bottomView!.addSubview(galleryButton)
    }
    
    internal func galleryButtonClick() {
        let galleryVC = self.storyboard!.instantiateViewControllerWithIdentifier("GalleryVC")
        self.presentViewController(galleryVC, animated: true, completion: nil)
    }
    
    
    
    
}
