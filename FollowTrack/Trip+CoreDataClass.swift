//
//  Trip+CoreDataClass.swift
//  FollowTrack
//
//  Created by Luca Soldi on 13/02/17.
//  Copyright © 2017 Luca Soldi. All rights reserved.
//

import Foundation
import CoreData


public class Trip: NSManagedObject {
    
    class func getTripWithID(context: NSManagedObjectContext, track_id: String) -> Trip? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Trip")
        request.predicate = NSPredicate(format: "track_id = %@", track_id)
        if let trip = (try? context.fetch(request))?.first as? Trip {
            return trip
        }
        return nil
    }
    
    class func getAllTrips(context: NSManagedObjectContext) -> Array<Trip> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Trip")
        //request.predicate = NSPredicate(format: "track_id = %@", track_id)
        if let trips = (try? context.fetch(request)) as? [Trip] {
            return trips
        }
        return []
    }

    
    class func createTrip(name: String, track_id: String, context: NSManagedObjectContext) -> Trip? {
        
        if let trip = NSEntityDescription.insertNewObject(forEntityName: "Trip", into: context) as? Trip {
            trip.name = name
            trip.track_id = track_id
            saveCoreDataContext(context: context)
        }
        return nil
        
    }
    
    class func updateTrip(name: String, track_id: String, context: NSManagedObjectContext) -> Trip? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Trip")
        request.predicate = NSPredicate(format: "track_id = %@", track_id)
        if let trip = (try? context.fetch(request))?.first as? Trip {
            trip.name = name
            saveCoreDataContext(context: context)
            return trip
        }
        return nil
    }
    
    class func removeTrip(track_id: String, context: NSManagedObjectContext) -> Bool {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Trip")
        request.predicate = NSPredicate(format: "track_id = %@", track_id)
        if let trip = (try? context.fetch(request))?.first as? Trip {
            context.delete(trip)
            saveCoreDataContext(context: context)
            return true
        }
        return false
    }
   
    class func saveCoreDataContext(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch let error {
            print("Core Data Error: \(error)")
        }
    }
    
    

}
