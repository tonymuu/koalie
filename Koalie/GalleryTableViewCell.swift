//
//  GalleryTableViewCell.swift
//  Koalie
//
//  Created by Tony Mu on 6/2/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import Alamofire

protocol GalleryTableViewCellDelegate {
//    func presentImageFullscreen(imageView: UIImageView) -> Void;
    func presentActionSheet(actionSheet: UIAlertController);
}


class GalleryTableViewCell: UITableViewCell {
    @IBOutlet weak var viewPicture: UIImageView!
    @IBOutlet weak var labelUpvotes: UILabel!
    @IBOutlet weak var buttonUpvote: UIButton!
    @IBOutlet weak var buttonDownload: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    
    var actionSheet: UIAlertController!
    
    
    var voted: Bool!
    var upvotes: Int = 0
    var eventId: String!
    var mediaId: String!
    
    var delegate: GalleryTableViewCellDelegate!
    
    @IBAction func buttonEditClick(_ sender: AnyObject) {
        actionSheet = UIAlertController(title: "Edit", message: "Make changes", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            UIAlertAction -> Void in
            
        })
        let reportAction = UIAlertAction(title: "Report", style: .default, handler: {
            UIAlertAction -> Void in
        })
        let downloadAction = UIAlertAction(title: "Download", style: .default, handler: {
            UIAlertAction -> Void in
            print("Download click")
        })
        actionSheet.addAction(downloadAction)
        actionSheet.addAction(reportAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.delegate.presentActionSheet(actionSheet: actionSheet)
    }
    
    
    @IBAction func buttonUpvoteClick(_ sender: AnyObject) {
        if !voted {
            upvotes = Int(labelUpvotes.text!)!
            voted = true
            buttonUpvote.isSelected = true
            upvotes += 1
            labelUpvotes.text = String(describing: upvotes)
            updateUpvotes(upvotes: upvotes)
        }
    }
    
    @IBAction func buttonDownloadClick(_ sender: AnyObject) {
        if !buttonDownload.isSelected {
            buttonDownload.isSelected = true
            UIImageWriteToSavedPhotosAlbum(self.viewPicture.image!, nil, nil, nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func updateUpvotes(upvotes: Int) {
        if !buttonUpvote.isSelected {
            let dict = [
                "likes": upvotes,
                "mediaId": mediaId] as [String : Any]
            Alamofire.request(Constants.URIs.baseUri + Constants.routes.postUpvotes, method: .post, parameters: dict, encoding: URLEncoding.default).responseJSON { response in switch response.result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
                }
            }
        }
    }
}
