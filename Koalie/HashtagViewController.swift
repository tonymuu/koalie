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
    
    @IBAction func buttonNextClick(_ sender: AnyObject) {
        
    }
    
    @IBAction func buttonBackClick(_ sender: AnyObject) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newEvent = Event()
        newEvent.eventName = textfieldHashtag.text
        
        let destinationVC = segue.destination as! TimeViewController
        destinationVC.newEvent = newEvent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGR)
    }
    
    func dismissKeyboard() {
        textfieldHashtag.resignFirstResponder()
    }

}
