//
//  TripDetailViewController.swift
//  FollowTrack
//
//  Created by Luca Soldi on 13/02/18.
//  Copyright © 2018 Luca Soldi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TripDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var trip : Trip!
    var tripLocations: [CLLocationCoordinate2D] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTrackToMap()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTrackToMap() {
        nameLabel.text = trip.name
        
        var maxLat : Double = -200;
        var maxLong : Double = -200;
        var minLat : Double = 200;
        var minLong : Double = 200;
        
        for case let coordinate as Coordinate in trip.coordinates! {
            let loc = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            tripLocations.append(loc)
            if (loc.latitude < minLat) {
                minLat = loc.latitude;
            }
            
            if (loc.longitude < minLong) {
                minLong = loc.longitude;
            }
            
            if (loc.latitude > maxLat) {
                maxLat = loc.latitude;
            }
            
            if (loc.longitude > maxLong) { //Change to be greater than
                maxLong = loc.longitude;
            }
            
        }
        
        let polyline = MKPolyline(coordinates: &tripLocations, count: tripLocations.count)
        mapView.add(polyline)
        
        let center = CLLocationCoordinate2D(latitude: (maxLat + minLat) * 0.5, longitude: (maxLong + minLong) * 0.5)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: maxLat - minLat + 0.0005, longitudeDelta: maxLong - minLong + 0.0005))
        self.mapView.setRegion(region, animated: true)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
