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

        let horizontalConstraint = NSLayoutConstraint(item: self.view, attribute: .CenterX, relatedBy: .Equal, toItem: loginButton, attribute: .CenterX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: self.view, attribute: .Bottom, relatedBy: .Equal, toItem: loginButton, attribute: .Bottom, multiplier: 1, constant: 120)
        
        self.view.addConstraint(horizontalConstraint)
        self.view.addConstraint(verticalConstraint)
        
        
        let bgImage = UIImage(named: "Wallpaper for App.png")
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = bgImage
        self.view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("Logged in!")
        returnUserData()



    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func returnUserData() {
        let token = FBSDKAccessToken.currentAccessToken().tokenString
        
        // important! it has to be named "access token" to authenticate.
        let dict = ["access_token": token]
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomeVC") as! HomeViewController
        let navigationVC = UINavigationController(rootViewController: vc)
        navigationVC.navigationBar.barTintColor = Constants.backgroundColor.dark

        
        Alamofire.request(.GET, Constants.URIs.baseUri + Constants.routes.auth, parameters: dict, encoding: .URL, headers: nil).responseJSON { response in
            print(response.request)
            if (FBSDKAccessToken.currentAccessToken() != nil) {
                Alamofire.request(.GET, Constants.URIs.baseUri + Constants.routes.getEvents, parameters: nil, encoding: .URL, headers: nil).responseJSON { response in switch response.result {
                case .Success(let data):
                    let dict = data as! NSDictionary
                    vc.userData = dict
                    
                case .Failure(let error):
                    print(error)
                    }
                }
                
            } else {
                print("You are logged out")
            }
        }
        self.presentViewController(navigationVC, animated: true, completion: nil)
    }
    
    func uploadToS3(image: UIImage) {
        // AWS config
        //        let customProviderManager = CustomIdentityProvider(tokens: FBSDKAccessToken.currentAccessToken().tokenString)
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .USWest2, identityPoolId: "us-west-2:0e669216-3640-4829-bc5c-a5322425f07f")
        //        credentialsProvider.logins = [AWSIdentityProviderFacebook: FBSDKAccessToken.currentAccessToken().tokenString]
        let logins: NSDictionary = NSDictionary(dictionary: ["graph.facebook.com" : FBSDKAccessToken.currentAccessToken().tokenString])
        credentialsProvider.logins = logins as [NSObject : AnyObject]
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration

        
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        let downloadingFilePath = NSURL(fileURLWithPath: NSTemporaryDirectory().stringByAppendingString("downloaded_sample.jpg"))
        var downloadRequest = AWSS3TransferManagerDownloadRequest()
        downloadRequest.bucket = "koalie-test-bucket"
        downloadRequest.key = "images/DSC_0086.jpg"
        downloadRequest.downloadingFileURL = downloadingFilePath
        
        // download request
        
        transferManager.download(downloadRequest).continueWithBlock {(task: AWSTask!) -> AnyObject! in
            if ((task.error) != nil) {
                print(task.error)
            }
            if ((task.result) != nil) {
                let downloadOutput: AWSS3TransferManagerDownloadOutput = task.result as! AWSS3TransferManagerDownloadOutput
                print(downloadOutput)
            }
            return nil
        }
        
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            let uploadRequest = AWSS3TransferManagerUploadRequest()
            let filename = getDocumentsDirectory().stringByAppendingString("/upload_test.jpg")
            data.writeToFile(filename, atomically: true)
            print(filename)
            uploadRequest.bucket = "koalie-test-bucket"
            uploadRequest.key = filename
            uploadRequest.body = NSURL(fileURLWithPath: filename)
            
            // upload request
            
            transferManager.upload(uploadRequest).continueWithBlock {(task: AWSTask!) -> AnyObject! in
                if (task.error != nil) {
                    print(task.error)
                }
                if (task.result != nil) {
                    let uploadOutput = task.result
                    print(uploadOutput)
                }
                return nil
            }
        }
        
    }
    
    func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
}
