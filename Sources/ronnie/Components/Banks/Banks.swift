//
//  Banks.swift
//  
//
//  Created by Daniel Weatrowski on 5/19/22.
//

import Foundation

/// Enum representation of all bank statements supported by Ronnie mapped to their associated loader controllers.
enum Bank: CaseIterable {
    // Add future banks here
    case appleCard
    case orangeCountysCU
    
    var friendlyName: String {
        get {
            switch(self) {
            case .appleCard: return "Apple Card"
            case .orangeCountysCU: return "Orange Countys Credit Union"
            }
        }
    }
    
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
