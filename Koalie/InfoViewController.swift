//
//  InfoViewController.swift
//  Koalie
//
//  Created by Tony Mu on 6/5/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import MapKit
import ExpandingMenu

class InfoViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    var eventId: String!
//    var presentationAnimator = GuillotineTransitionAnimation()
//    var slideMenu: LLSlideMenu!
    

    
    @IBAction func buttonBackClick(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonMenuClick(_ sender: AnyObject) {
//        if slideMenu.ll_isOpen {
//            slideMenu.ll_close()
//        } else {
//            slideMenu.ll_open()
//        }
//        let menuVC = storyboard?.instantiateViewController(withIdentifier: "InfoMenuVC")
//        menuVC?.modalPresentationStyle = .custom
//        menuVC?.transitioningDelegate = self
//        
//        presentationAnimator.animationDelegate = menuVC as? GuillotineAnimationDelegate
//        presentationAnimator.supportView = sender as! UIView
//        presentationAnimator.presentButton = sender as! UIView
//        present(menuVC!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let menuButtonSize: CGSize = CGSize(width: 64.0, height: 64.0)
        let menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize), centerImage: UIImage(named: "Plus Icon")!, centerHighlightedImage: UIImage(named: "Minus Icon")!)
        menuButton.center = CGPoint(x: self.view.bounds.width - 32.0, y: self.view.frame.origin.y + 48)
        menuButton.expandingDirection = .bottom
        view.addSubview(menuButton)

        let addTimeButton = ExpandingMenuItem(size: menuButtonSize, title: "Length", image: UIImage(named: "Clock Icon")!, highlightedImage: UIImage(named: "Clock Icon")!, backgroundImage: UIImage(named: ""), backgroundHighlightedImage: UIImage(named: "")) { () -> Void in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddTimeVC") as! MoreTimeViewController
            vc.eventId = self.eventId
            self.present(vc, animated: true, completion: nil)
        }
        
        let addPeopleButton = ExpandingMenuItem(size: menuButtonSize, title: "People", image: UIImage(named: "Add People Icon")!, highlightedImage: UIImage(named: "Add People Icon")!, backgroundImage: UIImage(named: ""), backgroundHighlightedImage: UIImage(named: "")) { () -> Void in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPeopleVC") as! MorePeopleViewController
            vc.eventId = self.eventId
            self.present(vc, animated: true, completion: nil)
        }
        let inviteButton = ExpandingMenuItem(size: menuButtonSize, title: "Invite", image: UIImage(named: "Play Icon")!, highlightedImage: UIImage(named: "Play Icon")!, backgroundImage: UIImage(named: ""), backgroundHighlightedImage: UIImage(named: "")) { () -> Void in
            // Do some action
        }

        addTimeButton.contentMode = .scaleAspectFill
        addPeopleButton.contentMode = .scaleAspectFit
        inviteButton.contentMode = .scaleToFill
        
        addTimeButton.clipsToBounds = true
        addPeopleButton.clipsToBounds = true
        inviteButton.clipsToBounds = true

        menuButton.addMenuItems([addTimeButton, addPeopleButton, inviteButton])

//        slideMenu = LLSlideMenu()
//        self.view.addSubview(slideMenu)
//        slideMenu.ll_springFramesNum = 60
//        slideMenu.ll_springVelocity = 70
//        slideMenu.ll_menuWidth = 100
//        slideMenu.ll_menuBackgroundColor = Constants.backgroundColor.dark
    }
}

//extension InfoViewController: UIViewControllerTransitioningDelegate {
//    
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        presentationAnimator.mode = .presentation
//        return presentationAnimator
//    }
//    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        presentationAnimator.mode = .dismissal
//        return presentationAnimator
//    }
//}
