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

    func buttonLogoutClick() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        if self.tableView(tableView, cellForRowAt: indexPath) == cellLogout {
            FBSDKLoginManager().logOut()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}
