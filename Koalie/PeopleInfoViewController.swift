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
    var usersSearchResult: [NSDictionary]!
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
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.usersSearchResult?.count ?? 0
        } else {
            return self.users?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewFriendList!.dequeueReusableCell(withIdentifier: "FriendListCell") as! FriendListTableViewCell
        var arrayOfUsers: [NSDictionary]?
        if tableView == self.searchDisplayController!.searchResultsTableView {
            arrayOfUsers = self.usersSearchResult
        } else {
            arrayOfUsers = self.users
        }
        
        if arrayOfUsers != nil && arrayOfUsers!.count >= indexPath.row
        {
            let user = arrayOfUsers![indexPath.row].object(forKey: "facebook") as! NSDictionary
//            let user = users[indexPath.row].object(forKey: "facebook") as! NSDictionary
            let name = user.object(forKey: "name") as! String
            let profileImageUrl = URL(string: user.object(forKey: "picture") as! String)
            let profileImage: UIImage?
            if let imgData = try? Data(contentsOf: profileImageUrl!) {
                profileImage = UIImage(data: imgData)
                cell.imageViewProfile.image = profileImage!
            }
            cell.labelName.text = name
            
            if tableView != self.searchDisplayController!.searchResultsTableView {
                // Load more species if needed
                // see http://grokswift.com/rest-tableview-in-swift/ for details
            }
        }
        
        return cell
    }
}

extension PeopleInfoViewController: UISearchBarDelegate, UISearchDisplayDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        if self.users == nil {
            self.usersSearchResult = nil
            return
        }
        self.usersSearchResult = self.users.filter({( user: NSDictionary) -> Bool in
            // to start, let's just search by name
            return ((user.object(forKey: "facebook") as! NSDictionary).object(forKey: "name") as! String).lowercased().range(of: searchText.lowercased()) != nil
        })
    }
    
    func searchDisplayController(_ controller: UISearchDisplayController, shouldReloadTableForSearch searchString: String?) -> Bool {
        self.filterContentForSearchText(searchText: searchString!)
        return true
    }
}
