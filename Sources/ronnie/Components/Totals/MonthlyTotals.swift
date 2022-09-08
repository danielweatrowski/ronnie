//
//  TotalsGenerator.swift
//  
//
//  Created by Daniel Weatrowski on 5/15/22.
//

import Foundation
import TabularData

class MonthlyTotalsManager: CSVFileManager {
    var directoryURL: URL
    
    var filename: String
        
    var dataframe: DataFrame
    
    var transactionsDataframe: DataFrame?
    
    internal var settings: Settings?
    
    internal var totalEarnings: Double = 0
    
    /// Use this initializer when generating new totals
    init(directoryURL: URL, transactions: DataFrame, settings: Settings) {
        self.transactionsDataframe = transactions
        self.settings = settings
        
        self.directoryURL = directoryURL
        self.filename = FileName.totals.rawValue
        
        self.dataframe = DataFrame()
        self.dataframe = createEmptyDataframe()
        
        // Create the /categories directory if it does not exist. The category files will be saved here.
        FileManager.default.createDirectoryIfNeeded(at: directoryURL, directoryName: "categories")
    }
    
    /// Use this initializer when loading prexisting totals
    required init(directoryURL: URL, filename: String) {
        self.filename = filename
        self.dataframe = DataFrame()
        self.directoryURL = directoryURL
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

