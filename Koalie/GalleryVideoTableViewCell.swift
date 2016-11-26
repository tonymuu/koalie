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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(playVideo))
        player.addGestureRecognizer(tapGestureRecognizer)
        self.addSubview(player)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.player.frame = self.viewPicture.frame
    }
    
    func playVideo(_ sender: UIGestureRecognizer) {
        if self.player.player.isPlaying {
            self.player.player.pause()
        } else {
            self.player.player.play()
        }
    }
    
}
