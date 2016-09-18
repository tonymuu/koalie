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
    
    @IBAction func finalizeButtonClick(_ sender: AnyObject) {
        
    }
    
    @IBAction func buttonBackClick(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonMusicClick(_ sender: AnyObject) {
        viewGeneral.viewImage.image = UIImage(named: "Music Selected.jpg")
        animateGeneralView()
    }
    
    @IBAction func buttonTextClick(_ sender: AnyObject) {
        viewGeneral.viewImage.image = UIImage(named: "Text Selected.jpg")
        animateGeneralView()
    }
    
    @IBAction func buttonIconClick(_ sender: AnyObject) {
        viewGeneral.viewImage.image = UIImage(named: "Icon Selected.jpg")
        animateGeneralView()
    }
    
    @IBAction func buttonThemeClick(_ sender: AnyObject) {
        viewGeneral.viewImage.image = UIImage(named: "Theme Selected.jpg")
        animateGeneralView()
    }
    
    
    var counter = 0
    
    var animationDuration = 0.4
    var switchTimeInterval = 2.0
    override func viewDidLoad() {
        super.viewDidLoad()
        viewGeneral.frame = self.view.frame
        viewImage.image = Constants.images[counter+1]
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
        viewGeneral.layer.add(transition, forKey: kCATransition)
        self.view.addSubview(viewGeneral)
        CATransaction.commit()
    }
    
    func animateImageView() {
        CATransaction.begin()
        
        CATransaction.setAnimationDuration(animationDuration)
        CATransaction.setCompletionBlock {
            let delay = DispatchTime.now() + Double(Int64(self.switchTimeInterval * TimeInterval(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delay) {
                self.animateImageView()
            }
        }
        
        let transition = CATransition()
        transition.type = kCATransitionFromRight
        /*
         transition.type = kCATransitionPush
         transition.subtype = kCATransitionFromRight
         */
        viewImage.layer.add(transition, forKey: kCATransition)
        viewImage.image = Constants.images[counter]
        
        CATransaction.commit()
        
        counter = counter < Constants.images.count - 1 ? counter + 1 : 0
    }

    
}
