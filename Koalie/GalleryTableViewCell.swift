//
//  GalleryTableViewCell.swift
//  Koalie
//
//  Created by Tony Mu on 6/2/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {
    @IBOutlet weak var viewPicture: UIView!
    
    @IBOutlet weak var labelUpvotes: UILabel!
    @IBOutlet weak var buttonUpvote: UIButton!
    
    @IBOutlet weak var buttonDownvote: UIButton!

    @IBOutlet weak var buttonDownload: UIButton!
    
    @IBAction func buttonUpvoteClick(sender: AnyObject) {
        buttonUpvote.selected = true
        buttonDownvote.selected = false
        labelUpvotes.text = "1"
    }
    
    @IBAction func buttonDownvoteClick(sender: AnyObject) {
        buttonDownvote.selected = true
        buttonUpvote.selected = false
        labelUpvotes.text = "0"
    }
    
    
    @IBAction func buttonDownloadClick(sender: AnyObject) {
        buttonDownload.selected = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
