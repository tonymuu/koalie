//
//  GalleryViewController.swift
//  Koalie
//
//  Created by Tony Mu on 6/1/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import Alamofire
import AWSS3
import AwesomeCache
import FBSDKLoginKit

class GalleryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, GalleryTableViewCellDelegate {
    @IBOutlet weak var eventTableView: UITableView!
    
    var eventId: String!
    var userId: String!
    
    // sorted according to likes in the backend
    var mediaList: NSArray?
    
    var numberOfRows = 0
    
    
    @IBAction func buttonBackClick(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.eventTableView.delegate = self
        self.eventTableView.dataSource = self

        
//        let dict = ["eventId": eventId!]
        
        
//        Alamofire.request(Constants.URIs.baseUri + Constants.routes.getEventMedias, method: .get, parameters: dict, encoding: URLEncoding.default).responseJSON { response in switch response.result {
//                case .success(let data):
//                    self.mediaList = data as! [NSDictionary] as NSArray?
//                    self.numberOfRows = (self.mediaList?.count)!
//                    self.eventTableView.reloadData()
//                case .failure(let error):
//                    print(error)
//            }
//        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mock = tableView.dequeueReusableCell(withIdentifier: "PictureCell")
        
        let dict = mediaList?.object(at: (indexPath as NSIndexPath).row) as! NSDictionary
        let upvotes: Int! = dict.object(forKey: "likes") as! Int
        let votedMembers = dict.object(forKey: "voted_members") as! NSArray
        let isVoted = votedMembers.contains(self.userId)
        let key = dict.object(forKey: "stored_path") as? String
        let isVideo = dict.object(forKey: "is_video") as! Bool
        let mediaId = dict.object(forKey: "_id") as! String
        let user = dict.object(forKey: "user_id") as! NSDictionary
        let fbUser = user.object(forKey: "facebook") as! NSDictionary
        let fbId = fbUser.object(forKey: "id") as! String
        let profilePicUrl = fbUser.object(forKey: "picture") as! String
        let fbName = fbUser.object(forKey: "name") as! String
        if !isVideo {
            do {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PictureCell", for: indexPath) as! GalleryTableViewCell
                cell.delegate = self
                cell.profileName.text = fbName
                if let data = NSData(contentsOf: URL(string: profilePicUrl)!) {
                    cell.viewProfile.image = UIImage(data: data as Data)
                }
                cell.labelUpvotes.text = String(upvotes!)
                cell.eventId = eventId
                cell.voted = isVoted
                cell.buttonUpvote.isSelected = isVoted
                cell.mediaId = mediaId
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(presentImageFullscreen))
                cell.viewPicture.isUserInteractionEnabled = true
                tapGestureRecognizer.delegate = self
                cell.viewPicture.addGestureRecognizer(tapGestureRecognizer)

                let cache = try Cache<UIImage>(name: "imageCache")
                if let image = cache[key!] {
                    print("got image from cache")
                    cell.viewPicture.image = image

                    return cell
                } else {
                    cell.viewPicture.image = UIImage(named: "KoalieLogo.png")
                    
                    let transferManager = AWSS3TransferManager.default()
                    
                    ///// download
                    let downloadingFilePath = self.applicationDocumentsDirectory().appendingPathComponent(String(indexPath.row)).appendingPathExtension("jpg")
                    let downloadRequest = AWSS3TransferManagerDownloadRequest()
                    downloadRequest?.bucket = "koalie-test-bucket"
                    downloadRequest?.key = key
                    downloadRequest?.downloadingFileURL = downloadingFilePath
                    
                    // download request
                    
                    transferManager?.download(downloadRequest).continue( {(task: AWSTask!) -> AnyObject! in
                        if ((task.error) != nil) {
                            print(task.error)
                        }
                        if ((task.result) != nil) {
                            let downloadOutput: AWSS3TransferManagerDownloadOutput = task.result as! AWSS3TransferManagerDownloadOutput
                            let image: UIImage! = UIImage(contentsOfFile: downloadingFilePath.relativePath)
                            cache[key!] = image
                            cell.viewPicture.image = image
                            return downloadOutput
                        }
                        return nil
                    })
                    return cell
                }
            } catch _ {
                print("Something went wrong")
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! GalleryVideoTableViewCell
            cell.delegate = self
            cell.profileName.text = fbName
            if let data = NSData(contentsOf: URL(string: profilePicUrl)!) {
                cell.viewProfile.image = UIImage(data: data as Data)
            }
            cell.buttonUpvote.isSelected = isVoted
            cell.labelUpvotes.text = String(upvotes!)
            cell.eventId = eventId
            cell.voted = isVoted
            cell.mediaId = mediaId
            cell.player.frame = cell.viewPicture.frame
            cell.player.player.isLooping = true
            cell.player.player.disableAirplay()
            cell.player.setVideoFillMode(AVLayerVideoGravityResizeAspectFill)

            do {
                let cache = try Cache<NSString>(name: "videoCache")
                print("got video from cache")
                if let name = cache[key!] {
                    let videoUrl = self.applicationDocumentsDirectory().appendingPathComponent(name as String)
                    cell.player.player.setURL(videoUrl)
                    return cell
                } else {
                    let transferManager = AWSS3TransferManager.default()
                    
                    ///// download
                    let name = key?.components(separatedBy: "/").last
                    let downloadingFilePath = self.applicationDocumentsDirectory().appendingPathComponent(name!)
                    let downloadRequest = AWSS3TransferManagerDownloadRequest()
                    downloadRequest?.bucket = "koalie-test-bucket"
                    downloadRequest?.key = key
                    downloadRequest?.downloadingFileURL = downloadingFilePath
                    
                    // download request
                    
                    transferManager?.download(downloadRequest).continue( {(task: AWSTask!) -> AnyObject! in
                        if ((task.error) != nil) {
                            print(task.error)
                        }
                        if ((task.result) != nil) {
                            let downloadOutput: AWSS3TransferManagerDownloadOutput = task.result as! AWSS3TransferManagerDownloadOutput
                            cache[key!] = name as NSString?
                            cell.player.player.setURL(downloadingFilePath)
                            return downloadOutput
                        }
                        return nil
                    })
                    return cell
                }
            } catch _ {
                    print("Something went wrong")
                }
                return cell
            }
                
        return mock!
    }
    
    func presentImageFullscreen(sender: UITapGestureRecognizer) {
        let fullImageView = sender.view as! UIImageView
        let image = fullImageView.image
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FullscreenImageVC") as! FullscreenImageViewController
        vc.image = image
        self.present(vc, animated: true, completion: nil)
    }
    
    func applicationDocumentsDirectory()-> URL {
        return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last!
    }
    
    func presentActionSheet(actionSheet: UIAlertController) {
        self.present(actionSheet, animated: true, completion: nil)
    }
}
