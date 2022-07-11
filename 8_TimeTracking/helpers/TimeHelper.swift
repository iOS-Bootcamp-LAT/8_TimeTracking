//
//  TimeHelper.swift
//  8_TimeTracking
//
//  Created by David Granado Jordan on 7/6/22.
//

import Foundation


class TimeHelper {
    
    static let shared = TimeHelper()
    
    
    static func convertSecondsToHoursFormat( seconds: Int ) -> String {
        var residue = seconds
        
        let hours = Int( residue / 3600 )
        
        if hours > 0 {
            residue -= hours * 3600
        }
        
        let minutes = Int(residue / 60)
        if minutes > 0 {
            residue -= minutes * 60
        }
        
        let hoursText = hours < 10 ? "0\(hours)" : "\(hours)"
        let minutesText = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let secondsText = residue < 10 ? "0\(residue)" : "\(residue)"
        
        
        return "\(hoursText):\(minutesText):\(secondsText)"
    }
    
    
}
