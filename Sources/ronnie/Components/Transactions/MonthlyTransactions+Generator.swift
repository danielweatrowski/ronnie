//
//  MonthlyTransactions+Generator.swift
//  
//
//  Created by Daniel Weatrowski on 5/15/22.
//

import Foundation
import TabularData

extension MonthlyTransactionsManager: CSVGenerator {
    func generate() {
        save(dataframe, to: fileURL)
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
