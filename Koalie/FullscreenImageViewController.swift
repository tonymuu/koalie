//
//  FullscreenImageViewController.swift
//  Koalie
//
//  Created by Tony Mu on 11/11/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import Alamofire

class FullscreenImageViewController: UIViewController {
    
    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var labelUpvotes: UILabel!
    @IBOutlet weak var buttonUpvote: UIButton!
    @IBOutlet weak var buttonDownload: UIButton!
    
    var image: UIImage!
    var actionSheet: UIAlertController!
    var voted: Bool!
    var upvotes: Int = 0
    var eventId: String!
    var mediaId: String!
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }

    
    @IBAction func buttonDismissClick(_ sender: Any) {
        self.dismissFullscreen()
    }
    
    @IBAction func buttonEditClick(_ sender: AnyObject) {
        self.actionSheet = UIAlertController(title: "Edit", message: "Make changes", preferredStyle: .actionSheet)
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
        self.present(actionSheet, animated: true, completion: nil)
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
            UIImageWriteToSavedPhotosAlbum(self.viewImage.image!, nil, nil, nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewImage.image = image
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreen))
        self.viewImage.isUserInteractionEnabled = true
        self.viewImage.addGestureRecognizer(tapRecognizer)
        self.buttonUpvote.isSelected = voted
        self.labelUpvotes.text = String(upvotes)
    }
    
    func dismissFullscreen() {
        self.dismiss(animated: true, completion: nil)
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
