//
//  LoginViewController.swift
//  Koalie
//
//  Created by Tony Mu on 8/27/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Alamofire
import AWSCore
import AWSS3

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton: FBSDKLoginButton = FBSDKLoginButton()
        loginButton.delegate = self
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loginButton)

        let horizontalConstraint = NSLayoutConstraint(item: self.view, attribute: .centerX, relatedBy: .equal, toItem: loginButton, attribute: .centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: loginButton, attribute: .bottom, multiplier: 1, constant: 120)
        
        self.view.addConstraint(horizontalConstraint)
        self.view.addConstraint(verticalConstraint)
        
        
        let bgImage = UIImage(named: "Wallpaper for App.png")
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = bgImage
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if(error != nil) {
            print(error)
        } else if result.isCancelled {
            print("canceled")
        } else {
            print("Logged in!")
            returnUserData()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    func returnUserData() {
        print(FBSDKAccessToken.current().tokenString)
        if let token = FBSDKAccessToken.current().tokenString {
            // important! it has to be named "access token" to authenticate.
            let dict = ["access_token": token]
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
            let navigationVC = UINavigationController(rootViewController: vc)
            navigationVC.navigationBar.barTintColor = Constants.backgroundColor.dark
            
            
            Alamofire.request(Constants.URIs.baseUri + Constants.routes.auth, method: .get, parameters: dict, encoding: URLEncoding.default).responseJSON { response in
                print(response.request)
                if (FBSDKAccessToken.current() != nil) {
                    // AWS config
                    let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .usWest2, identityPoolId: "us-west-2:0e669216-3640-4829-bc5c-a5322425f07f")
                    let logins: NSDictionary = NSDictionary(dictionary: ["graph.facebook.com" : FBSDKAccessToken.current().tokenString])
                    credentialsProvider.logins = logins as? [AnyHashable: Any]
                    let configuration = AWSServiceConfiguration(region: .usEast1, credentialsProvider: credentialsProvider)
                    AWSServiceManager.default().defaultServiceConfiguration = configuration

                    Alamofire.request(Constants.URIs.baseUri + Constants.routes.getEvents, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON { response in switch response.result {
                    case .success(let data):
                        let dict = data as! NSDictionary
                        vc.userData = dict
                        
                        self.present(navigationVC, animated: true, completion: nil)
                        
                    case .failure(let error):
                        print(error)
                        }
                    }
                    
                } else {
                    print("You are logged out")
                }
            }
        }
    }
    
    func uploadToS3(_ image: UIImage) {

        
        let transferManager = AWSS3TransferManager.default()
        
        ///// download
        let downloadingFilePath = URL(fileURLWithPath: NSTemporaryDirectory() + "downloaded_sample.jpg")
        let downloadRequest = AWSS3TransferManagerDownloadRequest()
        downloadRequest?.bucket = "koalie-test-bucket"
        downloadRequest?.key = "images/DSC_0086.jpg"
        downloadRequest?.downloadingFileURL = downloadingFilePath
        
        // download request
        
        transferManager?.download(downloadRequest).continue( {(task: AWSTask!) -> AnyObject! in
            if ((task.error) != nil) {
                print(task.error)
            }
            if ((task.result) != nil) {
                let downloadOutput: AWSS3TransferManagerDownloadOutput = task.result as! AWSS3TransferManagerDownloadOutput
                print(downloadOutput)
            }
            return nil
        })
        
        
        ///// upload
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            let uploadRequest = AWSS3TransferManagerUploadRequest()
            let filename = getDocumentsDirectory() + "/upload_test.jpg"
            try? data.write(to: URL(fileURLWithPath: filename), options: [.atomic])
            print(filename)
            uploadRequest?.bucket = "koalie-test-bucket"
            uploadRequest?.key = filename
            uploadRequest?.body = URL(fileURLWithPath: filename)
            
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
    
    func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
}
