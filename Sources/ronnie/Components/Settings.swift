//
//  Settings.swift
//  
//
//  Created by Daniel Weatrowski on 5/15/22.
//

import Foundation

/// Decoded representation of settings.json in root directory.
struct Settings: Codable {
    var categories: [String]
}
