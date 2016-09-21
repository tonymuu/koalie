//
//  AppDelegate.swift
//  Koalie
//
//  Created by Tony Mu on 4/27/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import AWSCore
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        
        return handled
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let r = FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
// Login logic
        if isUserAuthenticated() {
            
            // AWS config
            let credentialsProvider = AWSCognitoCredentialsProvider(regionType: .usWest2, identityPoolId: "us-west-2:0e669216-3640-4829-bc5c-a5322425f07f")
            let logins: NSDictionary = NSDictionary(dictionary: ["graph.facebook.com" : FBSDKAccessToken.current().tokenString])
            credentialsProvider.logins = logins as? [AnyHashable: Any]
            let configuration = AWSServiceConfiguration(region: .usEast1, credentialsProvider: credentialsProvider)
            AWSServiceManager.default().defaultServiceConfiguration = configuration
            
            let myStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = myStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
            let navigationVC = UINavigationController(rootViewController: vc)
            navigationVC.navigationBar.barTintColor = Constants.backgroundColor.dark
            self.window?.rootViewController = navigationVC
            
            return true

        } else {
            let myStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = myStoryBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            
            self.window?.rootViewController = vc
            return true
        }
 
        /*
       // temporary solution to bypass login for testing camera
        let vc = LLSimpleCamViewController()
        let navigationVC = UINavigationController(rootViewController: vc)
        self.window?.rootViewController = navigationVC
 
 */

        return true
    }
 
    func isUserAuthenticated() -> Bool {
        return !(FBSDKAccessToken.current() == nil)
    }

}

class CustomIdentityProvider: NSObject, AWSIdentityProviderManager {
    var tokens: NSDictionary?
    init(tokens: NSDictionary) {
        self.tokens = tokens
    }

    /**
     Each entry in logins represents a single login with an identity provider. The key is the domain of the login provider (e.g. 'graph.facebook.com') and the value is the OAuth/OpenId Connect token that results from an authentication with that login provider.
     */
    public func logins() -> AWSTask<NSDictionary> {
        return AWSTask(result: tokens)
    }

}

