//
//  File.swift
//  
//
//  Created by Daniel Weatrowski on 5/2/22.
//

import Foundation
import SwiftCSV

// represents a single line from the Apple Card Statement CSV
class AppleCardTransaction {
    
}

class AppleCardManager {
    private var reportDateString: String
    
    let statementFilename: String {
        return "ac-" + reportDateString
    }
    
    init(reportDateString: String) {
        self.reportDateString = reportDateString
    }
}
