//
//  File.swift
//  
//
//  Created by Daniel Weatrowski on 5/19/22.
//

import Foundation
import TabularData

final class Viewer {
    let fileURL: URL
    
    var dataframe: DataFrame?
    
    var readingOptions: CSVReadingOptions = CSVReadingOptions()
    
    init(fileURL: URL) {
        self.fileURL = fileURL
    }
    
    private func loadDataframe() {

        do {
            let dataframe = try DataFrame(contentsOfCSVFile: fileURL, options: readingOptions)
            print("File loaded from \(fileURL.path)\n")
            self.dataframe = dataframe
        } catch (let error as CSVReadingError) {
            print("Failed to load csv file at \(fileURL.path)")
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
