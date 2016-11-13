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
    @IBOutlet weak var cellLogout: UITableViewCell!

    var delegate: HomeViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let logoutTap = UITapGestureRecognizer(target: self, action: #selector(logout))
        cellLogout.addGestureRecognizer(logoutTap)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func logout() {
        self.delegate.deinitPullToRefresh()
        self.navigationController!.dismiss(animated: true, completion: nil)
        FBSDKLoginManager().logOut()
    }
}

protocol DeinitPullToRefreshDelegate {
    func deinitPullToRefresh();
}
