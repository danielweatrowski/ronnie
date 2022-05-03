//
//  File.swift
//  
//
//  Created by Daniel Weatrowski on 5/2/22.
//

import ArgumentParser
import Foundation

struct Generate: ParsableCommand {
    
    public static let configuration = CommandConfiguration(abstract: "Generate a financial report for a given months")
     
    @Argument(help: "The year and month of the report to be generated. Formatted as \"yyyyMM\"")
    private var date: String
    
    @Flag(name: .shortAndLong, help: "Show extra logging for debugging purposes")
    var verbose: Bool = false

    init() {}
    
    mutating func run() throws {
        let reportDate = Date.formatArgument(date)
        
        if verbose {
            print("Creating financial report for \(reportDate)")
        }
    }
}
