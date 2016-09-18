//
//  GalleryViewController.swift
//  Koalie
//
//  Created by Tony Mu on 6/1/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import Alamofire
import AWSS3

class GalleryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var eventTableView: UITableView!
    
    var eventId: String!

    var mediaList: NSArray?
    
    var numberOfRows = 0
    
    
    @IBAction func buttonBackClick(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.eventTableView.delegate = self
        self.eventTableView.dataSource = self

        
        let dict = ["eventId": eventId]
        
        
        Alamofire.request(Constants.URIs.baseUri + Constants.routes.getEventMedias, method: .get, parameters: dict, encoding: URLEncoding.default).responseJSON { response in switch response.result {
                case .success(let data):
                    self.mediaList = data as! [NSDictionary] as NSArray?
                    self.numberOfRows = (self.mediaList?.count)!
                    
                    
                    
                    self.eventTableView.reloadData()
                    
                case .failure(let error):
                    print(error)
            }
                print(response)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PictureCell") as! GalleryTableViewCell
        
        let dict = mediaList?.object(at: (indexPath as NSIndexPath).row) as! NSDictionary
        let name = dict.object(forKey: "_id") as! String
        let key = dict.object(forKey: "stored_path") as? String
        
        let transferManager = AWSS3TransferManager.default()
        
        ///// download
        let downloadingFilePath = URL(fileURLWithPath: NSTemporaryDirectory() + name)
        let downloadRequest = AWSS3TransferManagerDownloadRequest()
        downloadRequest?.bucket = "koalie-test-bucket"
        downloadRequest?.key = key
        downloadRequest?.downloadingFileURL = downloadingFilePath
        
        // download request
        
        let task = transferManager?.download(downloadRequest).continue( {(task: AWSTask!) -> AnyObject! in
            if ((task.error) != nil) {
                print(task.error)
            }
            if ((task.result) != nil) {
                let downloadOutput: AWSS3TransferManagerDownloadOutput = task.result as! AWSS3TransferManagerDownloadOutput
                return downloadOutput
            }
            return nil
        })
        cell.viewPicture.image = UIImage(contentsOfFile: downloadingFilePath.absoluteString)

        return cell
    }

}
