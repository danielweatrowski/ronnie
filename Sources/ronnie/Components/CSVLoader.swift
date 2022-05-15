//
//  StatementLoader.swift
//  
//
//  Created by Daniel Weatrowski on 5/4/22.
//

import Foundation
import TabularData

/// Loader protocol for loading various bank statements (in CSV format) into the program using the `TabularData` framework.
protocol CSVLoader {
    /// Name of the statement loader
    var name: String { get }
    
    /// Required Columns enum variable for reading columns out of the `statement.csv` file
    associatedtype Columns: CaseIterable
    
    /// Root path of the statement to be loaded. This value is passed as an argument along with the `generate` command.
    var rootPath: String { get }
    
    /// Filename of the statement to be loaded. Must be consistent across all statement types
    var statementFilename: String { get }
    
    /// Path to the statement to be loaded. Computed value using the `rootPath` and `statementFilename` variables.
    var pathToStatement: String { get }
    
    /// The dataframe object representing the loaded statement.csv file
    var dataframe: DataFrame? { get set }
    
    /// CSV reading options for reading the statement csv file
    var options: CSVReadingOptions { get }
    
    /// Computed value of all the column csv types in the statement, calculated from the `Columns` enum.
    var allColumnTypes: [String : CSVType] { get set }
    
    /// All column names in the csv statement, calculated from the `Columns` enum
    var allColumnNames: [String] { get set }
    
    /// Add any required reading options to the loader
    func addReadingOptions()
    
    /// Method to load the statement csv into the program as a dataframe. This method will mostly be the same between different loaders,
    /// as it uses the month, year, and path parameters to simply load the csv into a datafram object.
    ///
    /// - Note: The statement filename must be updated accordingly for each loader.
    func loadDataframe()
    
    /// Method to format the loaded statement dataframe into the required output dataframe format. This method will often be unique between loaders,
    /// as the format of each statement csv file will differ greatly.  The formatted dataframe, however, needs to be the same between all loaders in order
    /// to combine into a single dataframe.
    func formatDataframe()
    
    /// Method used to retrieve the loaded dataframe from the loader.
    func getDataframe() -> DataFrame
}

extension CSVLoader {
    var name: String {
        return String(describing: self)
    }
}
