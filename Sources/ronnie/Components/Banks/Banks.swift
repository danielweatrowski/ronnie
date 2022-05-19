//
//  Banks.swift
//  
//
//  Created by Daniel Weatrowski on 5/19/22.
//

import Foundation

enum Bank {
    // Add future banks here
    case appleCard
    case orangeCountysCU
    
    var settingsName: String {
        get {
            switch(self) {
            case .appleCard: return "AppleCard"
            case .orangeCountysCU: return "OrangeCountysCU"
            }
        }
    }
    
    var statementNamePrefix: String {
        get {
            switch(self) {
            case .appleCard: return "ac_"
            case .orangeCountysCU: return "occu_"
            }
        }
    }
    
    var loader: CSVLoader {
        get {
            switch(self) {
            case .appleCard: return AppleCard()
            case .orangeCountysCU: return OrangeCountysCU()
            }
        }
    }
}
