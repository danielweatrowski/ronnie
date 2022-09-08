//
//  StatementLoader.swift
//  
//
//  Created by Daniel Weatrowski on 5/4/22.
//

import Foundation
import TabularData
import CloudKit

/// Methods and variables for loading csv files into the program using the `TabularData` framework.
protocol CSVLoader {
    /// Name of the statement loader
    var name: String { get }
    
    /// CSV reading options for reading the statement csv file
    var options: CSVReadingOptions { get }
    
    /// Computed value of all the column csv types in the statement, calculated from the `Columns` enum.
    var allColumnTypes: [String : CSVType] { get }
    
    /// All column names in the csv statement, calculated from the `Columns` enum
    var allColumnNames: [String] { get }
    
    /// Method to load the statement csv into the program as a dataframe. This method will mostly be the same between different loaders,
    /// as it uses the month, year, and path parameters to simply load the csv into a datafram object.
    ///
    /// - Note: The statement filename must be updated accordingly for each loader.
    func loadDataframe()
    
    func loadDataframe(at url: URL) -> DataFrame
    
    /// Method to format the loaded statement dataframe into the required output dataframe format. This method will often be unique between loaders,
    /// as the format of each statement csv file will differ greatly.  The formatted dataframe, however, needs to be the same between all loaders in order
    /// to combine into a single dataframe.
    func formatDataframe()
    
    /// Method used to retrieve the loaded dataframe from the loader.
    func getDataframe() -> DataFrame
    
    /// Required initializer
    init(directoryURL: URL, filename: String)
    
}

extension CSVLoader {
    var name: String {
        return String(describing: self)
    }
    
    func loadDataframe(at url: URL) -> DataFrame {
        var dataframe = DataFrame()
        do {
            dataframe = try DataFrame(contentsOfCSVFile: url, columns: allColumnNames, types: allColumnTypes, options: options)
            
            print("Successfully loaded \(name) statement.")
            print("File loaded from \(url.path)")
            
        } catch (let error as CSVReadingError) {
            print("Failed to load \(name) statement into DataFrame")
            print(error.localizedDescription)
        } catch {
            print("Failed due to unknown error.")
        }
        
        return dataframe
    }
    
    func formatDataframe() {}
}
