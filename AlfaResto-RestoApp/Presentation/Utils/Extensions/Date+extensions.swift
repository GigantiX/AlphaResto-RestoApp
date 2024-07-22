//
//  Date+extension.swift
//  AlfaResto-RestoApp
//
//  Created by Axel Ganendra on 27/06/24.
//

import Foundation

enum FormatType: String {
    case complete = "dd MMMM yyyy, HH:mm"
    case monthAndYear = "MMMM, yyyy"
    case hourAndMinute = "HH:mm"
}

extension Date {
    
    func dateToString(to format: FormatType) -> String {
        let df = DateFormatter()
        df.dateStyle = .full
        df.dateFormat = format.rawValue
        
        return df.string(from: self)
    }
    
    func getTimeOnly() -> String {
        let df = DateFormatter()
        df.dateStyle = .full
        df.dateFormat = FormatType.hourAndMinute.rawValue
        
        return df.string(from: self)
    }

    // MARK: - For Test Notif
    func getFullTimeDateComponent(from calendar: Calendar = Calendar.current) -> DateComponents {
        var dateComponent = DateComponents(calendar: calendar)
        dateComponent.hour = calendar.component(.hour, from: self)
        dateComponent.minute = calendar.component(.minute, from: self)
        dateComponent.second = calendar.component(.second, from: self) + 10
        
        return dateComponent
    }
    
    func getDateComponent(_ component: [Calendar.Component], calendar: Calendar = Calendar.current) -> DateComponents {
        calendar.dateComponents(Set(component), from: self)
    }
    
}
