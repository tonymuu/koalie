//
//  File.swift
//  Koalie
//
//  Created by Tony Mu on 5/10/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import Foundation
import UIKit.UIColor

struct Constants {
    static let images = [UIImage(named: "home-1.jpg"), UIImage(named: "home-2.jpg"), UIImage(named: "home-3.jpg")]
    
    
    struct backgroundColor {
        static let light = UIColor(red: 0.082, green: 0.729, blue: 0.600, alpha: 1.00)
        static let dark = UIColor(red: 0.043, green: 0.439, blue: 0.361, alpha: 1.00)
        static let selected = UIColor(red: 0.063, green: 0.588, blue: 0.482, alpha: 1.00)
    }
    
    struct size {
        static let bttfHeight = 40
    }
    
    struct URIs {
        static let baseUri = "http://localhost:3000"
    }
    
    struct routes {
        static let auth = "/auth/facebook/token"
        static let getMedias = "/medias"
        static let createEvent = "/create_event"
        static let getEvents = "/joined_events"
        static let searchEvents = "/search_events"
        static let joinEvent = "/join_event"
    }
}

