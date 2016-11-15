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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.insertEmptyTabItem("", atIndex: 1)
        let img = UIImage(named: "Camera Icon.png")
        self.addRaisedButton(img, highlightImage: nil)
    }

    override func onRaisedButton(_ sender: UIButton!) {
        super.onRaisedButton(sender)
        self.dismiss(animated: false, completion: nil)
    }
}
