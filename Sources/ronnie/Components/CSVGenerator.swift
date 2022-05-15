//
//  File.swift
//  
//
//  Created by Daniel Weatrowski on 5/15/22.
//

import Foundation
import TabularData

protocol CSVGenerator {
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
    
    /// Write the dataframe object to a csv file using the `pathToFile` property.
    func saveDataframe()
    
    /// Create a dataframe with the correct column layout with no data. Use this empty dataframe to append other dataframes to
    /// with the expected format.
    func createEmptyDataframe() -> DataFrame
    
}
