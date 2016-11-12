//
//  FullscreenImageViewController.swift
//  Koalie
//
//  Created by Tony Mu on 11/11/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit

class FullscreenImageViewController: UIViewController {
    
    @IBOutlet weak var viewImage: UIImageView!
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewImage.image = image
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreen))
        self.viewImage.isUserInteractionEnabled = true
        self.viewImage.addGestureRecognizer(tapRecognizer)
    }
    
    func dismissFullscreen() {
        self.dismiss(animated: true, completion: nil)
    }
}
