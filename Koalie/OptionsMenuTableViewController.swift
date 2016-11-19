//
//  OptionsMenuTableViewController.swift
//  Koalie
//
//  Created by Tony Mu on 9/7/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class OptionsMenuTableViewController: UITableViewController {

    @IBOutlet weak var viewLogout: UIView!
    
    var delegate: HomeViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let logoutTap = UITapGestureRecognizer(target: self, action: #selector(logout))
        viewLogout.addGestureRecognizer(logoutTap)
        self.viewLogout.layer.zPosition = 1
        self.navigationItem.title = "Settings"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
//        let backButton = UIBarButtonItem(image: UIImage(named: "Back Arrow Icon"), style: .plain, target: self, action: nil)
//        self.navigationItem.setRightBarButton(backButton, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 2 {
//            logout()
//        }
    }
    
    func logout() {
        self.delegate.deinitPullToRefresh()
        FBSDKLoginManager().logOut()
        self.navigationController!.dismiss(animated: true, completion: nil)
    }
}

protocol DeinitPullToRefreshDelegate {
    func deinitPullToRefresh();
}
