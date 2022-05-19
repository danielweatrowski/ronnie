//
//  TotalsGenerator.swift
//  
//
//  Created by Daniel Weatrowski on 5/15/22.
//

import Foundation
import TabularData

class MonthlyTotalsManager: CSVFileManager {
    var rootPath: String
    
    var filename: String
    
    var pathToFile: String
    
    var dataframe: DataFrame
    
    var transactionsDataframe: DataFrame?
    
    internal var settings: Settings?
    
    internal var totalEarnings: Double = 0
    
    /// Use this initializer when generating new totals
    init(path: String, transactions: DataFrame, settings: Settings) {
        self.transactionsDataframe = transactions
        self.settings = settings
        
        self.rootPath = path
        self.filename = "totals.csv"
        self.pathToFile = rootPath + filename
        
        self.dataframe = DataFrame()
        self.dataframe = createEmptyDataframe()
        
        // Create the /categories directory if it does not exist. The category files will be saved here.
        createDirectoryIfNeeded(path: rootPath, directoryName: "categories")
    }
    
    /// Use this initializer when loading prexisting totals
    init(path: String, filename: String) {
        self.pathToFile = path
        self.filename = filename
        self.dataframe = DataFrame()
        
        // unused
        self.rootPath = ""
    }
    
    enum Columns: CaseIterable {
        case category
        case amount
        
        var name: String {
            switch self {
            case .category: return "category"
            case .amount: return "amount"
            }
        }
        
        var index: Int {
            switch self {
            case .category: return 0
            case .amount: return 1
            }
        }
        
        var type: CSVType {
            switch self {
            case .amount: return .double
            default: return .string
            }
        }
    }
}

