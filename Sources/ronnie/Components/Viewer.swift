//
//  File.swift
//  
//
//  Created by Daniel Weatrowski on 5/19/22.
//

import Foundation
import TabularData

final class Viewer {
    let pathToFile: String
    
    var dataframe: DataFrame?
    
    var readingOptions: CSVReadingOptions = CSVReadingOptions()
    
    init(path: String) {
        self.pathToFile = path
    }
    
    private func loadDataframe() {
        let statementURL = URL(fileURLWithPath: pathToFile)

        do {
            let dataframe = try DataFrame(contentsOfCSVFile: statementURL, options: readingOptions)
            
            print("File loaded from \(statementURL.path)\n")
            
            self.dataframe = dataframe
        } catch (let error as CSVReadingError) {
            print("Failed to load csv file at \(statementURL.path)")
            print(error.description)
        } catch {
            print("Failed due to unknown error.")
        }
    }
    
    public func view() {
        loadDataframe()
        if let dataframe = dataframe {
            print(dataframe)
        }
    }
}
