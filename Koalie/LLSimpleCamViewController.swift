//
//  LLSimpleCamViewController.swift
//  Koalie
//
//  Created by Tony Mu on 9/10/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import LLSimpleCamera
import Alamofire
import AWSS3
import ESTabBarController
import SDRecordButton

class LLSimpleCamViewController: UIViewController {
    var errorLabel = UILabel();
//    var snapButton = UIButton();
    var switchButton = UIButton();
    var flashButton = UIButton()
    var settingsButton = UIButton();
    var galleryButton = UIButton();
    var homeButton = UIButton();
    var camera = LLSimpleCamera();
    var snapButton: SDRecordButton!
    
    var eventId: String!
    var userId: String!
    
    var videoDuration = 6.0
    var progressTimer: Timer!
    var progress: Double = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if LLSimpleCamera.isFrontCameraAvailable() && LLSimpleCamera.isRearCameraAvailable() {
            self.camera.start()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false);
        self.view.backgroundColor = UIColor.black;
        
        let screenRect = UIScreen.main.bounds;
        
        self.camera = LLSimpleCamera(quality: AVCaptureSessionPreset1280x720, position: LLCameraPositionRear, videoEnabled: true)
        self.camera.attach(to: self, withFrame: CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height))
        self.camera.fixOrientationAfterCapture = false;
        
        self.homeButton = UIButton(type: .custom)
        self.homeButton.frame = CGRect(x: 12.0, y: 16.0, width: 60, height: 60)
        self.homeButton.tintColor = UIColor.white
        self.homeButton.setImage(UIImage(named: "Home_Icon"), for: UIControlState())
        self.homeButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        self.homeButton.addTarget(self, action: #selector(homeButtonClick), for: .touchUpInside)
        self.view!.addSubview(homeButton)
        
        self.galleryButton = UIButton(type: .custom)
        self.galleryButton.frame = CGRect(x: 12.0, y: screenRect.size.height - 60, width: 29.0 + 20.0, height: 22.0 + 20.0)
        self.galleryButton.tintColor = UIColor.white
        self.galleryButton.setImage(UIImage(named: "Gallery_Icon"), for: UIControlState())
        self.galleryButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        self.galleryButton.addTarget(self, action: #selector(galleryButtonClick), for: .touchUpInside)
        self.view!.addSubview(self.galleryButton)
        
        self.camera.onDeviceChange = {(camera, device) -> Void in
            if (camera?.isFlashAvailable())! {
                self.flashButton.isHidden = false
                if camera?.flash == LLCameraFlashOff {
                    self.flashButton.isSelected = false
                }
                else {
                    self.flashButton.isSelected = true
                }
            }
            else {
                self.flashButton.isHidden = true
            }
        }
        
        self.camera.onError = {(camera, error) -> Void in
            if (error?._domain == LLSimpleCameraErrorDomain) {
                if error?._code == 10 || error?._code == 11 {
                    if(self.view.subviews.contains(self.errorLabel)){
                        self.errorLabel.removeFromSuperview()
                    }
                    
                    let label: UILabel = UILabel(frame: CGRect.zero)
                    label.text = "We need permission for the camera and microphone."
                    label.numberOfLines = 2
                    label.lineBreakMode = .byWordWrapping;
                    label.backgroundColor = UIColor.clear
                    label.font = UIFont(name: "AvenirNext-DemiBold", size: 13.0)
                    label.textColor = UIColor.white
                    label.textAlignment = .center
                    label.sizeToFit()
                    label.center = CGPoint(x: screenRect.size.width / 2.0, y: screenRect.size.height / 2.0)
                    self.errorLabel = label
                    self.view!.addSubview(self.errorLabel)
                    
                    let jumpSettingsBtn: UIButton = UIButton(frame: CGRect(x: 50, y: label.frame.origin.y + 50, width: screenRect.size.width - 100, height: 50));
                    jumpSettingsBtn.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 24.0)
                    jumpSettingsBtn.setTitle("Go Settings", for: .normal);
                    jumpSettingsBtn.setTitleColor(UIColor.white, for: .normal);
                    jumpSettingsBtn.layer.borderColor = UIColor.white.cgColor;
                    jumpSettingsBtn.layer.cornerRadius = 5;
                    jumpSettingsBtn.layer.borderWidth = 2;
                    jumpSettingsBtn.clipsToBounds = true;
                    jumpSettingsBtn.addTarget(self, action: #selector(self.jumpSettinsButtonPressed(_:)), for: .touchUpInside);
                    jumpSettingsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
                    
                    self.settingsButton = jumpSettingsBtn;
                    
                    self.view!.addSubview(self.settingsButton);
                    
                    self.switchButton.isEnabled = false;
                    self.flashButton.isEnabled = false;
                    self.snapButton.isEnabled = false;
                }
            }
        }
        
        if(LLSimpleCamera.isFrontCameraAvailable() && LLSimpleCamera.isRearCameraAvailable()){
            self.snapButton = SDRecordButton(frame: CGRect(x: 0, y: 0, width: 70.0, height: 70.0))
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(snapButtonClicked))
            tapGesture.numberOfTapsRequired = 1
            let holdDownGesture = UILongPressGestureRecognizer(target: self, action: #selector(snapButtonPressedDown(_:)))
            self.snapButton.addGestureRecognizer(holdDownGesture)
            self.snapButton.addGestureRecognizer(tapGesture)
            self.snapButton.buttonColor = UIColor.white
            self.snapButton.progressColor = UIColor.red
            self.view.addSubview(self.snapButton)
            
            self.flashButton = UIButton(type: .custom)
            self.flashButton.frame = CGRect(x: screenRect.size.width - 12.0, y: screenRect.size.height - 60, width: 60, height: 60)
            self.flashButton.tintColor = UIColor.white
            self.flashButton.setImage(UIImage(named: "Flash_Off_Icon"), for: .normal)
            self.flashButton.setImage(UIImage(named: "Flash_On_Icon"), for: .selected)
            self.flashButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
            self.flashButton.addTarget(self, action: #selector(self.flashButtonPressed(_:)), for: .touchUpInside)
            self.flashButton.isHidden = false;
            self.view!.addSubview(self.flashButton)
            
            self.switchButton = UIButton(type: .custom)
            self.switchButton.frame = CGRect(x: screenRect.size.width - 12.0, y: 12.0, width: 60, height: 50)
            self.switchButton.tintColor = UIColor.white
            self.switchButton.setImage(UIImage(named: "Flip_Camera_Icon"), for: UIControlState())
            self.switchButton.imageEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
            self.switchButton.addTarget(self, action: #selector(self.switchButtonPressed(_:)), for: .touchUpInside)
            self.view!.addSubview(self.switchButton)
            
            self.snapButton.center = self.view.center
            self.snapButton.frame.origin.y = self.view.bounds.height - 90
            self.flashButton.frame.origin.x = self.view.frame.width - 70
            self.flashButton.frame.origin.y = self.view.bounds.height - 70
            self.switchButton.frame.origin.y = 12.0
            self.switchButton.frame.origin.x = self.view.frame.width - 60.0
            self.galleryButton.frame.origin.y = self.view.bounds.height - 70
            self.switchButton.frame.origin.x = self.flashButton.frame.origin.x

            self.view!.addSubview(self.galleryButton)
            
        } else {
            let label: UILabel = UILabel(frame: CGRect.zero)
            label.text = "You must have a camera to take video."
            label.numberOfLines = 2
            label.lineBreakMode = .byWordWrapping;
            label.backgroundColor = UIColor.clear
            label.font = UIFont(name: "AvenirNext-DemiBold", size: 13.0)
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.sizeToFit()
            label.center = CGPoint(x: screenRect.size.width / 2.0, y: screenRect.size.height / 2.0)
            self.errorLabel = label
            self.view!.addSubview(self.errorLabel)
        }
    }
    
    func segmentedControlValueChanged(_ control: UISegmentedControl) {
        print("Segment value changed!")
    }
    
    func cancelButtonPressed(_ button: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    func jumpSettinsButtonPressed(_ button: UIButton){
        UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!);
    }
    
    func switchButtonPressed(_ button: UIButton) {
        if(camera.position == LLCameraPositionRear){
            self.flashButton.isHidden = false;
        }
        else{
            self.flashButton.isHidden = true;
        }
        
        self.camera.togglePosition()
    }
    
    func snapButtonClicked(_ sender: UIButton) {
        print("Clicked")
        if (camera.position == LLCameraPositionFront) {
            camera.mirror = LLCameraMirrorOn
        } else if (camera.position == LLCameraPositionRear) {
            camera.mirror = LLCameraMirrorOff
        }

        // capture
        self.camera.capture({(camera, image, metadata, error) -> Void in
            if (error == nil) {
                self.resetProgress()
                camera?.perform(#selector(NetService.stop), with: nil, afterDelay: 0.2)
                let imageVC: PreviewImageViewController = PreviewImageViewController(image: image!)
                imageVC.eventId = self.eventId
                self.present(imageVC, animated: false, completion: { _ in })
            } else {
                print("An error has occured: %@", error!)
            }
        }, exactSeenImage: true)
    }
    
    func snapButtonPressedDown(_ sender: UIGestureRecognizer) {
        if (camera.position == LLCameraPositionFront) {
            camera.mirror = LLCameraMirrorOn
        } else if (camera.position == LLCameraPositionRear) {
            camera.mirror = LLCameraMirrorOff
        }
        let uuid = UUID().uuidString
        if sender.state == .began {
            print("Held Down...")
            self.snapButton.progressColor = UIColor.red
            self.snapButton.circleLayer.backgroundColor = UIColor.red.cgColor
            self.progressTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
            if(self.camera.position == LLCameraPositionRear && !self.flashButton.isHidden){
                self.flashButton.isHidden = true;
            }
            self.switchButton.isHidden = true
            //        self.snapButton.layer.borderColor = UIColor.red.cgColor
            //        self.snapButton.backgroundColor = UIColor.red.withAlphaComponent(0.5);
            // start recording
            let outputURL: URL = self.applicationDocumentsDirectory().appendingPathComponent(uuid).appendingPathExtension("mov")
            print(outputURL)
            self.camera.startRecording(withOutputUrl: outputURL)
        } else if sender.state == .ended {
            print("Released")
            self.progressTimer.invalidate()
            self.resetProgress()
            if(self.camera.position == LLCameraPositionRear && self.flashButton.isHidden){
                self.flashButton.isHidden = false;
            }
            self.switchButton.isHidden = false
//            self.snapButton.layer.borderColor = UIColor.white.cgColor
//            self.snapButton.backgroundColor = UIColor.white.withAlphaComponent(0.5);
            self.camera.stopRecording({(camera, outputFileUrl, error) -> Void in
                // let uploadUrl = self.applicationDocumentsDirectory().appendingPathComponent(uuid).appendingPathExtension("mov")
                print(outputFileUrl!)
                let vc: PreviewVideoViewController = PreviewVideoViewController(videoUrl: outputFileUrl!)
                vc.eventId = self.eventId
                self.present(vc, animated: false)
            })
        }
    }
    
    func updateProgress() {
        self.progress += 0.05 / videoDuration
        self.snapButton.setProgress(CGFloat(self.progress))
        if self.progress >= 1 {
            self.progressTimer.invalidate()
            self.camera.stopRecording({(camera, outputFileUrl, error) -> Void in
                // let uploadUrl = self.applicationDocumentsDirectory().appendingPathComponent(uuid).appendingPathExtension("mov")
                self.resetProgress()
                print(outputFileUrl!)
                let vc: PreviewVideoViewController = PreviewVideoViewController(videoUrl: outputFileUrl!)
                vc.eventId = self.eventId
                self.present(vc, animated: false)
            })
        }
    }
    
    func resetProgress() {
        self.progress = 0.0
        self.snapButton.progressColor = UIColor.white
        self.snapButton.circleLayer.backgroundColor = UIColor.white.cgColor
        self.snapButton.setProgress(CGFloat(self.progress))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.camera.view.frame = self.view.bounds
//        self.snapButton.center = self.view.center
//        self.snapButton.frame.origin.y = self.view.bounds.height - 90
//        self.flashButton.frame.origin.x = self.view.frame.width - 70
//        self.flashButton.frame.origin.y = self.view.bounds.height - 70
//        self.switchButton.frame.origin.y = 12.0
//        self.switchButton.frame.origin.x = self.view.frame.width - 60.0
//        self.galleryButton.frame.origin.y = self.view.bounds.height - 70
//        self.switchButton.frame.origin.x = self.flashButton.frame.origin.x
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.resetProgress()
    }
    
    func flashButtonPressed(_ button: UIButton) {
        if self.camera.flash == LLCameraFlashOff {
            let done: Bool = self.camera.updateFlashMode(LLCameraFlashOn)
            if done {
                self.flashButton.isSelected = true
                self.flashButton.tintColor = UIColor.yellow;
            }
        }
        else {
            let done: Bool = self.camera.updateFlashMode(LLCameraFlashOff)
            if done {
                self.flashButton.isSelected = false
                self.flashButton.tintColor = UIColor.white;
            }
        }
    }
    
    func applicationDocumentsDirectory()-> URL {
        return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last!
    }
    
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return .portrait
    }
    
    override var prefersStatusBarHidden : Bool {
        return true;
    }
    
    internal func galleryButtonClick() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let eventGalleryVC = storyboard.instantiateViewController(withIdentifier: "eventGalleryVC") as! EventGalleryViewController
        let myGalleryVC = storyboard.instantiateViewController(withIdentifier: "myGalleryVC") as! YourGalleryViewController
        let tabbarVC = GalleryTabBarViewController()
        let item2 = UITabBarItem(title: "You", image: UIImage(named: "You_Icon_NOT_Selected"), selectedImage: UIImage(named: "You_Icon_Selected"))
        let item1 = UITabBarItem(title: "Others", image: UIImage(named: "Others_Icon_NOT_selected"), selectedImage: UIImage(named: "Others_Icon_Selected"))
        
        UITabBarItem.appearance().setTitleTextAttributes(NSDictionary(object: UIFont(name: "montserrat", size: 12), forKey: NSFontAttributeName as NSCopying) as! [String : Any], for: UIControlState.normal)
        tabbarVC.tabBar.barTintColor = UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 1.0)
//        tabbarVC.tintColor = Constants.backgroundColor.dark
//        tabbarVC.tabBar.backgroundImage =
        eventGalleryVC.tabBarItem = item1
        myGalleryVC.tabBarItem = item2
        eventGalleryVC.eventId = self.eventId
        eventGalleryVC.userId = self.userId
        myGalleryVC.eventId = self.eventId
        myGalleryVC.userId = self.userId
        tabbarVC.setViewControllers([eventGalleryVC, myGalleryVC], animated: true)
        tabbarVC.tabBar.tintColor = Constants.backgroundColor.selected
        self.present(tabbarVC, animated: true, completion: nil)
    }
    
    internal func homeButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
