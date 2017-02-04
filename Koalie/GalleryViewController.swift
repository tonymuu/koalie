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
import UITableView_Cache
import VIMVideoPlayer

class GalleryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, GalleryTableViewCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    
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

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(GalleryTableViewCell.self, forCellReuseIdentifier: "PictureCell", cacheSize: 10)
        self.tableView.register(GalleryVideoTableViewCell.self, forCellReuseIdentifier: "VideoCell", cacheSize: 10)
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
                cell.addGestureRecognizer(tapGestureRecognizer)

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
            do {
                let cache = try Cache<NSString>(name: "videoCache")
                print("got video from cache")
                if let name = cache[key!] {
                    let videoUrl = self.applicationDocumentsDirectory().appendingPathComponent(name as String)
                    cell.player.player.isLooping = false
                    cell.player.player.disableAirplay()
                    cell.player.setVideoFillMode(AVLayerVideoGravityResizeAspectFill)
//                    cell.addSubview(cell.player)
//                    cell.bringSubview(toFront: cell.player)
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
                            cell.player.player.isLooping = false
                            cell.player.player.disableAirplay()
                            cell.player.setVideoFillMode(AVLayerVideoGravityResizeAspectFill)
//                            cell.addSubview(cell.player)
//                            cell.bringSubview(toFront: cell.player)
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
        let cell = sender.view as! GalleryTableViewCell
        let image = cell.viewPicture.image
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FullscreenImageVC") as! FullscreenImageViewController
        vc.image = image
        vc.eventId = cell.eventId
        vc.mediaId = cell.mediaId
        vc.voted = cell.voted
        vc.upvotes = cell.upvotes
        self.present(vc, animated: true, completion: nil)
    }
    
    func applicationDocumentsDirectory()-> URL {
        return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last!
    }
    
    func presentActionSheet(actionSheet: UIAlertController) {
        self.present(actionSheet, animated: true, completion: nil)
    }
}
