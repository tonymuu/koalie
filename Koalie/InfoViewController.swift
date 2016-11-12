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
    var locationManager: CLLocationManager!
    
    @IBAction func buttonBackClick(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonAddTimeClick(_ sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TimeInfoVC") as! TimeInfoViewController
        vc.eventId = self.eventId
        vc.timeLeft = self.timeLeft
        vc.hoursLong = self.hoursLong
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func buttonAddPeopleClick(_ sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PeopleInfoVC") as! PeopleInfoViewController
        vc.eventId = self.eventId
        vc.userTotal = self.userTotal
        vc.eventSize = self.eventSize
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
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        self.labelTitle.text = self.eventName
        self.labelTimeLeft.text = self.timeLeft
        if self.eventImage != nil {
            self.viewImage.image = self.eventImage
        }
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        var mapRegion = MKCoordinateRegion()
        mapRegion.center.latitude = mapView.userLocation.coordinate.latitude
        mapRegion.center.longitude = mapView.userLocation.coordinate.longitude
        mapRegion.span.latitudeDelta = 0.2
        mapRegion.span.longitudeDelta = 0.2
        mapView.setRegion(mapRegion, animated: true)
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController!.navigationBar.isTranslucent = false
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        var mapRegion = MKCoordinateRegion()
        mapRegion.center.latitude = mapView.userLocation.coordinate.latitude
        mapRegion.center.longitude = mapView.userLocation.coordinate.longitude
        mapRegion.span.latitudeDelta = 0.2
        mapRegion.span.longitudeDelta = 0.2
        mapView.setRegion(mapRegion, animated: true)
    }
    
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable : Any]!) {
        
    }
    
    func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!) {
        
    }    
}
