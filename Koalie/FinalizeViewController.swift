//
//  FinalizeViewController.swift
//  Koalie
//
//  Created by Tony Mu on 6/7/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit

class FinalizeViewController: UIViewController {
    var viewGeneral = GeneralView.instanceFromNib() as! GeneralView
    
    @IBOutlet weak var viewImage: UIImageView!
    
    @IBAction func finalizeButtonClick(sender: AnyObject) {
        
    }
    
    @IBAction func buttonBackClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func buttonMusicClick(sender: AnyObject) {
        viewGeneral.viewImage.image = UIImage(named: "Music Selected.jpg")
        animateGeneralView()
    }
    
    @IBAction func buttonTextClick(sender: AnyObject) {
        viewGeneral.viewImage.image = UIImage(named: "Text Selected.jpg")
        animateGeneralView()
    }
    
    @IBAction func buttonIconClick(sender: AnyObject) {
        viewGeneral.viewImage.image = UIImage(named: "Icon Selected.jpg")
        animateGeneralView()
    }
    
    @IBAction func buttonThemeClick(sender: AnyObject) {
        viewGeneral.viewImage.image = UIImage(named: "Theme Selected.jpg")
        animateGeneralView()
    }
    
    
    var counter = 0
    
    var animationDuration = 0.4
    var switchTimeInterval = 2.0
    override func viewDidLoad() {
        super.viewDidLoad()
        viewGeneral.frame = self.view.frame
        viewImage.image = Constants.images[counter++]
        animateImageView()
    }
    
    func animateGeneralView() {
        CATransaction.begin()
        
        CATransaction.setAnimationDuration(animationDuration)

        let transition = CATransition()
        transition.type = kCATransitionFade
        /*
         transition.type = kCATransitionPush
         transition.subtype = kCATransitionFromRight
         */
        viewGeneral.layer.addAnimation(transition, forKey: kCATransition)
        self.view.addSubview(viewGeneral)
        CATransaction.commit()
    }
    
    func animateImageView() {
        CATransaction.begin()
        
        CATransaction.setAnimationDuration(animationDuration)
        CATransaction.setCompletionBlock {
            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(self.switchTimeInterval * NSTimeInterval(NSEC_PER_SEC)))
            dispatch_after(delay, dispatch_get_main_queue()) {
                self.animateImageView()
            }
        }
        
        let transition = CATransition()
        transition.type = kCATransitionFromRight
        /*
         transition.type = kCATransitionPush
         transition.subtype = kCATransitionFromRight
         */
        viewImage.layer.addAnimation(transition, forKey: kCATransition)
        viewImage.image = Constants.images[counter]
        
        CATransaction.commit()
        
        counter = counter < Constants.images.count - 1 ? counter + 1 : 0
    }

    
}
