//
//  GalleryViewController.swift
//  Koalie
//
//  Created by Tony Mu on 6/1/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBAction func buttonBackClick(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var eventTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventTableView.delegate = self
        eventTableView.dataSource = self
        

        // Do any additional setup after loading the view.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PictureCell")
        
        
        
        return cell!
    }

}
