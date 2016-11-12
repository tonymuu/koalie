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
    var eventId: String!
    var userTotal: String!
    var eventSize: String!
    
    var addPeopleBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
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
