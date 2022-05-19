//
//  MonthlyTotals+Generator.swift
//  
//
//  Created by Daniel Weatrowski on 5/19/22.
//

import Foundation
import TabularData

extension MonthlyTotalsManager: CSVGenerator {
    
    func generate() {
        if let transactionsDataframe = transactionsDataframe, let settings = settings {
            generateCategoryTotals(for: transactionsDataframe, categories: settings.categories)
            generateAllTotals(for: transactionsDataframe)
        } else {
            print("Failed to generated totals. File(s) not found")
        }
    }
    
    func createEmptyDataframe() -> DataFrame {
        // No special logic required here. Columns are created from scratch in generate function.
        return DataFrame()
    }
    
    private func generateCategoryTotals(for allTransactions: DataFrame, categories: [String]) {
        
        var allCategories = [String]()
        var allAmounts = [Double]()
        
        for category in categories {
            let categoryTransactions = allTransactions.filter(on: MonthlyTransactionsManager.Columns.category.name, String.self, {$0?.lowercased() == category})
            let categoryDataframe = DataFrame(categoryTransactions)
            let amountsColumn = categoryDataframe[column: MonthlyTransactionsManager.Columns.amount.index]
            let amountsArray = amountsColumn.map({ $0 as! Double })
            let totalAmount = abs(amountsArray.reduce(0,+))
            
            if category == "income" {
                totalEarnings = totalAmount
            }
            
            allCategories.append(category)
            allAmounts.append(totalAmount)
            
            save(categoryDataframe, to: rootPath + "categories/" + category + ".csv")
        }
        
        var categoryTotalsDataframe = DataFrame()
        let categoryColumn = Column(name: Columns.category.name, contents: allCategories)
        let amountColumn = Column(name: Columns.amount.name, contents: allAmounts)
        
        categoryTotalsDataframe.append(column: categoryColumn)
        categoryTotalsDataframe.append(column: amountColumn)
        
        self.dataframe = categoryTotalsDataframe
        save(categoryTotalsDataframe, to: rootPath + "categories/" + filename)
    }
    
    private func generateAllTotals(for transactions: DataFrame) {
        let amountsColumn = transactions[column: MonthlyTransactionsManager.Columns.amount.index]
        let amountsArray = amountsColumn.map({ $0 as! Double })
        let netTotal = abs(amountsArray.reduce(0,+))
        
        var totalsDataframe = DataFrame()
        let categories = ["earnings", "spendings", "net"]
        let amounts = [totalEarnings, totalEarnings - netTotal, netTotal]
        
        let categoriesColumn = Column(name: MonthlyTransactionsManager.Columns.category.name, contents: categories)
        let totalAmountsColumn = Column(name: MonthlyTransactionsManager.Columns.amount.name, contents: amounts)
        
        totalsDataframe.append(column: categoriesColumn)
        totalsDataframe.append(column: totalAmountsColumn)
        
        save(totalsDataframe, to: rootPath + filename)
    }
}

