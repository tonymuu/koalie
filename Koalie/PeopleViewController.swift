//
//  PeopleViewController.swift
//  Koalie
//
//  Created by Tony Mu on 5/11/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {
    @IBOutlet weak var buttonFirst: UIButton!

    @IBOutlet weak var buttonSecond: UIButton!
    @IBAction func ButtonBackClick(sender: AnyObject) {
        if buttonFirst.selected {
            print(1)
        }
        if buttonSecond.selected {
            print(2)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func ButtonCreateClick(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func firstSelected(sender: AnyObject) {
        setSelected(buttonFirst, buttonDeselected: buttonSecond)
    }
    
    @IBAction func secondSelected(sender: AnyObject) {
        setSelected(buttonSecond, buttonDeselected: buttonFirst)
    }

    func setSelected(buttonSelected: UIButton, buttonDeselected: UIButton) {    buttonSelected.selected = true
        buttonDeselected.selected = false
        
        buttonDeselected.backgroundColor = Constants.backgroundColor.dark
        buttonSelected.backgroundColor = Constants.backgroundColor.selected
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
