//
//  InfoViewController.swift
//  Koalie
//
//  Created by Tony Mu on 6/5/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import MapKit
import FBSDKShareKit

class InfoViewController: UIViewController, MKMapViewDelegate, FBSDKAppInviteDialogDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelTimeLeft: UILabel!
    @IBOutlet weak var viewImage: UIImageView!
    
    var eventId: String!
    var eventName: String!
    var timeLeft: String!
    var hoursLeft: String!
    var hoursLong: String!
    var eventSize: String!
    var userTotal: String!
    var eventImage: UIImage!
    var users: [NSDictionary]!
    var x: Double!
    var y: Double!
    
    @IBAction func buttonBackClick(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonAddTimeClick(_ sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TimeInfoVC") as! TimeInfoViewController
        vc.eventId = self.eventId
        vc.hoursLeft = self.hoursLeft
        vc.hoursLong = self.hoursLong
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonAddPeopleClick(_ sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PeopleInfoVC") as! PeopleInfoViewController
        vc.eventId = self.eventId
        vc.userTotal = self.userTotal
        vc.eventSize = self.eventSize
        vc.users = self.users
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonInviteClick(_ sender: AnyObject) {
        let content = FBSDKAppInviteContent()
        content.appLinkURL = URL(string: Constants.URIs.facebookAppUrl)
        FBSDKAppInviteDialog.show(from: self, with: content, delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelTitle.text = self.eventName
        self.labelTimeLeft.text = self.timeLeft
        if self.eventImage != nil {
            self.viewImage.image = self.eventImage
        }
        
        // add tap to fullscreen to mapview
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(fullscreenMapview))
        self.mapView.addGestureRecognizer(tapRecognizer)
        
        // init map view
        mapView.delegate = self
        mapView.showsUserLocation = false
        var mapRegion = MKCoordinateRegion()
        let annotation = MKPointAnnotation()
        mapRegion.center.latitude = self.x
        mapRegion.center.longitude = self.y
        annotation.coordinate = mapRegion.center
        annotation.title = self.eventName
        self.mapView.addAnnotation(annotation)
        mapRegion.span.latitudeDelta = 0.2
        mapRegion.span.longitudeDelta = 0.2
        mapView.setRegion(mapRegion, animated: true)
        mapView.setCenter(mapRegion.center, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController!.navigationBar.isTranslucent = true

        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        UIView.animate(withDuration: 0.5, animations: {
//            self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
//            self.navigationController!.navigationBar.shadowImage = UIImage()
//        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
//        self.navigationController!.navigationBar.isTranslucent = false

    }
    
    
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
        
    }
    
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!) {
        
    }
    
    func fullscreenMapview() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapViewController
        vc.x = self.x
        vc.y = self.y
        vc.eventName = self.eventName
        self.present(vc, animated: true, completion: nil)
    }
}
