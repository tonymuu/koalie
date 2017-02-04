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
    
    
    @IBAction func finalizeButtonClick(_ sender: AnyObject) {
        
    }
    
    @IBAction func buttonBackClick(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
