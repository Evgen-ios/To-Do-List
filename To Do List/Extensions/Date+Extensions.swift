//
//  Date+Extensions.swift
//  To Do List
//
//  Created by Evgeniy Goncharov on 01.10.2021.
//

import Foundation

// Make awesome Date String 
extension Date {
    var formattedDate: String {
        let formatted = DateFormatter()
        formatted.locale = .current
        formatted.dateStyle = .short
        formatted.timeStyle = .none
        formatted.dateFormat = "MMMM dd yyyy"
        return formatted.string(from: self)
    }
}
