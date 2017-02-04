//
//  FinalVideoPlayerViewController.swift
//  Koalie
//
//  Created by Tony Mu on 1/29/17.
//  Copyright © 2017 Koa. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import AwesomeCache
import Alamofire

class FinalVideoPlayerViewController: UIViewController {
    
    var mediaList: NSArray?
    var eventId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dict = ["eventId": eventId!]
        
        Alamofire.request(Constants.URIs.baseUri + Constants.routes.getEventMedias, method: .get, parameters: dict, encoding: URLEncoding.default).responseJSON { response in switch response.result {
        case .success(let data):
            self.mediaList = data as! [NSDictionary] as NSArray?
        case .failure(let error):
            print(error)
            }
        }
    }
    @IBAction func playVideo(sender: AnyObject) {
//        let cache = try Cache<UIImage>(name: "imageCache")
//        if let image = cache[key!]
    }
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func startMediaBrowserFromViewController(viewController: UIViewController, usingDelegate delegate: UINavigationControllerDelegate & UIImagePickerControllerDelegate) -> Bool {
        // 1
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) == false {
            return false
        }
        
        // 2
        let mediaUI = UIImagePickerController()
        mediaUI.sourceType = .savedPhotosAlbum
        mediaUI.mediaTypes = [kUTTypeMovie as NSString as String]
        mediaUI.allowsEditing = true
        mediaUI.delegate = delegate
        
        // 3
        present(mediaUI, animated: true, completion: nil)
        return true
    }
    
}

// MARK: - UIImagePickerControllerDelegate

extension FinalVideoPlayerViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // 1
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        // 2
        dismiss(animated: true) {
            // 3
            if mediaType == kUTTypeMovie {
                let moviePlayer = MPMoviePlayerViewController(contentURL: (info[UIImagePickerControllerMediaURL] as! NSURL) as URL!)
                self.presentMoviePlayerViewControllerAnimated(moviePlayer)
            }
        }
    }
}

// MARK: - UINavigationControllerDelegate

extension FinalVideoPlayerViewController: UINavigationControllerDelegate {
}
