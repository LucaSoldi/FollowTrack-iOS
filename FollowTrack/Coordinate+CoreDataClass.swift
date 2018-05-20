//
//  Coordinate+CoreDataClass.swift
//  FollowTrack
//
//  Created by Luca Soldi on 13/02/17.
//  Copyright © 2017 Luca Soldi. All rights reserved.
//

import Foundation
import CoreData


public class Coordinate: NSManagedObject {

    
    class func addCoordinateToTrip(track_id: String, latitude: Double, longitude: Double, context: NSManagedObjectContext) -> Trip? {
        
        if let coordinate = NSEntityDescription.insertNewObject(forEntityName: "Coordinate", into: context) as? Coordinate {
            
            coordinate.latitude = latitude
            coordinate.longitude = longitude
            coordinate.trip = Trip.getTripWithID(context: context, track_id: track_id)
            
            saveCoreDataContext(context: context)
        }
        return nil
        
    }
    
    
    class func saveCoreDataContext(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch let error {
            print("Core Data Error: \(error)")
        }
    }
}
