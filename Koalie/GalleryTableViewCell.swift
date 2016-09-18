//
//  GalleryTableViewCell.swift
//  Koalie
//
//  Created by Tony Mu on 6/2/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewPicture: UIImageView!
    @IBOutlet weak var labelUpvotes: UILabel!
    @IBOutlet weak var buttonUpvote: UIButton!
    
    @IBOutlet weak var buttonDownvote: UIButton!

    @IBOutlet weak var buttonDownload: UIButton!
    
    @IBAction func buttonUpvoteClick(_ sender: AnyObject) {
        buttonUpvote.isSelected = true
        buttonDownvote.isSelected = false
        labelUpvotes.text = "1"
    }
    
    @IBAction func buttonDownvoteClick(_ sender: AnyObject) {
        buttonDownvote.isSelected = true
        buttonUpvote.isSelected = false
        labelUpvotes.text = "0"
    }
    
    
    @IBAction func buttonDownloadClick(_ sender: AnyObject) {
        buttonDownload.isSelected = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
