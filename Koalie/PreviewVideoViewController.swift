//
//  PreviewVideoViewController.swift
//  Koalie
//
//  Created by Tony Mu on 9/10/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import AWSS3

class PreviewVideoViewController: UIViewController {
    var videoUrl: URL!;
    var uploadUrl: URL!;
    var avPlayer = AVPlayer();
    var avPlayerLayer = AVPlayerLayer();
    var backButton = UIButton();
    
    convenience init(videoUrl url: URL) {
        self.init()
        self.videoUrl = url
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
        
//        self.backButton.addTarget(self, action: #selector(PreviewVideoViewController.backButtonPressed(_:)), forControlEvents: .TouchUpInside)
//        self.backButton.frame = CGRectMake(7, 13, 65, 30)
//        self.backButton.layer.borderColor = UIColor.whiteColor().CGColor;
//        self.backButton.layer.borderWidth = 2;
//        self.backButton.layer.cornerRadius = 5;
//        self.backButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 13);
//        self.backButton.setTitle("Back", forState: .Normal)
//        self.backButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
//        self.backButton.layer.shadowColor = UIColor.blackColor().CGColor
//        self.backButton.layer.shadowOffset = CGSizeMake(0.0, 0.0)
//        self.backButton.layer.shadowOpacity = 0.4
//        self.backButton.layer.shadowRadius = 1.0
//        self.backButton.clipsToBounds = false
        
        let holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(uploadVideoToS3))
        self.view.addGestureRecognizer(holdGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonPressed))
        self.view.addGestureRecognizer(tapGesture)
        
        self.view!.addSubview(self.backButton)
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
                let uploadOutput = task.result
                print(uploadOutput)
            }
            return nil
        })
    }
}
