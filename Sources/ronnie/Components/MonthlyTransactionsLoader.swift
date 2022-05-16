//
//  File.swift
//  
//
//  Created by Daniel Weatrowski on 5/15/22.
//

import Foundation
import TabularData

class MonthlyTransactionsLoader: CSVLoader {
    var rootPath: String
    
    var filename: String
    
    var pathToFile: String
    
    var dataframe: DataFrame?
    
    var options: CSVReadingOptions
    
    var allColumnTypes: [String : CSVType] = Columns.allCases.reduce(into: [String: CSVType]()) {
        $0[$1.name] = $1.type
    }
    
    var allColumnNames: [String] = Columns.allCases.map({ $0.name })
    
    init(year: String, month: String, path: String, verbose: Bool) {
        let activeDirectoryPath = "\(path)/\(year)/\(month)/"
        self.rootPath = activeDirectoryPath
        self.filename = "transactions_final.csv"
        self.pathToFile = rootPath + filename
        
        self.options = CSVReadingOptions()
    }

    func loadDataframe() {
        addReadingOptions()
        do {
            let statementURL = URL(fileURLWithPath: pathToFile)
            let dataframe = try DataFrame(contentsOfCSVFile: statementURL, columns: allColumnNames, types: allColumnTypes, options: options)
            
            print("Successfully loaded \(name) statement.")
            print("File loaded from \(statementURL.path)")
            
            self.dataframe = dataframe
            formatDataframe()
        } catch (let error as CSVReadingError) {
            print("Failed to load \(name) statement into DataFrame")
            print(error.row)
        } catch {
            print("Failed due to unknown error.")
        }
    }
    
    func getDataframe() -> DataFrame {
        if let dataframe = dataframe {
            return dataframe
        } else {
            print("Unable to retreive dataframe from \(name)")
            return DataFrame()
        }
    }
    
    // UNUSED
    func formatDataframe() {}
    func addReadingOptions() {}
}

extension MonthlyTransactionsLoader {
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
