//
//  EventTableViewCell.swift
//  Koalie
//
//  Created by Tony Mu on 5/11/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit

protocol PresentInfoViewProtocol: NSObjectProtocol {
    func presentInfoView(controller: UIViewController) -> Void;
}

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var labelEvent: UILabel!
    @IBOutlet weak var labelProgress: UILabel!
    @IBOutlet weak var labelSize: UILabel!
    @IBOutlet weak var viewOverLay: UIView!
    
    weak var delegate: PresentInfoViewProtocol?
    var isAdmin: Bool!
    var eventId: String!
    var eventImage: UIImage?
    var hoursLong: String!
    var hoursLeft: String!
    var eventSize: String!
    var userTotal: String!
    var users: [NSDictionary]!
    var x: Double!
    var y: Double!
    var userId: String!
    
    @IBAction func buttonInfoClick(_ sender: AnyObject) {
        let storybard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storybard.instantiateViewController(withIdentifier: "InfoVC") as! InfoViewController
        vc.isEnded = Int(self.hoursLeft)! > 0
        vc.eventId = self.eventId
        vc.eventName = self.labelEvent.text
        vc.timeLeft = self.labelProgress.text
        vc.eventImage = self.eventImage
        vc.hoursLong = self.hoursLong
        vc.hoursLeft = self.hoursLeft
        vc.userTotal = self.userTotal
        vc.eventSize = self.eventSize
        vc.users = self.users
        vc.userId = self.userId
        vc.x = x
        vc.y = y
        delegate?.presentInfoView(controller: vc)
    }
}
