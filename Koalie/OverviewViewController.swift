//
//  OverviewViewController.swift
//  Koalie
//
//  Created by Tony Mu on 5/24/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController {
    @IBAction func dismissButtonClick(_ sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationReloadData"), object: nil)
        self.presentingViewController?.presentingViewController!.dismiss(animated: true, completion: {
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
