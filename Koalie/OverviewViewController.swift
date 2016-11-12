//
//  OverviewViewController.swift
//  Koalie
//
//  Created by Tony Mu on 5/24/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import FBSDKShareKit

class OverviewViewController: UIViewController, FBSDKAppInviteDialogDelegate {
    @IBAction func dismissButtonClick(_ sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationReloadData"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonInviteClick(_ sender: AnyObject) {
        let content = FBSDKAppInviteContent()
        content.appLinkURL = URL(string: Constants.URIs.facebookAppUrl)
        FBSDKAppInviteDialog.show(from: self, with: content, delegate: self)
    }
    
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print("Invite COMPLETED!!!!!")
    }
    
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!) {
        
    }
}
