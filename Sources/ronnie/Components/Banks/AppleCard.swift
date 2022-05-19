//
//  File.swift
//  
//
//  Created by Daniel Weatrowski on 5/2/22.
//

import Foundation
import TabularData

class AppleCard: CSVLoader {
    
    var rootPath: String
    
    var filename: String
    
    var pathToFile: String
    
    var dataframe: DataFrame?
    
    var options = CSVReadingOptions()
    
    var allColumnNames = Columns.allCases.map({ $0.name })
    
    var allColumnTypes = Columns.allCases.reduce(into: [String: CSVType]()) {
        $0[$1.name] = $1.type
    }
    
    let bank: Bank = .appleCard
    
    init() {
        self.rootPath = ""
        self.filename = ""
        self.pathToFile = rootPath + filename
    }

    init(year: String, month: String, path: String, verbose: Bool) {
        let activeDirectoryPath = "\(path)/\(year)/\(month)/"
        self.rootPath = activeDirectoryPath
        self.filename = "\(bank.statementNamePrefix)\(year)\(month).csv"
        self.pathToFile = rootPath + filename
    }
    
    func addReadingOptions() {
        options.addDateParseStrategy(
            Date.ParseStrategy(format: "\(month: .twoDigits)/\(day: .twoDigits)/\(year: .defaultDigits)",
                               timeZone: .current)
        )
    }

    func loadDataframe() {
        addReadingOptions()

        do {
            let statementURL = URL(fileURLWithPath: pathToFile)
            let dataframe = try DataFrame(contentsOfCSVFile: statementURL, columns: allColumnNames, types: allColumnTypes, options: options)
            
            print("Successfully loaded \(name) statement.")
            print("File loaded from \(statementURL.path)\n")
            
            self.dataframe = dataframe
            formatDataframe()
        } catch (let error as CSVReadingError) {
            print("Failed to load Apple Card statement into DataFrame")
            print(error.description)
        } catch {
            print("Failed due to unknown error.")
        }
    }
    
    func formatDataframe() {
        guard let originalDataframe = dataframe else {
            return
        }

        // create sorce column
        let nameArray = Array(repeating: name, count: originalDataframe.rows.count)
        let sourceColumn = Column(name: MonthlyTransactionsManager.Columns.source.name, contents: nameArray)
        
        // extract original data columns
        let dateColumn = originalDataframe[column: Columns.transactionDate.index]
        let descriptionColumn = originalDataframe[column: Columns.description.index]
        let merchantColumn = originalDataframe[column: Columns.merchant.index]
        let categoryColumn = originalDataframe[column: Columns.category.index]
        let typeColumn = originalDataframe[column: Columns.type.index]
        let amountColumn = originalDataframe[column: Columns.amount.index]
        
        let transformedAmounts = amountColumn.map { element -> Double? in
            return Double(element as! String)
        }
        
        var formattedDataframe = DataFrame()
        formattedDataframe.append(column: sourceColumn)
        formattedDataframe.append(column: dateColumn)
        formattedDataframe.append(column: merchantColumn)
        formattedDataframe.append(column: descriptionColumn)
        formattedDataframe.append(column: categoryColumn)
        
        formattedDataframe.append(column: typeColumn)
        
        let transformedAmountColumn = Column(name: Columns.amount.name, contents: transformedAmounts)
        formattedDataframe.append(column: transformedAmountColumn)
        
        formattedDataframe.renameColumn(Columns.transactionDate.name, to: MonthlyTransactionsManager.Columns.date.name)
        formattedDataframe.renameColumn(Columns.merchant.name, to: MonthlyTransactionsManager.Columns.merchant.name)
        formattedDataframe.renameColumn(Columns.description.name, to: MonthlyTransactionsManager.Columns.description.name)
        formattedDataframe.renameColumn(Columns.category.name, to: MonthlyTransactionsManager.Columns.category.name)
        formattedDataframe.renameColumn(Columns.type.name, to: MonthlyTransactionsManager.Columns.type.name)
        formattedDataframe.renameColumn(Columns.amount.name, to: MonthlyTransactionsManager.Columns.amount.name)
        
        dataframe = formattedDataframe
    }
    
    func getDataframe() -> DataFrame {
        if let dataframe = dataframe {
            return dataframe
        } else {
            print("Unable to retreive dataframe from \(name)")
            return DataFrame()
        }
    }
}
extension AppleCard {
    enum Columns: CaseIterable {
        case transactionDate
        case description
        case merchant
        case category
        case type
        case amount
        
        var name: String {
            switch self {
            case .transactionDate: return "Transaction Date"
            case .description: return "Description"
            case .merchant: return "Merchant"
            case .category: return "Category"
            case .type: return "Type"
            case .amount: return "Amount (USD)"
            }
        }
        
        var index: Int {
            switch self {
            case .transactionDate: return 0
            case .description: return 1
            case .merchant: return 2
            case .category: return 3
            case .type: return 4
            case .amount: return 5
            }
        }
        
        var type: CSVType {
            switch self {
            case .transactionDate: return .date
            case .description: return .string
            case .merchant: return .string
            case .category: return .string
            case .type: return .string
            case .amount: return .string
            }
        }
    }
}
