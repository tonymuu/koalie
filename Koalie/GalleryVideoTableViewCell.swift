//
//  GalleryVideoTableViewCell.swift
//  Koalie
//
//  Created by Tony Mu on 9/25/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import VIMVideoPlayer


class GalleryVideoTableViewCell: GalleryTableViewCell, VIMVideoPlayerViewDelegate {
    
    let player = VIMVideoPlayerView()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.player.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
