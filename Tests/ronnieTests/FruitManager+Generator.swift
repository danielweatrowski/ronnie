//
//  File.swift
//  
//
//  Created by Daniel Weatrowski on 5/24/22.
//

import Foundation
import TabularData
@testable import ronnie

extension FruitManager: CSVGenerator {
    func generate() {}
    
    func createEmptyDataframe() -> DataFrame {
        return DataFrame()
    }
}
