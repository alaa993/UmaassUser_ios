//
//  MapVC.swift
//  Umaass
//
//  Created by Hesam on 7/1/1398 AP.
//  Copyright © 1398 Hesam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import GoogleMaps
import GooglePlaces

enum location {
    case startLocation
    case destinationLocation
}

class MapVC: UIViewController , CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate {
    
    
    @IBOutlet weak var addressView           : UIView!
    @IBOutlet weak var startAddressLabel     : UILabel!
    @IBOutlet weak var startAddLab: UILabel!
    @IBOutlet weak var endAddressLabel       : UILabel!
    @IBOutlet weak var destinationLab: UILabel!
    
    @IBOutlet weak var googleMapView         : GMSMapView!
    @IBOutlet weak var markerImg             : UIImageView!
    
    @IBOutlet weak var selectLocationView    : UIView!
    @IBOutlet weak var getLocationBtn        : UIButton!
    
    //    @IBOutlet weak var directionView         : UIView!
    //    @IBOutlet weak var cancelBtn             : UIButton!
    //    @IBOutlet weak var showDirectionBtn      : UIButton!
    
    var markList = [GMSMarker]()
    
    
    var locationManager  = CLLocationManager()
    var locationSelected = location.startLocation
    var bounds           = GMSCoordinateBounds()
    var locationStart    = CLLocation()
    var locationEnd      = CLLocation()
    
    // current
    // orlat = 29.661067136248732
    // orlng = 52.47937603999992
    
    // destination
    // deslat = 29.650983187458184
    // deslng = 52.48368367552757
    
    var lat              : Double? = 0.0
    var lng              : Double? = 0.0
    var providerMarker   = GMSMarker()
    var currentMarker    = GMSMarker()
    var polyline         = GMSPolyline()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLabelLanguageData(label: startAddLab, key: "Start location")
        setLabelLanguageData(label: destinationLab, key: "destination")
        setButtonLanguageData(button: getLocationBtn, key: "location")
        setMessageLanguageData(&providerPageTitle, key: "location")
        self.navigationItem.title = providerPageTitle
        
        self.selectLocationView.isHidden = false
        self.addressView.isHidden = true
        
        //        self.directionView.isHidden = true
        cornerViews(view: selectLocationView, cornerValue: 6.0, maskToBounds: true)
        //        cornerViews(view: directionView, cornerValue: 6.0, maskToBounds: true)
        
        GMSPlacesClient.shared()
        locationManager.delegate = self
        
        googleMapView.settings.zoomGestures = true
        googleMapView.animate(toViewingAngle: 45)
        googleMapView.isMyLocationEnabled = true
        googleMapView.settings.compassButton = true
        googleMapView.settings.myLocationButton = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        // ---- provider location ---------
        providerMarker.position = CLLocationCoordinate2D(latitude: Double(providerLat ?? "0.00") ?? 0.00, longitude: Double(providerLng ?? "0.00") ?? 0.00)
        locationEnd = CLLocation(latitude: Double(providerLat ?? "0.00") ?? 0.00, longitude: Double(providerLng ?? "0.00") ?? 0.00)
        providerMarker.icon = GMSMarker.markerImage(with: .red)
        providerMarker.title = "Provider Location"
        providerMarker.map = self.googleMapView
        markList.append(providerMarker)
        
//        let button = UIButton.init(type: .custom)
//        let widthConstraint = button.widthAnchor.constraint(equalToConstant: 50)
//        let heightConstraint = button.heightAnchor.constraint(equalToConstant: 50)
//        heightConstraint.isActive = true
//        widthConstraint.isActive = true
//        button.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
//        cornerButton(button: button, cornerValue: 4.0, maskToBounds: true)
//        button.setImage(UIImage.init(named: "umaassIcon.png"), for: UIControl.State.normal)
//        let logoImg = UIBarButtonItem.init(customView: button)
        
        let searchBtn = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchLocation))
        navigationItem.rightBarButtonItem = searchBtn
    }
    
    @objc func searchLocation(){
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    
    @IBAction func showRouteTapped(_ sender: Any) {
        
        polyline.map = nil
        //        self.selectLocationView.isHidden = true
        //        self.directionView.isHidden = false
        //---------------------------------- get lat & lng ------------------------------------
        lat = self.googleMapView.camera.target.latitude
        lng = self.googleMapView.camera.target.longitude
        print(lat ?? 0.000)
        print(lng ?? 0.000)
        locationStart = CLLocation(latitude: lat ?? 0.00, longitude: lng ?? 0.00)
        //------------------------------------ set Marker -------------------------------------
        currentMarker.position = CLLocationCoordinate2D(latitude: self.googleMapView.camera.target.latitude, longitude: self.googleMapView.camera.target.longitude)
        currentMarker.icon = GMSMarker.markerImage(with: .blue)
        currentMarker.map  = googleMapView
        markList.append(currentMarker)
        
        for marker in self.markList{
            self.bounds = bounds.includingCoordinate(marker.position)
        }
        let update = GMSCameraUpdate.fit(self.bounds, withPadding: 70)
        self.googleMapView.animate(with: update)
        
        self.drawPath(startLocation: locationStart, endLocation: locationEnd)
    }
    
    
    // Mark - Location Manager Delegate -------------------------------------------------------
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while get location\(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 15)
        self.googleMapView.camera = camera
        print("Latitude : \(userLocation!.coordinate.latitude)")
        print("Longitude : \(userLocation!.coordinate.longitude)")
        
        
        locationManager.stopUpdatingLocation()
    }
    
    // Mark: - GMS Auto Complete Delegate --------------------------------------------------
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 14.0)
        self.googleMapView.camera = camera
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error AutoComplete \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    
    // Mark - GMSMapview Delegate --------------------------------------------------
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.googleMapView.isMyLocationEnabled = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.googleMapView.isMyLocationEnabled = true
        if (gesture) {
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.googleMapView.isMyLocationEnabled = true
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("Coordinate: ", "\(coordinate)")
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        self.googleMapView.isMyLocationEnabled = true
        mapView.selectedMarker = nil
        return false
    }
    
    // Mark: Draw Direction Function --------------------------------------------------
    func drawPath(startLocation: CLLocation, endLocation: CLLocation){
        //        self.showDirectionBtn.isEnabled = false
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=" + googleApiKey
        
        Alamofire.request(url).responseJSON { response in
            //            print(response.request as Any)
            //            print(response.response as Any)
            //            print(response.data as Any)
            //            print(response.result as Any)
            let json = JSON(response.data!)
            print(json)
            let routes = json["routes"].arrayValue
            // --- print route on map using polyline ---------------------------------------------------------
            for route in routes {
                let routeOverViewPolyline = route["overview_polyline"].dictionary
                let points = routeOverViewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                self.polyline = GMSPolyline.init(path: path)
                self.polyline.strokeWidth = 4
                self.polyline.strokeColor = .blue
                self.polyline.map = self.googleMapView
                
                let legs = route["legs"].arrayValue
                //                let step = legs[0]["steps"].arrayValue
                let startAddress = legs[0]["start_address"].stringValue
                self.startAddressLabel.text = (startAddress)
                let endAddress = legs[0]["end_address"].stringValue
                self.endAddressLabel.text = (endAddress)
                self.addressView.isHidden = false
                for marker in self.markList{
                    self.bounds = self.bounds.includingCoordinate(marker.position)
                }
                let update = GMSCameraUpdate.fit(self.bounds, withPadding: 60)
                self.googleMapView.animate(with: update)
            }
        }
    }
    
    
    
}








