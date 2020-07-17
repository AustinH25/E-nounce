//
//  LocationViewController.swift
//  E-nounce
//
//  Created by Yu WenLiao on 10/4/19.
//  Copyright © 2019 Yu WenLiao. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate {
    // MARK: - Properties
    var LocationManager:CLLocationManager=CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.delegate=self
        LocationManager.desiredAccuracy=kCLLocationAccuracyBest
        LocationManager.requestAlwaysAuthorization()

        // Do any additional setup after loading the view.
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status{
        case .restricted,.denied,.notDetermined:
            //report an error and do something
            print("error")
        default:
            //location is allowed start monitoring
            manager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        //do something with the error
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.last != nil{
        //print(locationObj.coordinate)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
