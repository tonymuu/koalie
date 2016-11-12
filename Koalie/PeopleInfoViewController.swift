//
//  PeopleInfoViewController.swift
//  Koalie
//
//  Created by Tony Mu on 11/9/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit

class PeopleInfoViewController: UIViewController {

    
    @IBOutlet weak var labelUserTotal: UILabel!
    @IBOutlet weak var labelOpenSpots: UILabel!
    @IBOutlet weak var tableViewFriendList: UITableView!
    
    var eventId: String!
    var userTotal: String!
    var eventSize: String!
    var users: [NSDictionary]!
    var addPeopleBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewFriendList.dataSource = self
        self.tableViewFriendList.delegate = self
        
        let openSpots = String(describing: Int(eventSize)! - Int(userTotal)!)
        self.labelOpenSpots.text = openSpots
        self.labelUserTotal.text = userTotal
        addPeopleBarButton = UIBarButtonItem(title: "Add People", style: .plain, target: self, action: #selector(showAddPeopleVC))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = addPeopleBarButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func showAddPeopleVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPeopleVC") as! MorePeopleViewController
        vc.eventId = eventId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PeopleInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as! FriendListTableViewCell
        let user = users[indexPath.row].object(forKey: "facebook") as! NSDictionary
        let name = user.object(forKey: "name") as! String
        let profileImageUrl = URL(string: user.object(forKey: "picture") as! String)
        let profileImage: UIImage?
        if let imgData = try? Data(contentsOf: profileImageUrl!) {
            profileImage = UIImage(data: imgData)
            cell.imageViewProfile.image = profileImage!
        }
        cell.labelName.text = name
        return cell
    }
}
