//
//  InfoViewController.swift
//  Koalie
//
//  Created by Tony Mu on 6/5/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import MapKit
import GuillotineMenu

class InfoViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    var presentationAnimator = GuillotineTransitionAnimation()
    

    
    @IBAction func buttonBackClick(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonMenuClick(_ sender: AnyObject) {
        let menuVC = storyboard?.instantiateViewController(withIdentifier: "InfoMenuVC")
        menuVC?.modalPresentationStyle = .custom
        menuVC?.transitioningDelegate = self
        
        presentationAnimator.animationDelegate = menuVC as? GuillotineAnimationDelegate
        presentationAnimator.supportView = sender as! UIView
        presentationAnimator.presentButton = sender as! UIView
        present(menuVC!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension InfoViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}
