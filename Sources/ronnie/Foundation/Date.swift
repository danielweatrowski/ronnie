//
//  File.swift
//  
//
//  Created by Daniel Weatrowski on 5/2/22.
//

import Foundation

extension Date {
    func getFormattedDate(format: String) -> String {
         let dateformat = DateFormatter()
         dateformat.dateFormat = format
         return dateformat.string(from: self)
     }
    
    static func formatArgument(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMM"
        
        if let reportDate = dateFormatter.date(from: dateString) {
            let formattedDate = reportDate.getFormattedDate(format: "MMMM yyy")
            return formattedDate
        } else {
            return "nil"
        }
    }
}
