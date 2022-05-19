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
        let settingsPath = path + "/settings.json"
        let settingsManager = SettingsManager(path: settingsPath)
        settingsManager.load()
        
        let settings = settingsManager.getSettings()
        // TODO: Use banks in settings to load statements

        let appleCardManager = AppleCard(year: year, month: month, path: path, verbose: verbose)
        appleCardManager.loadDataframe()
        
        let occu = OrangeCountysCU(year: year, month: month, path: path, verbose: verbose)
        occu.loadDataframe()
        
        let acData = appleCardManager.getDataframe()
        let occuData = occu.getDataframe()
        
        let transactionsManager = MonthlyTransactionsManager(path: appleCardManager.rootPath)
        transactionsManager.add(dataframe: acData)
        transactionsManager.add(dataframe: occuData)
        
        transactionsManager.generate()
    }
    
    private func generateTotals() {
        let transactionsManager = MonthlyTransactionsManager(year: year, month: month, path: path, verbose: verbose)
        transactionsManager.loadDataframe()
        let transactionsDataframe = transactionsManager.getDataframe()

                
        let settingsPath = path + "/settings.json"
        let settingsManager = SettingsManager(path: settingsPath)
        settingsManager.load()
        
        let settings = settingsManager.getSettings()
        
        let activeDirectoryPath = "\(path)/\(year)/\(month)/"
        let totalsGenerator = MonthlyTotalsManager(path: activeDirectoryPath, transactions: transactionsDataframe, settings: settings)
        totalsGenerator.generate()
    }
}
