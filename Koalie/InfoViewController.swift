//
//  InfoViewController.swift
//  Koalie
//
//  Created by Tony Mu on 6/5/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import MapKit
import ExpandingMenu

class InfoViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelTimeLeft: UILabel!
    @IBOutlet weak var viewImage: UIImageView!
    
    var eventId: String!
    var eventName: String!
    var timeLeft: String!
    var eventImage: UIImage!
    var locationManager: CLLocationManager!
    
    @IBAction func buttonBackClick(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonMenuClick(_ sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        self.labelTitle.text = self.eventName
        self.labelTimeLeft.text = self.timeLeft
        self.viewImage.image = self.eventImage
        
        let menuButtonSize: CGSize = CGSize(width: 64.0, height: 64.0)
        let menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize), centerImage: UIImage(named: "Plus Icon")!, centerHighlightedImage: UIImage(named: "Minus Icon")!)
        menuButton.center = CGPoint(x: self.view.bounds.width - 32.0, y: self.view.frame.origin.y + 48)
        menuButton.expandingDirection = .bottom
        view.addSubview(menuButton)

        let addTimeButton = ExpandingMenuItem(size: menuButtonSize, title: "Length", image: UIImage(named: "Clock Icon")!, highlightedImage: UIImage(named: "Clock Icon")!, backgroundImage: UIImage(named: ""), backgroundHighlightedImage: UIImage(named: "")) { () -> Void in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddTimeVC") as! MoreTimeViewController
            vc.eventId = self.eventId
            self.present(vc, animated: true, completion: nil)
        }
        
        let addPeopleButton = ExpandingMenuItem(size: menuButtonSize, title: "People", image: UIImage(named: "Add People Icon")!, highlightedImage: UIImage(named: "Add People Icon")!, backgroundImage: UIImage(named: ""), backgroundHighlightedImage: UIImage(named: "")) { () -> Void in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPeopleVC") as! MorePeopleViewController
            vc.eventId = self.eventId
            self.present(vc, animated: true, completion: nil)
        }
        let inviteButton = ExpandingMenuItem(size: menuButtonSize, title: "Invite", image: UIImage(named: "Play Icon")!, highlightedImage: UIImage(named: "Play Icon")!, backgroundImage: UIImage(named: ""), backgroundHighlightedImage: UIImage(named: "")) { () -> Void in
            // Do some action
        }

        addTimeButton.contentMode = .scaleAspectFill
        addPeopleButton.contentMode = .scaleAspectFit
        inviteButton.contentMode = .scaleToFill
        
        addTimeButton.clipsToBounds = true
        addPeopleButton.clipsToBounds = true
        inviteButton.clipsToBounds = true

        menuButton.addMenuItems([addTimeButton, addPeopleButton, inviteButton])
        
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
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        var mapRegion = MKCoordinateRegion()
        mapRegion.center.latitude = mapView.userLocation.coordinate.latitude
        mapRegion.center.longitude = mapView.userLocation.coordinate.longitude
        mapRegion.span.latitudeDelta = 0.2
        mapRegion.span.longitudeDelta = 0.2
        mapView.setRegion(mapRegion, animated: true)
    }
}
