//
//  File.swift
//  
//
//  Created by Daniel Weatrowski on 5/24/22.
//

import Foundation
import TabularData
@testable import ronnie

extension FruitManager: CSVLoader {
    
    var options: CSVReadingOptions {
        return CSVReadingOptions()
    }
    
    var allColumnTypes: [String : CSVType] {
       return Columns.allCases.reduce(into: [String: CSVType]()) {
           $0[$1.name] = $1.type
       }
    }
    
    var allColumnNames: [String] {
        return Columns.allCases.map({ $0.name })
    }
    
    func loadDataframe() {
        dataframe = loadDataframe(at: fileURL)
    }
    
    func getDataframe() -> DataFrame {
        return dataframe
    }
}
