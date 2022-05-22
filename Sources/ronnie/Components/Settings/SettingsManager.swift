//
//  File.swift
//  
//
//  Created by Daniel Weatrowski on 5/15/22.
//

import Foundation

class SettingsManager {
    private var path: String
    
    private var filename: String = FileName.settings.rawValue
    
    private var settings: Settings?
    
    private var pathToFile: String {
        return path + "/" + filename
    }
    
    init(path: String) {
        self.path = path
    }
    
    func load() {
        let categoriesURL = URL(fileURLWithPath: pathToFile)
        do {
            let data = try Data(contentsOf: categoriesURL)
            let settings = try JSONDecoder().decode(Settings.self, from: data)
            self.settings = settings
            
            print("Successfully loaded \(filename)")
            print("File loaded from \(categoriesURL.path)\n")
            
        } catch {
            print("Failed to load settings.json: \(error.localizedDescription)")
            print("Unable to load from \(categoriesURL.path)\n")
        }
    }
    
    func getSettings() -> Settings {
        if let settings = settings {
            return settings
        } else {
            return Settings(categories: [], banks: [])
        }
    }
}
