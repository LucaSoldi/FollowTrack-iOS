//
//  Coordinate+CoreDataProperties.swift
//  FollowTrack
//
//  Created by Luca Soldi on 13/02/17.
//  Copyright © 2017 Luca Soldi. All rights reserved.
//

import Foundation
import CoreData


extension Coordinate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Coordinate> {
        return NSFetchRequest<Coordinate>(entityName: "Coordinate");
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var trip: Trip?

}
