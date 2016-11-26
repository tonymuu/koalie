//
//  GalleryTabBarViewController.swift
//  Koalie
//
//  Created by Tony Mu on 11/13/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit

class GalleryTabBarViewController: RaisedTabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.insertEmptyTabItem("", atIndex: 1)
        let img = UIImage(named: "Camera_Icon")
        self.addRaisedButton(img, highlightImage: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func onRaisedButton(_ sender: UIButton!) {
        super.onRaisedButton(sender)
        self.dismiss(animated: false, completion: nil)
    }
}
