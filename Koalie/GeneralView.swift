//
//  GeneralView.swift
//  Koalie
//
//  Created by Tony Mu on 6/11/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit

class GeneralView: UIView {
    @IBOutlet weak var viewImage: UIImageView!

    @IBAction func buttonDismissClick(_ sender: AnyObject) {
        animateDismissView()
    }
    
    func animateDismissView() {
        CATransaction.begin()
        
        CATransaction.setAnimationDuration(0.4)
        
        let transition = CATransition()
        transition.type = kCATransitionFade
        /*
         transition.type = kCATransitionPush
         transition.subtype = kCATransitionFromRight
         */
        self.layer.add(transition, forKey: kCATransition)
        self.removeFromSuperview()
        CATransaction.commit()
    }

    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ThemeView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
