//
//  MonthlyTransactions.swift
//  
//
//  Created by Daniel Weatrowski on 5/15/22.
//

import Foundation
import TabularData

class MonthlyTransactionsManager: CSVFileManager {
    var rootPath: String
    
    var filename: String
    
    var pathToFile: String
    
    var dataframe: DataFrame
    
    // Generator Init
    init(path: String) {
        self.rootPath = path
        self.filename = "transactions_GENERATED.csv"
        self.pathToFile = rootPath + filename
        
        self.dataframe = DataFrame()
        self.dataframe = createEmptyDataframe()
    }
    
    // Load Init
    init(year: String, month: String, path: String, verbose: Bool) {
        let activeDirectoryPath = "\(path)/\(year)/\(month)/"
        self.rootPath = activeDirectoryPath
        self.filename = "transactions.csv"
        self.pathToFile = rootPath + filename
        
        self.dataframe = DataFrame()
    }
    
    enum Columns: CaseIterable {
        case source
        case date
        case merchant
        case description
        case category
        case type
        case amount
        
        var name: String {
            switch self {
            case .source: return "source"
            case .date: return "date"
            case .merchant: return "merchant"
            case .description: return "description"
            case .category: return "category"
            case .type: return "type"
            case .amount: return "amount"
            }
        }
        
        var index: Int {
            switch self {
            case .source: return 0
            case .date: return 1
            case .merchant: return 2
            case .description: return 3
            case .category: return 4
            case .type: return 5
            case .amount: return 6
            }
        }
        
        var type: CSVType {
            switch self {
            case .date: return .date
            case .amount: return .double
            default: return .string
            }
        }
    }
}
