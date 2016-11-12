//
//  TimeInfoViewController.swift
//  Koalie
//
//  Created by Tony Mu on 11/9/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit

class TimeInfoViewController: UIViewController {

    @IBOutlet weak var labelHoursLeft: UILabel!
    @IBOutlet weak var labelHoursLong: UILabel!
    
    var eventId: String!
    var timeLeft: String!
    var hoursLeft: String!
    var hoursLong: String!
    var addTimeBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelHoursLeft.text = hoursLeft
        self.labelHoursLong.text = hoursLong
        addTimeBarButton = UIBarButtonItem(title: "Add Time", style: .plain, target: self, action: #selector(showAddTimeVC))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.rightBarButtonItem = addTimeBarButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func showAddTimeVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddTimeVC") as! MoreTimeViewController
        vc.eventId = eventId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
