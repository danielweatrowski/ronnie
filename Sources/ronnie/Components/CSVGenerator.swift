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
    
    /// Method to generate the csv once all computational logic has been completed. This function should be called when the dataframe file is ready to be written to a csv.
    func generate()
    
    /// Create a dataframe with the correct column layout with no data. Use this empty dataframe to append other dataframes to
    /// with the expected format.
    func createEmptyDataframe() -> DataFrame
    
    /// Generic save method to write dataframe to csv at some path
    func save(_ dataframe: DataFrame, to path: String)
    
    /// Generic method to create new directory if it does not already exist
    func createDirectoryIfNeeded(path: String, directoryName: String)
}

extension CSVGenerator {
    func save(_ dataframe: DataFrame, to path: String) {
        let fileURL = URL(fileURLWithPath: path)
        do {
            try dataframe.writeCSV(to: fileURL)
            print("Successfully saved csv file.")
            print("File written to \(fileURL.path)")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createDirectoryIfNeeded(path: String, directoryName: String) {
        let directoryURL = URL(fileURLWithPath: path).appendingPathComponent(directoryName)
        if !FileManager.default.fileExists(atPath: directoryURL.path) {
            do {
                try FileManager.default.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: true, attributes: nil)
                print("Successfully created \(directoryName) directory")
                print("Directory is located at \(directoryURL.path)")
            } catch {
                print("Error: Failed to created categories directory")
                print(error.localizedDescription)
            }
        }
    }
}
