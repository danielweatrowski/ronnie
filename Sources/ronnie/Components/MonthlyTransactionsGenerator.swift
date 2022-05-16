//
//  File.swift
//  
//
//  Created by Daniel Weatrowski on 5/15/22.
//

import Foundation
import TabularData

class MonthlyTransactionsGenerator: CSVGenerator {
    
    var rootPath: String
    
    var filename: String
    
    var pathToFile: String
    
    var dataframe: DataFrame
    
    init(path: String) {
        self.rootPath = path
        self.filename = "transactions_raw.csv"
        self.pathToFile = rootPath + filename
        
        self.dataframe = DataFrame()
        self.dataframe = createEmptyDataframe()
    }
    
    func generate() {
        save(dataframe, to: pathToFile)
    }
    
    func createEmptyDataframe() -> DataFrame {
        var dataframe = DataFrame()
        let sourceColumn = Column(name: Columns.source.name, contents: [String]())
        let dateColumn = Column(name: Columns.date.name, contents: [Date]())
        let merchantColumn = Column(name: Columns.merchant.name, contents: [String]())
        let descriptionColumn = Column(name: Columns.description.name, contents: [String]())
        let categoryColumn = Column(name: Columns.category.name, contents: [String]())
        let typeColumn = Column(name: Columns.type.name, contents: [String]())
        let amountColumn = Column(name: Columns.amount.name, contents: [Double]())
        
        dataframe.append(column: sourceColumn)
        dataframe.append(column: dateColumn)
        dataframe.append(column: merchantColumn)
        dataframe.append(column: descriptionColumn)
        dataframe.append(column: categoryColumn)
        dataframe.append(column: typeColumn)
        dataframe.append(column: amountColumn)
        
        return dataframe
    }
    
    func add(dataframe: DataFrame) {
        self.dataframe.append(dataframe)
    }

}

extension MonthlyTransactionsGenerator {
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
