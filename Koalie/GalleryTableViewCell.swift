//
//  GalleryTableViewCell.swift
//  Koalie
//
//  Created by Tony Mu on 6/2/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import Alamofire

class GalleryTableViewCell: UITableViewCell {
    @IBOutlet weak var viewPicture: UIImageView!
    @IBOutlet weak var labelUpvotes: UILabel!
    @IBOutlet weak var buttonUpvote: UIButton!
    
    @IBOutlet weak var buttonDownvote: UIButton!

    @IBOutlet weak var buttonDownload: UIButton!
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    
    var voted: Bool!
    
    var upvotes: Int = 0
    
    var eventId: String!
        
    @IBAction func buttonUpvoteClick(_ sender: AnyObject) {
        buttonUpvote.isSelected = true
        buttonDownvote.isSelected = false
        if !voted {
            upvotes = Int(labelUpvotes.text!)!
            voted = true
            upvotes += 1
            labelUpvotes.text = String(describing: upvotes)
            updateUpvotes(upvotes: upvotes)
        }
    }
    
    @IBAction func buttonDownvoteClick(_ sender: AnyObject) {
        buttonDownvote.isSelected = true
        buttonUpvote.isSelected = false
        if !voted {
            upvotes = Int(labelUpvotes.text!)!
            voted = true
            upvotes -= 1
            labelUpvotes.text = String(describing: upvotes)
            updateUpvotes(upvotes: upvotes)
        }
    }
    
    
    @IBAction func buttonDownloadClick(_ sender: AnyObject) {
        buttonDownload.isSelected = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUpvotes(upvotes: Int) {
        let dict = [
            "eventId": eventId!,
            "likes": upvotes] as [String : Any]

        Alamofire.request(Constants.URIs.baseUri + Constants.routes.postUpvotes, method: .post, parameters: dict, encoding: URLEncoding.default).responseJSON { response in switch response.result {
        case .success(let data):
            print(data)
        case .failure(let error):
            print(error)
            }
        }

    }

}
