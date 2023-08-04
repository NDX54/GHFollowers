//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Jared Juangco on 17/7/22.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
//    func convertToMonthYearFormat() -> String {
//        return formatted(.dateTime.month().year())
//    }
}
