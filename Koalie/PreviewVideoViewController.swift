//
//  PreviewVideoViewController.swift
//  Koalie
//
//  Created by Tony Mu on 9/10/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import AWSS3
import Alamofire

class PreviewVideoViewController: UIViewController {
    var eventId: String! = nil
    var videoUrl: URL!;
    var uploadUrl: URL!;
    var avPlayer = AVPlayer();
    var avPlayerLayer = AVPlayerLayer();
    var backButton = UIButton();
    
    convenience init(videoUrl url: URL) {
        self.init()
        self.videoUrl = url
        self.uploadUrl = url
    }
    
    convenience init(videoUrl url: URL, uploadUrl: URL) {
        self.init()
        self.videoUrl = url
        self.uploadUrl = uploadUrl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        self.avPlayer.play();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        // the video player
        let item = AVPlayerItem(url: self.videoUrl);
        self.avPlayer = AVPlayer(playerItem: item);
        self.avPlayer.actionAtItemEnd = .none
        self.avPlayerLayer = AVPlayerLayer(player: self.avPlayer);
        NotificationCenter.default.addObserver(self, selector: #selector(PreviewVideoViewController.playerItemDidReachEnd(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.avPlayer.currentItem!)
        
        let screenRect: CGRect = UIScreen.main.bounds
        
        self.avPlayerLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        self.view.layer.addSublayer(self.avPlayerLayer)
                
        //let holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(uploadVideoToS3))
        //self.view.addGestureRecognizer(holdGesture)
        
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonPressed))
        //self.view.addGestureRecognizer(tapGesture)
        
        self.view!.addSubview(self.backButton)
        
        let confirmButton = UIButton(type: .system)
        confirmButton.frame = CGRect(x: screenRect.size.width - 72.0, y: screenRect.size.height - 90, width: 60.0, height: 60.0)
        confirmButton.tintColor = UIColor.white
        confirmButton.setImage(UIImage(named: "Check-Mark-Icon.png") , for: UIControlState())
        confirmButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        confirmButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        self.view.addSubview(confirmButton)
        
        let cancelButton = UIButton(type: .system)
        cancelButton.frame = CGRect(x: 12.0, y: screenRect.size.height - 90, width: 60.0, height: 60.0)
        cancelButton.tintColor = UIColor.white
        cancelButton.setImage(UIImage(named: "X-Icon.png") , for: UIControlState())
        cancelButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        self.view.addSubview(cancelButton)

    }
    
    func cancel(_ gesture: UIGestureRecognizer) {
        self.dismiss(animated: false, completion: { _ in })
    }
    
    func save() {
        uploadVideoToS3()
        self.dismiss(animated: false, completion: { _ in })
    }

    
    func playerItemDidReachEnd(_ notification: Notification) {
        self.avPlayer.seek(to: kCMTimeZero);
    }
    
    func backButtonPressed(_ button: UIButton) {
        self.dismiss(animated: false)
    }
    
    override var prefersStatusBarHidden : Bool {
        return true;
    }
    
    func uploadVideoToS3() {
        let transferManager = AWSS3TransferManager.default()
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        print(videoUrl)
        uploadRequest?.bucket = "koalie-test-bucket"
        uploadRequest?.key = uploadUrl.absoluteString
        print(uploadRequest?.key)
        uploadRequest?.body = videoUrl
        
        // upload request
        
        transferManager?.upload(uploadRequest).continue( {(task: AWSTask!) -> AnyObject! in
            if (task.error != nil) {
                print(task.error)
            }
            if (task.result != nil) {
                let dict = ["eventId": self.eventId!, "storedPath": self.uploadUrl, "isVideo": "true"] as [String : Any]
                Alamofire.request(Constants.URIs.baseUri.appending(Constants.routes.createMedia), method: .post, parameters: dict, encoding: URLEncoding.default).responseJSON { response in
                    print(response)
                }
                let uploadOutput = task.result
                print(uploadOutput)
            }
            return nil
        })
    }
}
