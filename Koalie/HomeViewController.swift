//
//  HomeViewController.swift
//  Koalie
//
//  Created by Tony Mu on 5/8/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKLoginKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var labelInstructional: UILabel!
    
    var numberOfRows = 0
    
    var userData: NSDictionary!
    var eventDataList: [NSDictionary]!
    
    override func viewDidLoad() {
        returnUserData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            numberOfRows -= 1
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        
        let eventData = eventDataList[(indexPath as NSIndexPath).row]
        
        cell.labelEvent.text = eventData.object(forKey: "name") as? String
        cell.eventId = eventData.object(forKey: "_id") as! String
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let cell = tableView.cellForRow(at: indexPath) as! EventTableViewCell
        
        let camVC = LLSimpleCamViewController()
        camVC.eventId = cell.eventId
        
        self.present(camVC, animated: true, completion: nil)
        
        return indexPath
    }
    
    fileprivate func generateProfileImageView(_ urlString: String) -> UIView {
        let hw = self.navigationController?.navigationBar.frame.size.height
        let imgViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let imgView = UIImageView(frame: imgViewContainer.frame)
        let url = URL(string: urlString)
        if let imgData = try? Data(contentsOf: url!) {
            imgView.image = UIImage(data: imgData)
        }
        imgViewContainer.layer.cornerRadius = hw! / 2
        imgViewContainer.layer.borderWidth = 1.5
        imgViewContainer.layer.borderColor = (UIColor.white).cgColor
        imgViewContainer.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        
        imgViewContainer.addSubview(imgView)

        return imgViewContainer
    }
    
    fileprivate func returnUserData() {
        let token = FBSDKAccessToken.current().tokenString
        
        // important! it has to be named "access token" to authenticate.
        let dict = ["access_token": token]
        
        Alamofire.request(Constants.URIs.baseUri + Constants.routes.auth, method: .get, parameters: dict, encoding: URLEncoding.default).responseJSON { response in
            print(response.request)
            Alamofire.request(Constants.URIs.baseUri + Constants.routes.getEvents, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON { response in switch response.result {
            case .success(let data):
                super.viewDidLoad()
                self.eventTableView.delegate = self
                self.eventTableView.dataSource = self

                
                let dict = data as! NSDictionary
                self.userData = dict
                self.eventDataList = self.userData.object(forKey: "events") as! [NSDictionary]
                
                self.numberOfRows = self.eventDataList.count
                
                if self.numberOfRows != 0 {
                    self.labelInstructional.text = ""
                }
                
                self.navigationItem.titleView = self.generateProfileImageView(self.userData.object(forKey: "picture") as! String)
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                
                self.eventTableView.reloadData()

            case .failure(let error):
                print(error)
                }
            }
        }
    }

}
