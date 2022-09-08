//
//  CSVViewer.swift
//  
//
//  Created by Daniel Weatrowski on 5/18/22.
//

import Foundation
import ArgumentParser

struct View: ParsableCommand {
    public static let configuration = CommandConfiguration(abstract: "View a generated financial report csv file")
    
    @Argument(help: "The path to the csv file to be viewed")
    private var path: String
    
    @Flag(name: .shortAndLong, help: "")
    private var pretty = false

    init() {}
    
    mutating func run() throws {
        let filename = (path as NSString).lastPathComponent
        let directoryURL = URL(fileURLWithPath: path).deletingLastPathComponent()
        // TODO: TEST
        switch(filename) {
        case "totals.csv":
            let totals = MonthlyTotalsManager(directoryURL: directoryURL, filename: filename)
            totals.loadDataframe()
            
            if pretty {
                totals.viewPretty()
            } else {
                totals.view()
            }
        default:
            let viewer = Viewer(fileURL: URL(fileURLWithPath: path))
            viewer.view()
        }
        
    }
}
