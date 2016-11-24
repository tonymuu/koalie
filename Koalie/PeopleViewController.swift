//
//  PeopleViewController.swift
//  Koalie
//
//  Created by Tony Mu on 5/11/16.
//  Copyright © 2016 Koa. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKLoginKit
import MapKit
import SwiftyStoreKit
import SCLAlertView

class PeopleViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var centerConstraints: NSLayoutConstraint!
    @IBOutlet weak var buttonFirst: UIButton!
    @IBOutlet weak var buttonSecond: UIButton!
    @IBOutlet weak var buttonCreate: UIButton!
    
    var newEvent: Event!
    var size: Int!
    var locationManager: CLLocationManager!
    var x: Double!
    var y: Double!
    
    
    @IBAction func ButtonBackClick(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ButtonCreateClick(_ sender: AnyObject) {
        if self.size == 50 {
            let alert = SCLAlertView()
            alert.addButton("Confirm", action: {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "VCOverview") as! OverviewViewController
                vc.eventName = self.newEvent.eventName
                vc.labelString = Constants.labelStrings.createSuccess
                self.present(vc, animated: true, completion: nil)
                self.navigationController?.popToRootViewController(animated: true)
                
                let dict = [
                    "eventName": self.newEvent!.eventName!,
                    "eventSize": String(self.newEvent!.eventSize),
                    "eventLength": String(self.newEvent!.eventLength),
                    "x": String(self.x),
                    "y": String(self.y)]
                
                Alamofire.request(Constants.URIs.baseUri + Constants.routes.createEvent, method: .post, parameters: dict, encoding: URLEncoding.default).responseJSON { response in
                    print(response.request ?? "Response request")
                }
            })
            alert.showSuccess("$1.99", subTitle: "$1.99 will add 50 spots to your event.")
        }
        
    }
    
    @IBAction func firstSelected(_ sender: AnyObject) {
        buttonSecond.backgroundColor = Constants.backgroundColor.dark
        buttonFirst.backgroundColor = Constants.backgroundColor.selected
        newEvent.eventSize = 5
        size = 5
    }
    
    @IBAction func secondSelected(_ sender: AnyObject) {
        buttonFirst.backgroundColor = Constants.backgroundColor.dark
        buttonSecond.backgroundColor = Constants.backgroundColor.selected
        newEvent.eventSize = 50
        size = 50
        SwiftyStoreKit.retrieveProductsInfo([Constants.bundles.FiftySpotBundle]) { result in
            if let product = result.retrievedProducts.first {
                let numberFormatter = NumberFormatter()
                numberFormatter.locale = product.priceLocale
                numberFormatter.numberStyle = .currency
                let priceString = numberFormatter.string(from: product.price ?? 0) ?? ""
                SCLAlertView().showInfo("Info", subTitle: "Product: \(product.localizedDescription), price: \(priceString)")
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                SCLAlertView().showError("Could not retrieve product info", subTitle: "Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(result.error)")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if newEvent == nil {
            newEvent = Event()
        }
        
        self.firstSelected(self)
        
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.x = locations.last?.coordinate.latitude
        self.y = locations.last?.coordinate.longitude
    }

}
