//
//  EventTableViewCell.swift
//  Koalie
//
//  Created by Tony Mu on 5/11/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var labelEvent: UILabel!
    @IBOutlet weak var labelProgress: UILabel!
    
//    @IBAction func buttonInfoClick(sender: AnyObject) {
//        
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
