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
                Alamofire.request(.GET, Constants.URIs.baseUri + Constants.routes.auth, parameters: dict, encoding: .URL, headers: nil).responseJSON { response in
                    print(response.request)
                }
            }
        })
    }
}
