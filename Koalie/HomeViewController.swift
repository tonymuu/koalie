//
//  HomeViewController.swift
//  Koalie
//
//  Created by Tony Mu on 5/8/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var eventTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = Constants.backgroundColor.light
//        
//        eventTableView.backgroundColor = Constants.backgroundColor.light
        eventTableView.delegate = self
        eventTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath);
        
        cell.imageView?.contentMode = UIViewContentMode.Center
        cell.backgroundView?.contentMode = UIViewContentMode.Center
        
        let imgView = UIImageView(image: UIImage(named: "home-" + String(indexPath.row + 1) + ".jpg"))
        let filterView = UIView(frame: cell.frame)
        
        filterView.alpha = 0.5
        filterView.backgroundColor = UIColor.blackColor()
        
        cell.addSubview(imgView)
        cell.addSubview(filterView)

        
        return cell;
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
