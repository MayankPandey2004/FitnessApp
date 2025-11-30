//
//  Date+Ext.swift
//  FitnessApp
//
//  Created by Mayank Pandey on 30/11/25.
//

import Foundation

extension Date {
    static var startOfDay: Date {
        let  calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        return startOfDay
    }
    
    static var startOfWeek: Date {
        let  calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        components.weekday = 2
        return calendar.date(from: components) ?? Date()
    }
    
    func startAndEndOfMonth(using calendar: Calendar = Calendar.current) -> (start: Date, end: Date) {
        let comps = calendar.dateComponents([.year, .month], from: self)
        let start = calendar.date(from: comps)!
        var endComps = DateComponents()
        endComps.month = 1
        endComps.second = -1
        let end = calendar.date(byAdding: endComps, to: start)!
        return (start, end)
    }

    static func startAndEndOfMonth(offsetFromNow offset: Int, using calendar: Calendar = Calendar.current) -> (start: Date, end: Date) {
        let base = calendar.date(byAdding: .month, value: offset, to: Date()) ?? Date()
        return base.startAndEndOfMonth(using: calendar)
    }
    
    func fetchPreviousMonday() -> Date {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        let dayToSubtract = (weekday + 5) % 7
        var dateComponents = DateComponents()
        dateComponents.day = -dayToSubtract
        
        return calendar.date(byAdding: dateComponents, to: self) ?? Date()
    }
    
    func mondayDateFormat() -> String {
        let monday = self.fetchPreviousMonday()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.string(from: monday)
    }
}

