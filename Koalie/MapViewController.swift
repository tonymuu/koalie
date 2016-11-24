//
//  MapViewController.swift
//  Koalie
//
//  Created by Tony Mu on 11/12/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var x: Double!
    var y: Double!
    var eventName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMap))
        mapView.addGestureRecognizer(tapRecognizer)
        
        
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
        mapRegion.span.latitudeDelta = 0.5
        mapRegion.span.longitudeDelta = 0.5
        mapView.setRegion(mapRegion, animated: true)
        mapView.setCenter(mapRegion.center, animated: true)
    }
    
    func dismissMap() {
        self.dismiss(animated: true, completion: nil)
    }
    
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        var mapRegion = MKCoordinateRegion()
//        mapRegion.center.latitude = mapView.userLocation.coordinate.latitude
//        mapRegion.center.longitude = mapView.userLocation.coordinate.longitude
//        mapRegion.span.latitudeDelta = 0.2
//        mapRegion.span.longitudeDelta = 0.2
//        mapView.setRegion(mapRegion, animated: true)
//    }
}
