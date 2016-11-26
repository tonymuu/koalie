//
//  EventGalleryViewController.swift
//  Koalie
//
//  Created by Tony Mu on 11/15/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import Alamofire

class EventGalleryViewController: GalleryViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let dict = ["eventId": eventId!]
        
        
        Alamofire.request(Constants.URIs.baseUri + Constants.routes.getEventMedias, method: .get, parameters: dict, encoding: URLEncoding.default).responseJSON { response in switch response.result {
        case .success(let data):
            self.mediaList = data as! [NSDictionary] as NSArray?
            self.numberOfRows = (self.mediaList?.count)!
            self.tableView.reloadData()
        case .failure(let error):
            print(error)
            }
        }
    }
}
