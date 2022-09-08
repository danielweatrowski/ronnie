//
//  File.swift
//  
//
//  Created by Daniel Weatrowski on 5/15/22.
//

import Foundation
import TabularData

protocol CSVGenerator {
    
    /// Method to generate the csv once all computational logic has been completed. This function should be called when the dataframe file is ready to be written to a csv.
    func generate()
    
    /// If the generated CSV file requires a specific format of columns, use this method to create a dataframe with the correct column layout. Use the empty dataframe to append other dataframes
    /// with the expected format.
    func createEmptyDataframe() -> DataFrame
    
    /// Generic save method to write dataframe to csv
    /// - Parameters:
    ///     - dataframe: Dataframe to be written
    ///     - url: URL of the directory to save the dataframe
    func save(_ dataframe: DataFrame, to url: URL)
}

extension CSVGenerator {
    func save(_ dataframe: DataFrame, to url: URL) {
        do {
            try dataframe.writeCSV(to: url)
            print("Successfully saved csv file.")
            print("File written to \(url.path)")
        } catch {
            print(error.localizedDescription)
        }
    }
}
