//
//  Trip+CoreDataProperties.swift
//  FollowTrack
//
//  Created by Luca Soldi on 13/02/17.
//  Copyright © 2017 Luca Soldi. All rights reserved.
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip");
    }

    @NSManaged public var name: String?
    @NSManaged public var track_id: String?
    @NSManaged public var coordinates: NSOrderedSet?

}

// MARK: Generated accessors for coordinates
extension Trip {

    @objc(insertObject:inCoordinatesAtIndex:)
    @NSManaged public func insertIntoCoordinates(_ value: Coordinate, at idx: Int)

    @objc(removeObjectFromCoordinatesAtIndex:)
    @NSManaged public func removeFromCoordinates(at idx: Int)

    @objc(insertCoordinates:atIndexes:)
    @NSManaged public func insertIntoCoordinates(_ values: [Coordinate], at indexes: NSIndexSet)

    @objc(removeCoordinatesAtIndexes:)
    @NSManaged public func removeFromCoordinates(at indexes: NSIndexSet)

    @objc(replaceObjectInCoordinatesAtIndex:withObject:)
    @NSManaged public func replaceCoordinates(at idx: Int, with value: Coordinate)

    @objc(replaceCoordinatesAtIndexes:withCoordinates:)
    @NSManaged public func replaceCoordinates(at indexes: NSIndexSet, with values: [Coordinate])

    @objc(addCoordinatesObject:)
    @NSManaged public func addToCoordinates(_ value: Coordinate)

    @objc(removeCoordinatesObject:)
    @NSManaged public func removeFromCoordinates(_ value: Coordinate)

    @objc(addCoordinates:)
    @NSManaged public func addToCoordinates(_ values: NSOrderedSet)

    @objc(removeCoordinates:)
    @NSManaged public func removeFromCoordinates(_ values: NSOrderedSet)

}
