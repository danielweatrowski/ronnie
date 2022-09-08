//
//  File.swift
//  
//
//  Created by Daniel Weatrowski on 5/24/22.
//

import Foundation
import TabularData
@testable import ronnie

class FruitManager: CSVFileManager {
    var directoryURL: URL
    var filename: String
    var dataframe: DataFrame
    
    required init(directoryURL: URL, filename: String) {
        self.directoryURL = directoryURL
        self.filename = filename
        self.dataframe = DataFrame()
    }
}

extension FruitManager {
    enum Columns: CaseIterable {
        case fruit, color, cost
        
        var name: String {
            switch self {
            case .fruit: return "fruit"
            case .color: return "color"
            case .cost: return "cost"
            }
        }
        
        var index: Int {
            switch self {
            case .fruit: return 0
            case .color: return 1
            case .cost: return 2
            }
        }
        
        var type: CSVType {
            switch self {
            case .cost: return .double
            default: return .string
            }
        }
    }
}


