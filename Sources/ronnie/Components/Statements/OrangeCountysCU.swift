//
//  OCCU.swift
//  
//
//  Created by Daniel Weatrowski on 5/14/22.
//

import Foundation
import TabularData

class OrangeCountysCU: CSVLoader {
    
    var rootPath: String
    
    var statementFilename: String
    
    var pathToStatement: String
    
    var options: CSVReadingOptions
    
    var dataframe: DataFrame?
    
    var allColumnTypes: [String : CSVType] = Columns.allCases.reduce(into: [String: CSVType]()) {
        $0[$1.name] = $1.type
    }
    
    var allColumnNames: [String] = Columns.allCases.map({ $0.name })
    
    init(year: String, month: String, path: String, verbose: Bool) {
        let activeDirectoryPath = "\(path)/\(year)/\(month)/"
        let _ = "/Users/danielweatrowski/Documents/Developer/ronnie/\(year)/\(month)/"
        self.rootPath = activeDirectoryPath
        self.statementFilename = "occu_\(year)\(month).csv"
        self.pathToStatement = rootPath + statementFilename
        
        self.options = CSVReadingOptions()
    }
    
    func addReadingOptions() {
        options.addDateParseStrategy(
            Date.ParseStrategy(format: "\(month: .twoDigits)/\(day: .twoDigits)/\(year: .defaultDigits) \(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)",
                               timeZone: .current)
        )
    }
    
    func loadDataframe() {
        addReadingOptions()
        do {
            let statementURL = URL(fileURLWithPath: pathToStatement)
            let dataframe = try DataFrame(contentsOfCSVFile: statementURL, columns: allColumnNames, types: allColumnTypes, options: options)
            
            print("Successfully loaded \(name) statement.")
            print("File loaded from \(statementURL.path)\n")
            
            self.dataframe = dataframe
            formatDataframe()
        } catch (let error as CSVReadingError) {
            print("Failed to load \(name) statement into DataFrame")
            print(error.row)
        } catch {
            print("Failed due to unknown error.")
        }
    }
    
    func formatDataframe() {
        guard let originalDataframe = dataframe else {
            return
        }

        let nameArray = Array(repeating: name, count: originalDataframe.rows.count)
        let sourceColumn = Column(name: Transactions.Columns.source.name, contents: nameArray)
        
        let merchantArray = Array(repeating: "", count: originalDataframe.rows.count)
        let merchantColumn = Column(name: Transactions.Columns.merchant.name, contents: merchantArray)
        
        let categoryArray = Array(repeating: "", count: originalDataframe.rows.count)
        let categoryColumn = Column(name: Transactions.Columns.category.name, contents: categoryArray)

        let dateColumn = originalDataframe[column: Columns.date.index]
        let descriptionColumn = originalDataframe[column: Columns.description.index]
        let typeColumn = originalDataframe[column: Columns.type.index]
        let amountColumn = originalDataframe[column: Columns.amount.index]
        
        // Transform all amounts of type "Deposit" to a negative value
        var allAmounts = amountColumn.map { element in
            return element as! Double
        }
        let allTypes = typeColumn.map { element in
            return element as! String
        }
        
        // if type == deposite, negate amount
        for (index, type) in allTypes.enumerated() {
            if type == "Deposit" {
                let amount = allAmounts[index]
                allAmounts[index] = amount * -1
            }
        }
        
        var formattedDataframe = DataFrame()
        formattedDataframe.append(column: sourceColumn)
        formattedDataframe.append(column: dateColumn)
        formattedDataframe.append(column: merchantColumn)
        formattedDataframe.append(column: descriptionColumn)
        formattedDataframe.append(column: categoryColumn)
        formattedDataframe.append(column: typeColumn)
        
        let transformedAmountColumn = Column(name: Columns.amount.name, contents: allAmounts)
        formattedDataframe.append(column: transformedAmountColumn)
        
        formattedDataframe.renameColumn(Columns.date.name, to: Transactions.Columns.date.name)
        formattedDataframe.renameColumn(Columns.description.name, to: Transactions.Columns.description.name)
        formattedDataframe.renameColumn(Columns.type.name, to: Transactions.Columns.type.name)
        formattedDataframe.renameColumn(Columns.amount.name, to: Transactions.Columns.amount.name)
        
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

extension OrangeCountysCU {
    enum Columns: CaseIterable {
        case description
        case type
        case amount
        case date
        
        var name: String {
            switch self {
            case .description: return "Description"
            case .type: return "Type"
            case .amount: return "Amount"
            case .date: return "Date"
            }
        }
        
        var index: Int {
            switch self {
            case .description: return 0
            case .type: return 1
            case .amount: return 2
            case .date: return 3
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
