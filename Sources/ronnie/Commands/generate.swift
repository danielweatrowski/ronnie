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
        let settingsManager = SettingsManager(path: path)
        settingsManager.load()
        
        let settings = settingsManager.getSettings()
        
        let monthDirectoryPath = "\(path)/\(year)/\(month)/"
        let monthDirectoryURL = URL(fileURLWithPath: monthDirectoryPath)
        let transactionsManager = MonthlyTransactionsManager(directoryURL: monthDirectoryURL)
                
        for bank in Bank.allCases where settings.banks.contains(bank.settingsName) {
            switch (bank) {
            case .appleCard:
                let statementName = "\(Bank.appleCard.statementNamePrefix)\(year)\(month).csv"
                let appleCardManager = AppleCard(directoryURL: monthDirectoryURL, filename: statementName)
                appleCardManager.loadDataframe()
                transactionsManager.add(dataframe: appleCardManager.getDataframe())
                break
            case .orangeCountysCU:
                let statementName = "\(Bank.orangeCountysCU.statementNamePrefix)\(year)\(month).csv"
                let occuManager = OrangeCountysCU(directoryURL: monthDirectoryURL, filename: statementName)
                occuManager.loadDataframe()
                transactionsManager.add(dataframe: occuManager.getDataframe())
                break
            }
        }
        
        transactionsManager.generate()
    }
    
    private func generateTotals() {
        let monthDirectoryPath = "\(path)/\(year)/\(month)/"
        let monthDirectoryURL = URL(fileURLWithPath: monthDirectoryPath)

        let transactionsManager = MonthlyTransactionsManager(year: year, month: month, directoryURL: monthDirectoryURL, verbose: verbose)
        transactionsManager.loadDataframe()
        let transactionsDataframe = transactionsManager.getDataframe()

        let settingsManager = SettingsManager(path: path)
        settingsManager.load()
        
        let settings = settingsManager.getSettings()
        
        let totalsGenerator = MonthlyTotalsManager(directoryURL: monthDirectoryURL, transactions: transactionsDataframe, settings: settings)
        totalsGenerator.generate()
    }
}
