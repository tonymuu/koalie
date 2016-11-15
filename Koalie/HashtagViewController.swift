//
//  HashtagViewController.swift
//  Koalie
//
//  Created by Tony Mu on 5/10/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit

class HashtagViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textfieldHashtag: UITextField!
    @IBOutlet weak var buttonNext: UIButton!
    
    @IBAction func editingChanged(_ sender: UITextField) {
        buttonNext.isEnabled = sender.hasText
    }
    
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
        
        self.buttonNext.isEnabled = false
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGR)
        
//        let labelHashtag = UILabel(frame: CGRect(origin: textfieldHashtag.frame.origin, size: CGSize(width: 40, height: textfieldHashtag.frame.size.height)))
//        labelHashtag.textAlignment = .center
//        labelHashtag.text = "#"
//        labelHashtag.textColor = UIColor.white
//        self.textfieldHashtag.leftViewMode = .whileEditing
//        self.textfieldHashtag.leftView = labelHashtag
        
        self.textfieldHashtag.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return (textField.text?.characters.count)! + string.characters.count > 1
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = "#"
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.characters.count == 1 {
            textField.text = ""
        }
    }
    
    func dismissKeyboard() {
        textfieldHashtag.resignFirstResponder()
    }
}
