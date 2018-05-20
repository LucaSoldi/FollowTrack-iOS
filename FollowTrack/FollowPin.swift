/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import MapKit
import Contacts

class FollowPin: NSObject, MKAnnotation {
    
    let title: String?
    let locationName: String
    let type: Int
    dynamic var coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, type: Int, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.type = type
        self.coordinate = coordinate
        
        super.init()
    }
    
    /*class func fromJSON(_ json: [JSONValue]) -> FarmerPin? {
     // 1
     var title: String
     if let titleOrNil = json[16].string {
     title = titleOrNil
     } else {
     title = ""
     }
     let locationName = json[12].string
     let discipline = json[15].string
     
     // 2
     let latitude = (json[18].string! as NSString).doubleValue
     let longitude = (json[19].string! as NSString).doubleValue
     let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
     
     // 3
     return Artwork(title: title, locationName: locationName!, discipline: discipline!, coordinate: coordinate)
     }*/
    
    var subtitle: String? {
        return locationName
    }
    
    // MARK: - MapKit related methods
    
    
    func imageType() -> UIImage {
        
        var pinImage = UIImage()
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContext(size)
        
        switch type {
        case 0:
            pinImage = #imageLiteral(resourceName: "king-location")
        default:
            pinImage = #imageLiteral(resourceName: "king-location")
        }
        
        pinImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
        
        
    }
    
    // annotation callout opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        //let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
    
}
