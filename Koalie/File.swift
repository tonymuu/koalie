//
//  File.swift
//  Koalie
//
//  Created by Tony Mu on 5/10/16.
//  Copyright 2016 Koa. All rights reserved.
//

import Foundation
import UIKit.UIColor

struct Constants {
    static let images = [UIImage(named: "home-1.jpg"), UIImage(named: "home-2.jpg"), UIImage(named: "home-3.jpg")]
    
    
    struct backgroundColor {
        static let light = UIColor(red: 0.082, green: 0.729, blue: 0.600, alpha: 1.00)
        static let dark = UIColor(red: 0.043, green: 0.439, blue: 0.361, alpha: 1.00)
        static let darkTranslucent = UIColor(red: 0.043, green: 0.439, blue: 0.361, alpha: 0.50)
        static let selected = UIColor(red: 0.063, green: 0.588, blue: 0.482, alpha: 1.00)
        
        static let hexLight: UInt = 0x15BA99
        static let hexDark: UInt = 0x0B705C
    }
    
    struct size {
        static let bttfHeight = 40
    }
    
    struct URIs {
        // production url
       static let baseUri = "https://koalie.herokuapp.com"
        
        // dev url
//        static let baseUri = "http://localhost:3000"
        
        static let facebookAppUrl = "https://fb.me/1712424622418492"

    }
    
    struct routes {
        static let auth = "/auth/facebook/token"
        static let getEventMedias = "/event_medias"
        static let getMyMedias = "/my_medias"
        static let createMedia = "/create_media"
        static let createEvent = "/create_event"
        static let getEvents = "/joined_events"
        static let searchEvents = "/search_events"
        static let joinEvent = "/join_event"
        static let postUpvotes = "/vote_media"
        static let addPeople = "/add_people"
        static let addTime = "/add_time"
        static let deleteEvent = "/delete_event"
        static let exitEvent = "/exit_event"
    }
    
    struct messages {
        static let notFound = "NotFound"
        static let eventfull = "EventFull"
        static let alreadyJoined = "AlreadyJoined"
        static let success = "Success"
    }
    
    struct labelStrings {
        static let joinSuccess = "You have joined the event!"
        static let createSuccess = "Your event has been created!"
    }
    
    struct bundles {
        static let FiftySpotBundle = "com.koa.Koalie.50_spot_bundle"
    }
}

