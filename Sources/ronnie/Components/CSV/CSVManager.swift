//
//  CSVManager.swift
//  
//
//  Created by Daniel Weatrowski on 5/19/22.
//

import Foundation
import TabularData

/// Required variables for managing a CSV file
protocol CSVFileManager {
    /**
     Enum representation of the columns in the csv.

        Must be declared with name, index, and type of each column header.
        For the totals.csv loader, `Columns` is equivalent to:

            enum Columns: CaseIterable {
                 // headers of CSV
                 case category
                 case amount
                 
                 // name of each column (header name of csv file)
                 var name: String {
                     switch self {
                     case .category: return "category"
                     case .amount: return "amount"
                     }
                 }
                 
                 // index of each column
                 var index: Int {
                     switch self {
                     case .category: return 0
                     case .amount: return 1
                     }
                 }
                 
                 // value type of each column
                 var type: CSVType {
                     switch self {
                     case .amount: return .double
                     default: return .string
                     }
                 }
            }

    */
    associatedtype Columns: CaseIterable
    
    /// URL of the directory that holds the CSV file
    var directoryURL: URL { get }
    
    /// Filename of the csv to be generated.
    var filename: String { get }
    
    /// URL of the CSV file. Computed using the `directoryURL` and `filename` variables
    var fileURL: URL { get }
    
    /// The dataframe object to be saved as a csv file.
    var dataframe: DataFrame { get set }
}

extension CSVFileManager {
    var fileURL: URL {
        return directoryURL.appendingPathComponent(filename)
    }
}
