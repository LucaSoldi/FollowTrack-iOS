//
//  FollowMapViewController.swift
//  FollowTrack
//
//  Created by Luca Soldi on 10/02/17.
//  Copyright © 2017 Luca Soldi. All rights reserved.
//

import UIKit
import MapKit
import KCFloatingActionButton
import CoreLocation
import Foundation
import SocketIO
import CoreData

class FollowMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, SocketFollowDelegate, TripEndedDelegate, RoundRectButtonMapDelegate {
    
    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var floatingButton: KCFloatingActionButton!
    @IBOutlet weak var positionMapButton: RoundRectButtonMap!
    private let locationManager = CLLocationManager()
    private var socket: SocketIOClient?
    private var resetAck: SocketAckEmitter?
    private var followMyPin: Bool = true
    var leaderPin : FollowPin!
    var leader: Bool!
    var trackID: String!
    var socketID: String = ""
    var annotations = [FollowPin]()
    var passkey : String!
    var iv : String!
    var indexTest = 0
    private var lastLeaderLocation : CLLocationCoordinate2D?
    private var mapChangedFromUserInteraction = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupSocket()
        // Do any additional setup after loading the view.
    }
    
    
    private func setupSocket() {
        Socket.sharedInstance.setupPasskey(passkey, iv: iv)
        Socket.sharedInstance.delegate = self
        if (Socket.sharedInstance.socket?.status == SocketIOClientStatus.connected) {
            Socket.sharedInstance.setupTrackSocket(leader: leader, trackID: trackID)
            _ = Trip.createTrip(name: "", track_id: trackID, context: managedObjectContext!)
        }
    }
    
    private func setupUI() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        
        positionMapButton.delegate = self
        
        mapView.showsUserLocation = true
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
            
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse, .restricted, .denied:
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to be notified about adorable kittens near you, please open this app's settings and set location access to 'Always'.",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = URL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url, completionHandler: nil)
                }
            }
            alertController.addAction(openAction)
            
            self.present(alertController, animated: true, completion: nil)
            break
        }
        
//        floatingButton.addItem("Chat", icon: Graphics.imageOfChaticon(), handler: {_ in
//            self.performSegue(withIdentifier: "showChat", sender:self)
//        })
        floatingButton.addItem("Abort", icon: Graphics.imageOfAborticon(), handler: {_ in
            let alert = UIAlertController(title: "Abort", message: "Are you sure to abort the trip?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default) { action in
                _ = Trip.removeTrip(track_id: self.trackID, context: self.managedObjectContext!)
                _ = self.navigationController?.popToRootViewController(animated: true)
            })
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
        floatingButton.addItem("Done", icon: Graphics.imageOfLogo(), handler: {_ in
            self.performSegue(withIdentifier: "showTripEnded", sender:self)
        })
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(FollowMapViewController.disableFollowLocation))
        mapView.addGestureRecognizer(pinchGesture)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - MapKit
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        self.mapView.setRegion(region, animated: true)
        Socket.sharedInstance.sendNewLocation(latitude: Double(location!.coordinate.latitude), longitude: Double(location!.coordinate.longitude), trackID: trackID)
        _ = Coordinate.addCoordinateToTrip(track_id: self.trackID, latitude: Double(location!.coordinate.latitude), longitude: Double(location!.coordinate.longitude), context: managedObjectContext!)
        
        
        if leader {
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(FollowMapViewController.sendTestCoordinates), userInfo: nil, repeats: true)
        }

        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? FollowPin {
            let identifier = "followPin"
            var view: MKAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            }
            else {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.image = annotation.imageType()
            }
            view.image = annotation.imageType()
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return overlay as! MKOverlayRenderer
    }
    
    func sendTestCoordinates() {
        let new_loc_lat = (locationManager.location?.coordinate.latitude)! + (Double(indexTest) * 0.00002)
        let new_loc_long = (locationManager.location?.coordinate.longitude)! + (Double(indexTest) * 0.000001)
        Socket.sharedInstance.sendNewLocation(latitude: Double(new_loc_lat), longitude: Double(new_loc_long), trackID: trackID)
        _ = Coordinate.addCoordinateToTrip(track_id: self.trackID, latitude: Double(new_loc_lat), longitude: Double(new_loc_long), context: managedObjectContext!)
        indexTest += 1
    }

    // MARK: - Socket Delegate
    func didSocketConnected(sender: Socket) {
        //print("Socket Connected")
        Socket.sharedInstance.setupTrackSocket(leader: leader, trackID: trackID)
        _ = Trip.createTrip(name: "", track_id: trackID, context: managedObjectContext!)
    }
    
    func didUpdateLocation(sender: Socket, latitude: Double, longitude: Double, track_id: String, follower: Int?) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        if leaderPin == nil {
            leaderPin = FollowPin(title: "Leader", locationName: "", type: 0, coordinate: coordinate)
            annotations.append(leaderPin)
        }
        else {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: { () -> Void in
                self.leaderPin.coordinate = coordinate
            }, completion: nil)
            
        }
        
        _ = Coordinate.addCoordinateToTrip(track_id: self.trackID, latitude: Double(coordinate.latitude), longitude: Double(coordinate.longitude), context: managedObjectContext!)
        
        mapView.showAnnotations(annotations, animated: true)
        
        let center = CLLocationCoordinate2D(latitude: (coordinate.latitude + (locationManager.location?.coordinate.latitude)!) * 0.5, longitude: (coordinate.longitude + (locationManager.location?.coordinate.longitude)!) * 0.5)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: coordinate.latitude - locationManager.location!.coordinate.latitude + 0.0005, longitudeDelta: coordinate.longitude - locationManager.location!.coordinate.longitude + 0.0005))
        self.mapView.setRegion(region, animated: true)
        
        if lastLeaderLocation != nil {
            var a = [coordinate, lastLeaderLocation!]
            let polyline = MKPolyline(coordinates: &a, count: a.count)
            mapView.add(polyline)
        }
        lastLeaderLocation = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
    }
    
    // MARK - Trip Ended Delegate
    
    func didDismissWithCommand(sender: TripEndedViewController, command: TripEndedCommand) {
        
        if command == .Abort {
            _ = Trip.removeTrip(track_id: trackID, context: managedObjectContext!)
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        else {
            let alertController = UIAlertController(title: "Name", message: "Name of the trip", preferredStyle: .alert)
            let saveAction = UIAlertAction(title:"Save", style: .destructive, handler: { (action) -> Void in
                let textField = alertController.textFields![0] as UITextField
                _ = Trip.updateTrip(name: textField.text!, track_id: self.trackID, context: self.managedObjectContext!)
                _ = self.navigationController?.popToRootViewController(animated: true)
            })
            saveAction.isEnabled = false
            alertController.addAction(saveAction)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
                textField.placeholder = "Name"
                NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
                    saveAction.isEnabled = textField.text!.length > 0
                }
            })
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showTripEnded" {
            let nextScene =  segue.destination as! TripEndedViewController
            nextScene.delegate = self
        }
    }
    
    func disableFollowLocation() {
        followMyPin = false
    }
    
    func positionButtonPressed() {
        followMyPin = true
        let center = CLLocationCoordinate2D(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        mapView.setRegion(region, animated: true)
    }
    
    private func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view = self.mapView.subviews[0]
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if( recognizer.state == UIGestureRecognizerState.began || recognizer.state == UIGestureRecognizerState.ended ) {
                    return true
                }
            }
        }
        return false
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        mapChangedFromUserInteraction = mapViewRegionDidChangeFromUserInteraction()
        if mapChangedFromUserInteraction {
            followMyPin = false
        }
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if (mapChangedFromUserInteraction) {
            followMyPin = false
        }
    }

}
