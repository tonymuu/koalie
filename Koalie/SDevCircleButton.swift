//
//  SDevCircleButton.swift
//  SDevCircleButtonSwift
//
//  Created by Sedat ÇİFTÇİ on 15/10/14.
//  Copyright (c) 2014 Sedat ÇİFTÇİ. All rights reserved.
//

import UIKit

let SDevCircleButtonBorderWidth : CGFloat = 3.0


class SDevCircleButton: UIButton {
    var borderColor: UIColor!
    var animateTap: Bool!
    var displayShading: Bool?
    var borderSize: CGFloat!
    
    var highLightView: UIView!
    var gradientLayerTop: CAGradientLayer!
    var gradientLayerBottom: CAGradientLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        highLightView = UIView(frame: frame)
        highLightView.alpha = 0
        highLightView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        borderColor = UIColor.white
        animateTap = true
        borderSize = SDevCircleButtonBorderWidth
        
        self.clipsToBounds = true
        self.titleLabel?.textAlignment = NSTextAlignment.center
        self.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        gradientLayerTop = CAGradientLayer()
        gradientLayerTop.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height / 4)
        gradientLayerTop.colors = [UIColor.black.cgColor as AnyObject!,UIColor.black.withAlphaComponent(0.01).cgColor as AnyObject!]
        
        
        gradientLayerBottom = CAGradientLayer()
        gradientLayerBottom.frame = CGRect(x: 0, y: frame.size.height * 3 / 4, width: frame.size.width, height: frame.size.height / 4)
        gradientLayerBottom.colors = [UIColor.lightGray.withAlphaComponent(0.01).cgColor as AnyObject!, UIColor.black.cgColor as AnyObject!]
        
        self.addSubview(highLightView)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDisplayShading(_ displayShading: Bool) -> Void {
        self.displayShading = displayShading
        
        if displayShading {
            self.layer.addSublayer(self.gradientLayerTop)
            self.layer.addSublayer(self.gradientLayerBottom)
        } else {
            self.gradientLayerTop.removeFromSuperlayer()
            self.gradientLayerBottom.removeFromSuperlayer()
        }
        
        self.layoutSubviews()
    }
    
    func setBorderColorForButton(_ borderColor: UIColor) -> Void {
        self.borderColor = borderColor
        self.layoutSubviews()
    }
    
    
    override func layoutSubviews() -> Void {
        super.layoutSubviews()
        self.updateMaskToBounds(self.bounds)
    }
    
    
    func setHighlightedForButton(_ highlighted: Bool) -> Void {
        if highlighted {
            self.layer.borderColor = self.borderColor.withAlphaComponent(1).cgColor
            self.triggerAnimateTap()
        } else {
            self.layer.borderColor = self.borderColor.withAlphaComponent(0.7).cgColor
        }
    }
    
    func updateMaskToBounds(_ maskBounds: CGRect) -> Void {
        let maskLayer: CAShapeLayer = CAShapeLayer()
        let maskPath: CGPath = CGPath(ellipseIn: maskBounds, transform: nil)
        
        maskLayer.bounds = maskBounds
        maskLayer.path = maskPath
        maskLayer.fillColor = UIColor.black.cgColor
        
        let point : CGPoint = CGPoint(x: maskBounds.size.width / 2, y: maskBounds.size.height / 2)
        maskLayer.position = point
        
        self.layer.mask = maskLayer
        
        self.layer.cornerRadius = maskBounds.height / 2.0
        self.layer.borderColor = self.borderColor .withAlphaComponent(0.7).cgColor
        self.layer.borderWidth = self.borderSize
        
        self.highLightView.frame = self.bounds
        
    }
    
    func blink() -> Void {
        let pathFrame: CGRect = CGRect(x: -self.bounds.midX, y: -self.bounds.midY, width: self.bounds.size.width, height: self.bounds.size.height)
        let path: UIBezierPath = UIBezierPath(roundedRect: pathFrame, cornerRadius: self.layer.cornerRadius)
        
        let shapePosition: CGPoint = self.superview!.convert(self.center, from: self.superview)
        
        let circleShape: CAShapeLayer = CAShapeLayer()
        circleShape.path = path.cgPath
        circleShape.position = shapePosition
        circleShape.fillColor = UIColor.clear.cgColor
        circleShape.opacity = 0
        circleShape.strokeColor = self.borderColor.cgColor
        circleShape.lineWidth = 2.0
        
        self.superview!.layer.addSublayer(circleShape)
        
        let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3DMakeScale(2.0, 2.0, 1))
        
        let alphaAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 1
        alphaAnimation.toValue = 0
        
        let animation: CAAnimationGroup = CAAnimationGroup()
        animation.animations = [scaleAnimation, alphaAnimation]
        animation.duration = 0.7
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        circleShape.add(animation, forKey: nil)
        
    }
    
    func triggerAnimateTap() -> Void {
        if self.animateTap == false {
            return
        }
        
        self.highLightView.alpha = 1
        
        let this: SDevCircleButton = self
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            this.highLightView.alpha = 0.0
            }, completion: nil)
        
        let pathFrame: CGRect = CGRect(x: -self.bounds.midX, y: -self.bounds.midY, width: self.bounds.size.width, height: self.bounds.size.height)
        let path: UIBezierPath = UIBezierPath(roundedRect: pathFrame, cornerRadius: self.layer.cornerRadius)
        
        let shapePosition: CGPoint = self.superview!.convert(self.center, from: self.superview)
        
        let circleShape: CAShapeLayer = CAShapeLayer()
        circleShape.path = path.cgPath
        circleShape.position = shapePosition
        circleShape.fillColor = UIColor.clear.cgColor
        circleShape.opacity = 0
        circleShape.strokeColor = self.borderColor.cgColor
        circleShape.lineWidth = 2.0
        
        self.superview?.layer.addSublayer(circleShape)
        
        
        let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3DMakeScale(2.5, 2.5, 1))
        
        let alphaAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 1
        alphaAnimation.toValue = 0
        
        let animation: CAAnimationGroup = CAAnimationGroup()
        animation.animations = [scaleAnimation, alphaAnimation]
        animation.duration = 0.7
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        circleShape.add(animation, forKey: nil)
        
        
    }
    
    func setImage(_ image: UIImage!, animated: Bool) -> Void {
        super.setImage(nil, for: UIControlState())
        super.setImage(image, for: UIControlState.selected)
        super.setImage(image, for: UIControlState.highlighted)
        
        if animated {
            let tmpImageView : UIImageView = UIImageView(frame: self.bounds)
            
            tmpImageView.image = image
            tmpImageView.alpha = 0
            tmpImageView.backgroundColor = UIColor.clear
            tmpImageView.contentMode = UIViewContentMode.scaleAspectFit
            self.addSubview(tmpImageView)
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                tmpImageView.alpha = 1
                }, completion: { (finished) -> Void in
                    self.setImage(image, tmpImageView: tmpImageView)
            })
        } else {
            super.setImage(image, for: UIControlState())
        }
        
    }
    
    
    func setImage(_ image: UIImage, tmpImageView : UIImageView) -> Void {
        super.setImage(image, for: UIControlState())
        tmpImageView.removeFromSuperview()
    }
    
}
