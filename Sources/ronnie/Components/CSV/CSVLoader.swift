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
    
    /// CSV reading options for reading the statement csv file
    var options: CSVReadingOptions { get }
    
    /// Computed value of all the column csv types in the statement, calculated from the `Columns` enum.
    var allColumnTypes: [String : CSVType] { get }
    
    /// All column names in the csv statement, calculated from the `Columns` enum
    var allColumnNames: [String] { get }
    
    /// Add any required reading options to the loader. This will most likely need to be implemented for reading bank statement csv files, as each statemen formatt is often
    /// unique to it's bank.
    func addReadingOptions()
    
    /// Method to load the statement csv into the program as a dataframe. This method will mostly be the same between different loaders,
    /// as it uses the month, year, and path parameters to simply load the csv into a datafram object.
    ///
    /// - Note: The statement filename must be updated accordingly for each loader.
    func loadDataframe()
    
    func loadDataframe(at path: String) -> DataFrame
    
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
    
    func loadDataframe(at pathToFile: String) -> DataFrame {
        var dataframe = DataFrame()
        do {
            let fileURL = URL(fileURLWithPath: pathToFile)
            dataframe = try DataFrame(contentsOfCSVFile: fileURL, columns: allColumnNames, types: allColumnTypes, options: options)
            
            print("Successfully loaded \(name) statement.")
            print("File loaded from \(fileURL.path)")
            
        } catch (let error as CSVReadingError) {
            print("Failed to load \(name) statement into DataFrame")
            print(error.localizedDescription)
        } catch {
            print("Failed due to unknown error.")
        }
        
        return dataframe
    }
    
    func formatDataframe() {}
    func addReadingOptions() {}
}
