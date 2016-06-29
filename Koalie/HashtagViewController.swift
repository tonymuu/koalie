//
//  HashtagViewController.swift
//  Koalie
//
//  Created by Tony Mu on 5/10/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit

class HashtagViewController: UIViewController {
    
    @IBOutlet weak var textfieldHashtag: UITextField!
    
    @IBOutlet weak var buttonBack: UIButton!
    
    @IBOutlet weak var buttonNext: UIButton!
    
    @IBAction func buttonBackClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
