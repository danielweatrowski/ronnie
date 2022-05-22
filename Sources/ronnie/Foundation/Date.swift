//
//  Date.swift
//  
//
//  Created by Daniel Weatrowski on 5/2/22.
//

import Foundation

extension Date {
    static func getCurrentYear() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: date)
        return yearString
    }
    
    static func getMonths() -> [String] {
        return ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    }
}
