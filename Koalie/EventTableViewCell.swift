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
    
    weak var delegate: PresentInfoViewProtocol?
    var eventId: String!
    var eventImage: UIImage?
    
    @IBAction func buttonInfoClick(_ sender: AnyObject) {
        let storybard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storybard.instantiateViewController(withIdentifier: "InfoVC") as! InfoViewController
        let navigationVC = UINavigationController(rootViewController: vc)
        vc.eventId = self.eventId
        vc.eventName = self.labelEvent.text
        vc.timeLeft = self.labelProgress.text
        vc.eventImage = self.eventImage
        navigationVC.isNavigationBarHidden = true
        navigationVC.navigationBar.backgroundColor = Constants.backgroundColor.dark
        delegate?.presentInfoView(controller: navigationVC)
    }
}
