//
//  Generate.swift
//  Created by Daniel Weatrowski on 5/2/22.
//

import ArgumentParser
import Foundation
import TabularData

struct Generate: ParsableCommand {
    
    public static let configuration = CommandConfiguration(abstract: "Generate a financial report for a given month and year")
     
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
        let date = year + month
        let reportDate = Date.formatArgument(date)
        
        if verbose {
            print("Creating financial report for \(reportDate)")
        }
        
        let appleCardManager = AppleCard(year: year, month: month, path: path, verbose: verbose)
        appleCardManager.loadDataframe()
        
        let occu = OrangeCountysCU(year: year, month: month, path: path, verbose: verbose)
        occu.loadDataframe()
        
        let acData = appleCardManager.getDataframe()
        let occuData = occu.getDataframe()
        
        let transactions = Transactions(path: appleCardManager.rootPath)
        transactions.add(dataframe: acData)
        transactions.add(dataframe: occuData)
        
        transactions.saveDataframe()
        
    }
}
