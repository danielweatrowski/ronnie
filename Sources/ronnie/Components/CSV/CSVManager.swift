//
//  CSVManager.swift
//  
//
//  Created by Daniel Weatrowski on 5/19/22.
//

import Foundation
import TabularData

protocol CSVFileManager {
    /// Required Columns enum variable for creating columns of the exported transactions file
    associatedtype Columns: CaseIterable
    
    /// Root path of the csv to be generated. This value is passed as an argument along with the `ronnie` command.
    var rootPath: String { get }
    
    /// Filename of the csv to be generated.
    var filename: String { get }
    
    /// Path to the csv to be written to. Computed value using the `rootPath` and `statementFilename` variables.
    var pathToFile: String { get }
    
    /// The dataframe object to be saved as a csv file.
    var dataframe: DataFrame { get set }
}

extension CSVFileManager {
    var pathToFile: String {
        return rootPath + filename
    }
}
