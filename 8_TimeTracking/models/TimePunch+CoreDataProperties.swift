//
//  TimePunch+CoreDataProperties.swift
//  8_TimeTracking
//
//  Created by David Granado Jordan on 6/30/22.
//
//

import Foundation
import CoreData


extension TimePunch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimePunch> {
        return NSFetchRequest<TimePunch>(entityName: "TimePunch")
    }

    @NSManaged public var id: Int16
    @NSManaged public var start: Date?
    @NSManaged public var end: Date?
    @NSManaged public var elapsedTime: Int64
    @NSManaged public var task: Task?
    @NSManaged public var createdAt: Date

}

extension TimePunch : Identifiable {

}
