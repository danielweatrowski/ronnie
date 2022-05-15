//
//  File.swift
//  
//
//  Created by Daniel Weatrowski on 5/4/22.
//

import Foundation
import TabularData

protocol StatementLoader {
    static var name: String { get }
    associatedtype Columns: CaseIterable
    
    var rootPath: String { get }
    var statementFilename: String { get }
    var pathToStatement: String { get }
    
    var dataframe: DataFrame? { get set }
    var options: CSVReadingOptions { get }
    var allColumnTypes: [String : CSVType] { get set }
    var allColumnNames: [String] { get set }
    
    func addReadingOptions()
    func loadDataframe()
    func formatDataframe()
    func getDataframe() -> DataFrame
}

extension StatementLoader {
    static var name: String {
        return String(describing: self)
    }
}
