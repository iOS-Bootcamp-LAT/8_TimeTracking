//
//  Task+CoreDataProperties.swift
//  8_TimeTracking
//
//  Created by David Granado Jordan on 6/30/22.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: Int16
    @NSManaged public var title: String
    @NSManaged public var taskDescription: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var createdAt: Date
    @NSManaged public var color: String?
    @NSManaged public var timePunches: NSSet?
    
    public var timePunchesArray: [TimePunch] {
        
        let set = timePunches as? Set<TimePunch> ?? []
        
        return set.sorted {
            $0.createdAt < $1.createdAt
        }
    }

}

// MARK: Generated accessors for timePunches
extension Task {

    @objc(addTimePunchesObject:)
    @NSManaged public func addToTimePunches(_ value: TimePunch)

    @objc(removeTimePunchesObject:)
    @NSManaged public func removeFromTimePunches(_ value: TimePunch)

    @objc(addTimePunches:)
    @NSManaged public func addToTimePunches(_ values: NSSet)

    @objc(removeTimePunches:)
    @NSManaged public func removeFromTimePunches(_ values: NSSet)

}

extension Task : Identifiable {

}
