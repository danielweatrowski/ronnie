//
//  File.swift
//  
//
//  Created by Daniel Weatrowski on 5/18/22.
//

import Foundation
import TabularData

/// Conform `CSVFileManager` classes to this protocol to make the file viewable via the `ronnie view` command
protocol CSVViewer {
    /// Prints the `CSVFileManager.datatable` as is, without any special format.
    func view()
    
    /// Use this function to format the `CSVFileManager.datatable` into a custom "pretty" format.
    func formatPretty() -> DataFrame
    
    /// Prints the `CSVFileManager.datatable` in the pretty format.
    func viewPretty()
}


 
