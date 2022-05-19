//
//  MonthlyTransactions+Loader.swift
//  
//
//  Created by Daniel Weatrowski on 5/19/22.
//

import Foundation
import TabularData

extension MonthlyTransactionsManager: CSVLoader {
    
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
        addReadingOptions()
        self.dataframe = loadDataframe(at: pathToFile)
    }
    
    func getDataframe() -> DataFrame {
        return dataframe
    }
}
