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
import AwesomeCache
import RevealingSplashView
import DGElasticPullToRefresh


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PresentInfoViewProtocol {
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var labelInstructional: UILabel!
    var revealingSplashView: RevealingSplashView!
    var numberOfRows = 0
    
    var userData: NSDictionary!
    var eventDataList: [NSDictionary]!
    var userId: String!
    
    var cache: Cache<UIImage>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for splash window animation
        let window = UIApplication.shared.keyWindow
        revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "KoalieLogo")!,iconInitialSize: CGSize(width: 120, height: 150), backgroundColor: Constants.backgroundColor.light)
        revealingSplashView.animationType = .heartBeat
        window?.addSubview(revealingSplashView)
        revealingSplashView.startAnimation(){
        }
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.white
        self.eventTableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            print("pulled to refresh")
            self?.reloadData()
            self?.eventTableView.dg_stopLoading()
            }, loadingView: loadingView)
        self.eventTableView.dg_setPullToRefreshFillColor(eventTableView.backgroundColor!)
        self.eventTableView.dg_setPullToRefreshBackgroundColor(Constants.backgroundColor.dark)
        
        
        self.eventTableView.delegate = self
        self.eventTableView.dataSource = self
        
        // for reloading data
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name: NSNotification.Name(rawValue: "NotificationReloadData"), object: nil)
        self.returnUserData()
        
        do {
            self.cache = try Cache<UIImage>(name: "imageCache")
        } catch _ {
            print("Something wrong")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToInfoSegue" {
            let destinationVC = segue.destination as! InfoViewController
            
        }
    }

    @IBAction func buttonInfoClick(_ sender: AnyObject) {
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
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
        let size = String(describing: eventData.object(forKey: "size")!)
        let filled = String(describing: (eventData.object(forKey: "member_ids") as! NSArray).count)
        var timeLeft = eventData.object(forKey: "timeLeft")! as! Int
        let medias = eventData.object(forKey: "media_ids") as! [NSDictionary]
        var storedPath = ""
        for media in medias {
            if !(media.object(forKey: "is_video") as! Bool) {
                storedPath = media.object(forKey: "stored_path")! as! String
                break
            }
        }
        
        cell.delegate = self
        
        cell.labelEvent.text = eventData.object(forKey: "name") as? String
        cell.labelSize.text = filled.appending(" / ").appending(size)
        cell.eventId = eventData.object(forKey: "_id") as! String
        
        if timeLeft <= 0 {
            cell.labelProgress.text = "Ended on ".appending(String(describing: eventData.object(forKey: "date_end")!))
        } else if timeLeft <= 24 {
            cell.labelProgress.text = String(describing: timeLeft).appending(" Hours Left")
        } else {
            let daysLeft = timeLeft / 24
            timeLeft = timeLeft % 24
            cell.labelProgress.text = String(describing: daysLeft).appending(" Days ").appending(String(describing: timeLeft)).appending(" Hours Left")
        }
        if let image = self.cache?[storedPath] {
            cell.backgroundView = UIImageView(image: image)
            cell.eventImage = image
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let cell = tableView.cellForRow(at: indexPath) as! EventTableViewCell
        
        let camVC = LLSimpleCamViewController()
        camVC.eventId = cell.eventId
        camVC.userId = self.userId
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
            
            let textAttachment = NSTextAttachment()
            textAttachment.image = UIImage(data: imgData)
            let attachmentString = NSAttributedString(attachment: textAttachment)
            let myString = NSMutableAttributedString(string: "My Name")
            myString.append(attachmentString)

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
        let token: String = FBSDKAccessToken.current().tokenString
        
        // important! it has to be named "access token" to authenticate.
        let dict = ["access_token": token]
        
        Alamofire.request(Constants.URIs.baseUri + Constants.routes.auth, method: .get, parameters: dict, encoding: URLEncoding.default).responseJSON { response in
            print(response.request)
            Alamofire.request(Constants.URIs.baseUri + Constants.routes.getEvents, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON { response in switch response.result {
            case .success(let data):
                let dict = data as! NSDictionary
                self.userId = dict.object(forKey: "_id") as! String
                self.userData = dict.object(forKey: "facebook") as! NSDictionary
                self.eventDataList = self.userData.object(forKey: "events") as! [NSDictionary]
                self.numberOfRows = self.eventDataList.count
                if self.numberOfRows != 0 {
                    self.labelInstructional.text = ""
                }
                self.navigationItem.titleView = self.generateProfileImageView(self.userData.object(forKey: "picture") as! String)
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.eventTableView.reloadData()
                self.revealingSplashView.finishHeartBeatAnimation()
            case .failure(let error):
                print(error)
                }
            }
        }
    }
    
    func reloadData() {
        returnUserData()
    }
    
    func presentInfoView(controller: UIViewController) {
        self.present(controller, animated: true, completion: nil)
    }
}
