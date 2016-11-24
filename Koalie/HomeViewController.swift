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
import SCLAlertView

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PresentInfoViewProtocol {
    @IBOutlet weak var eventTableView: UITableView!
    @IBOutlet weak var labelInstructional: UILabel!
    var revealingSplashView: RevealingSplashView!
    var numberOfRows = 0
    
    var userData: NSDictionary!
    var eventDataList: [NSDictionary]!
    var userId: String!
    
    var loadingView: DGElasticPullToRefreshLoadingViewCircle!
    var cache: Cache<UIImage>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // getting rid of separators for empty cells
        self.eventTableView.tableFooterView = UIView()
        
//        // navigation bar height
//        self.navigationController?.navigationBar.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.frame.size.width, height: 80.0))
//        // set to false so nav bar won't cover view
//        self.navigationController?.navigationBar.isTranslucent = false

        
        // navigation bar shadow
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 4.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        
        // for splash window animation
        let window = UIApplication.shared.keyWindow
        revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "Koalie_Logo")!,iconInitialSize: CGSize(width: 120, height: 150), backgroundColor: Constants.backgroundColor.light)
        revealingSplashView.animationType = .heartBeat
        window?.addSubview(revealingSplashView)
        revealingSplashView.startAnimation(){
        }
        
        // pull to refresh
        loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.white
        self.eventTableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            print("pulled to refresh")
            self?.reloadData()
            self?.eventTableView.dg_stopLoading()
            }, loadingView: loadingView)
        self.eventTableView.dg_setPullToRefreshFillColor(Constants.backgroundColor.dark)
        self.eventTableView.dg_setPullToRefreshBackgroundColor(eventTableView.backgroundColor!)
        
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
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)

//        // navigation bar height
//        self.navigationController?.navigationBar.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.frame.size.width, height: 80.0))
//        // set to false so nav bar won't cover view
//        self.navigationController?.navigationBar.isTranslucent = false

    }
    
    @IBAction func buttonInfoClick(_ sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OptionsMenuVC") as! OptionsMenuTableViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
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
        return 104
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let cell = tableView.cellForRow(at: indexPath) as! EventTableViewCell
            let eventId = cell.eventId!
            let dict = ["eventId": eventId]
            if (cell.adminId != self.userId) {
                Alamofire.request(Constants.URIs.baseUri + Constants.routes.exitEvent, method: .post, parameters: dict, encoding: URLEncoding.default).responseJSON { response in
                    print("exited event")
                }
                numberOfRows -= 1
                tableView.deleteRows(at: [indexPath], with: .fade)
                SCLAlertView().showSuccess("Success!", subTitle: "You have exited the event")
            } else {
                Alamofire.request(Constants.URIs.baseUri + Constants.routes.deleteEvent, method: .post, parameters: dict, encoding: URLEncoding.default).responseJSON { response in
                    print("deleted event")
                }
                numberOfRows -= 1
                tableView.deleteRows(at: [indexPath], with: .fade)
                SCLAlertView().showSuccess("Success!", subTitle: "You have deleted the event")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        let eventData = eventDataList[(indexPath as NSIndexPath).row]
        let size = String(describing: eventData.object(forKey: "size")!)
        let filled = String(describing: (eventData.object(forKey: "member_ids") as! NSArray).count)
        var timeLeft = eventData.object(forKey: "timeLeft")! as! Int
        let endDateParsed = String(describing: eventData.object(forKey: "endDateParsed")!)
        let hoursLong = String(describing: eventData.object(forKey: "hoursLong")!)
        let medias = eventData.object(forKey: "media_ids") as! [NSDictionary]
        let users = eventData.object(forKey: "member_ids") as! [NSDictionary]
        let x = eventData.object(forKey: "x") as! Double
        let y = eventData.object(forKey: "y") as! Double
        let adminId = eventData.object(forKey: "admin") as! String
        
        cell.delegate = self
        
        cell.labelEvent.text = eventData.object(forKey: "name") as? String
        cell.labelSize.text = filled.appending(" / ").appending(size)
        cell.eventId = eventData.object(forKey: "_id") as! String
        cell.hoursLong = hoursLong
        cell.hoursLeft = String(describing: timeLeft)
        cell.userTotal = filled
        cell.eventSize = size
        cell.users = users
        cell.x = x
        cell.y = y
        cell.adminId = adminId
        
        // time left label
        if timeLeft <= 0 {
            cell.labelProgress.text = endDateParsed
            cell.viewOverLay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        } else if timeLeft <= 24 {
            cell.labelProgress.text = String(describing: timeLeft).appending(" Hours Left")
            cell.viewOverLay.backgroundColor = Constants.backgroundColor.dark.withAlphaComponent(0.8)
        } else {
            let daysLeft = timeLeft / 24
            timeLeft = timeLeft % 24
            cell.labelProgress.text = String(describing: daysLeft).appending(" Days ").appending(String(describing: timeLeft)).appending(" Hours Left")
            cell.viewOverLay.backgroundColor = Constants.backgroundColor.dark.withAlphaComponent(0.8)
        }
        
        // cell background image: most voted nonvideo image
        var storedPath = ""
        for media in medias {
            if !(media.object(forKey: "is_video") as! Bool) {
                storedPath = media.object(forKey: "stored_path")! as! String
                if let image = self.cache?[storedPath] {
                    cell.backgroundView = UIImageView(image: image)
                    cell.eventImage = image
                    cell.clipsToBounds = true
                    cell.backgroundView?.clipsToBounds = true
                    cell.backgroundView?.contentMode = .scaleAspectFill
                }
                break
            }
        }
        if storedPath == "" {
            cell.viewOverLay.backgroundColor = UIColor.clear
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    fileprivate func generateProfileImageView(_ urlString: String) -> UIView {
        let hw = (self.navigationController?.navigationBar.frame.size.height)! - 10
        let imgViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: hw, height: hw))
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
        imgViewContainer.layer.cornerRadius = hw / 2
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
//                self.navigationController?.setNavigationBarHidden(false, animated: true)
//                var newFrame = self.navigationController?.navigationBar.frame
//                newFrame?.size.height -= 16
//                self.navigationController!.navigationBar.frame = newFrame!
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
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension HomeViewController: DeinitPullToRefreshDelegate {
    func deinitPullToRefresh() {
        self.eventTableView.dg_removePullToRefresh()
    }
}
