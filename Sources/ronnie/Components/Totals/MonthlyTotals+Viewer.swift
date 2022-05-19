//
//  File.swift
//  
//
//  Created by Daniel Weatrowski on 5/19/22.
//

import Foundation
import TabularData

extension MonthlyTotalsManager: CSVViewer {
    func view() {
        print(dataframe)
    }
    
    func formatPretty() -> DataFrame {
        let categoryColumn = dataframe[column: Columns.category.index]
        let amountsColumn = dataframe[column: Columns.amount.index]
        
        let categories = categoryColumn.map({
            return ($0 as! String).capitalized
        })
        
        let amounts = amountsColumn.map({
            return String(format: "$%.02f", $0 as! Double)
        })
        
        var prettyDataframe = DataFrame()
        let prettyCategoryColumn = Column(name: Columns.category.name, contents: categories)
        let prettyAmountColumn = Column(name: Columns.amount.name, contents: amounts)
        
        prettyDataframe.append(column: prettyCategoryColumn)
        prettyDataframe.append(column: prettyAmountColumn)
        
        return prettyDataframe
    }
    
    func viewPretty() {
        let prettyDataframe = formatPretty()
        print(prettyDataframe)
    }
}
