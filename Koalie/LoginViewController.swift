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
    @IBOutlet weak var labelStatus: UILabel!

    @IBOutlet weak var imageProfilePic: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            labelStatus.text = FBSDKAccessToken.currentAccessToken().tokenString
        } else {
            labelStatus.text = "You are logged out"
        }
        
        let loginButton: FBSDKLoginButton = FBSDKLoginButton()
        loginButton.delegate = self
        loginButton.center = self.view.center
        self.view.addSubview(loginButton)
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("Logged in!")
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            labelStatus.text = FBSDKAccessToken.currentAccessToken().tokenString
            print(labelStatus.text)
            returnUserData()
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomeVC")
            self.presentViewController(vc!, animated: true, completion: nil)
//            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomeVC")
//            self.presentViewController(vc!, animated: true, completion: nil)
        } else {
            labelStatus.text = "You are logged out"
        }

    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if (error != nil) {
                print("Error: \(error)")
            }
            else {
                print(result)
                print(result.valueForKey("name") as! String)
                let fid = result.valueForKey("id") as! String
                let imgURLString = "http://graph.facebook.com/" + fid + "/picture?type=normal"
                let imgURL = NSURL(string: imgURLString)
                let imageData = NSData(contentsOfURL: imgURL!)
                let image = UIImage(data: imageData!)
                self.imageProfilePic.image = image!
                let dict = ["access_token": FBSDKAccessToken.currentAccessToken().tokenString]
                let token = FBSDKAccessToken.currentAccessToken().tokenString
                

                self.uploadToS3(image!)
                
                let dict = ["access_token": token]
                Alamofire.request(.GET, Constants.URIs.baseUri + Constants.routes.auth, parameters: dict, encoding: .URL, headers: nil).responseJSON { response in
                    print(response.request)
                }
            }
        })
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
