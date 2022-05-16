//
//  TotalsGenerator.swift
//  
//
//  Created by Daniel Weatrowski on 5/15/22.
//

import Foundation
import TabularData

class MonthlyTotalsGenerator: CSVGenerator {
    var rootPath: String
    
    var filename: String
    
    var pathToFile: String
    
    var dataframe: DataFrame
    
    var transactionsDataframe: DataFrame
    
    private var settings: Settings
    
    private var totalEarnings: Double = 0
    
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
    
    func generate() {
        generateCategoryTotals(for: transactionsDataframe, categories: settings.categories)
        generateAllTotals(for: transactionsDataframe)
    }
    
    func createEmptyDataframe() -> DataFrame {
        // No special logic required here. Columns are created from scratch in generate function.
        return DataFrame()
    }
    
    private func generateCategoryTotals(for allTransactions: DataFrame, categories: [String]) {
        
        var allCategories = [String]()
        var allAmounts = [Double]()
        
        for category in categories {
            let categoryTransactions = allTransactions.filter(on: MonthlyTransactionsLoader.Columns.category.name, String.self, {$0?.lowercased() == category})
            let categoryDataframe = DataFrame(categoryTransactions)
            let amountsColumn = categoryDataframe[column: MonthlyTransactionsLoader.Columns.amount.index]
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
        let amountsColumn = transactions[column: MonthlyTransactionsLoader.Columns.amount.index]
        let amountsArray = amountsColumn.map({ $0 as! Double })
        let netTotal = abs(amountsArray.reduce(0,+))
        
        var totalsDataframe = DataFrame()
        let categories = ["earnings", "spendings", "net"]
        let amounts = [totalEarnings, totalEarnings - netTotal, netTotal]
        
        let categoriesColumn = Column(name: MonthlyTransactionsLoader.Columns.category.name, contents: categories)
        let totalAmountsColumn = Column(name: MonthlyTransactionsLoader.Columns.amount.name, contents: amounts)
        
        totalsDataframe.append(column: categoriesColumn)
        totalsDataframe.append(column: totalAmountsColumn)
        
        save(totalsDataframe, to: rootPath + filename)
    }
    
}
extension MonthlyTotalsGenerator {
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
