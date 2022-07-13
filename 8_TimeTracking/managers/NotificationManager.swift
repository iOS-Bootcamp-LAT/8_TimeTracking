//
//  NotificationManager.swift
//  8_TimeTracking
//
//  Created by David Granado Jordan on 7/12/22.
//

import Foundation
import UserNotifications
import CoreData

enum NotificationManagerCategoryIndentifier: String {
    case startTimePunchCategory
    case endTimePunchCategory
    case userUpdateCategory
    case otherCategory
}

enum TaskActionNotification: String {
    case dissmiss, startTimePunch, endTimePunch
}


class NotificationManager {
    
    static let shared = NotificationManager()
    let context = CoreDataManager.shared.getContext()
    
    
    
    public func handleNotification(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.notification.request.content.categoryIdentifier {
            
            
        case NotificationManagerCategoryIndentifier.startTimePunchCategory.rawValue:
            print("startTimePunchCategory")
            
        case NotificationManagerCategoryIndentifier.endTimePunchCategory.rawValue:
            print("endTimePunchCategory")
            
            handleEndTimePunchNotification(response: response)
            
        case NotificationManagerCategoryIndentifier.userUpdateCategory.rawValue:
            print("userUpdateCategory")
        
        case NotificationManagerCategoryIndentifier.otherCategory.rawValue:
            print("otherCategory")
            
        default:
            print("No actions")
        }
        
        completionHandler()
    }
    
    
    func handleEndTimePunchNotification(response: UNNotificationResponse) {
        let userInfo = response.notification.request.content.userInfo
        
        if let taskID = userInfo["taskID"] as? Int16 {
            
            let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
            fetchRequest.predicate = NSPredicate.init(format: "id == %@", argumentArray: [ taskID ])
            fetchRequest.fetchLimit = 1
            
            
            do {
                guard let task = try context.fetch(fetchRequest).first else { return }
                
                switch response.actionIdentifier {
                    
                case TaskActionNotification.endTimePunch.rawValue:
                    print("")
                    
                    if let lastTimePunch = task.timePunchesArray.first(where: { $0.end == nil } ) {
                        lastTimePunch.end = Date()
                        lastTimePunch.elapsedTime = Int64(  (lastTimePunch.end ?? Date())  - (lastTimePunch.start ?? Date())  )
                    }
                    
                    NotificationCenter.default.post(name: Notification.Name("TimePunchUpdated"), object: nil)
                    
                default:
                    print("")
                }

            } catch {
               print("Error")
                
            }
            
            
            
        }
        
    }
    
    func getNotificationBodyForTimePunchNotification(  task: Task, action: TaskActionNotification, timeInterval: TimeInterval = 28800  ) -> String {
        
        switch action {
        case .dissmiss:
            return ""
        case .startTimePunch:
            return "Would you like to start a time punch into Task: \(task.title)"
        case .endTimePunch:
            return "Would you like to end a time punch into Task: \(task.title)"
        }
    }
    
    
    func removeScheduleTimePunchNotification(task: Task) {
        let center = UNUserNotificationCenter.current()
        
        center.removeDeliveredNotifications(withIdentifiers: [ "\(task.id)" ] )
        center.removePendingNotificationRequests(withIdentifiers: [ "\(task.id)" ])
    }
    
    
    func scheduleTimePunchNotificationForTask( task: Task, action: TaskActionNotification, category: NotificationManagerCategoryIndentifier, timeInterval: TimeInterval = 28800) {
        
        
        
        let content = UNMutableNotificationContent()
        content.title = "Task: \(task.title)"
        content.body = getNotificationBodyForTimePunchNotification(task: task, action: action)
        
        content.userInfo = [ "taskID": task.id ]
        content.categoryIdentifier = category.rawValue
        content.threadIdentifier = category.rawValue
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        
        let identifier = "\(task.id)"
        
        let notificationRequest = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger)
        
        
        UNUserNotificationCenter.current().add(notificationRequest) { error in
            if let error = error {
                print("Error:", error)
            }
        }
        
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void  ) {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            completion(granted)
        }
    }
    
    
    
    
    func configureUserNotifications() {
        
        let dissmissAction = UNNotificationAction(
            identifier: TaskActionNotification.dissmiss.rawValue,
            title: "Dissmiss",
            options: []
        )
        
        
        // START CATEGORY
        let startTimePunchAction = UNNotificationAction(
            identifier: TaskActionNotification.startTimePunch.rawValue,
            title: "Start",
            options: []
        )
        
        let startTimepunchCategory =   UNNotificationCategory(
            identifier: NotificationManagerCategoryIndentifier.startTimePunchCategory.rawValue,
            actions: [startTimePunchAction, dissmissAction],
            intentIdentifiers: [],
            options: []
        )
        
        
        
        // END CATEGORY
        
        let endTimePunchAction = UNNotificationAction(
            identifier: TaskActionNotification.endTimePunch.rawValue,
            title: "End",
            options: []
        )
        
        let endTimepunchCategory =   UNNotificationCategory(
            identifier: NotificationManagerCategoryIndentifier.endTimePunchCategory.rawValue,
            actions: [endTimePunchAction, dissmissAction],
            intentIdentifiers: [],
            options: []
        )
        
        
        
        UNUserNotificationCenter.current().setNotificationCategories([startTimepunchCategory, endTimepunchCategory])
        
    }
    
}
