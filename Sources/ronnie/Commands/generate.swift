//
//  Generate.swift
//  Created by Daniel Weatrowski on 5/2/22.
//

import ArgumentParser
import Foundation
import TabularData

struct Generate: ParsableCommand {
    
    public static let configuration = CommandConfiguration(abstract: "Generate a financial report for a given month and year")
    
    @Argument(help: "The type of report to be generated. Note: transactions report must be generated before any other reports.")
    private var type: String
     
    @Argument(help: "The month (mm) of the report to be generated.")
    private var month: String
    
    @Argument(help: "The year (yyyy) of the report to be generated")
    private var year: String
    
    @Argument(help: "The path to the root Ronnie directory. The default path is the current working directory")
    private var path: String = "."
    
    @Flag(name: .shortAndLong, help: "Show extra logging for debugging purposes")
    var verbose: Bool = false

    init() {}
    
    mutating func run() throws {
        switch(type) {
        case "transactions": generateTransactions()
        case "totals": generateTotals()
        default:
            print("Error: unknown report type.")
            break
        }
    }
    
    private func generateTransactions() {
        let appleCardManager = AppleCard(year: year, month: month, path: path, verbose: verbose)
        appleCardManager.loadDataframe()
        
        let occu = OrangeCountysCU(year: year, month: month, path: path, verbose: verbose)
        occu.loadDataframe()
        
        let acData = appleCardManager.getDataframe()
        let occuData = occu.getDataframe()
        
        let transactions = MonthlyTransactionsGenerator(path: appleCardManager.rootPath)
        transactions.add(dataframe: acData)
        transactions.add(dataframe: occuData)
        
        transactions.generate()
    }
    
    private func generateTotals() {
        let transactionsLoader = MonthlyTransactionsLoader(year: year, month: month, path: path, verbose: verbose)
        transactionsLoader.loadDataframe()
        
        let transactionsDataframe = transactionsLoader.getDataframe()
                
        let settingsPath = path + "/settings.json"
        let settingsLoader = SettingsLoader(path: settingsPath)
        settingsLoader.load()
        
        let settings = settingsLoader.getSettings()
        
        let activeDirectoryPath = "\(path)/\(year)/\(month)/"
        let totalsGenerator = MonthlyTotalsGenerator(path: activeDirectoryPath, transactions: transactionsDataframe, settings: settings)
        totalsGenerator.generate()
    }
}
