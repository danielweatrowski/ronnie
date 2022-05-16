//
//  File.swift
//  
//
//  Created by Daniel Weatrowski on 5/15/22.
//

import Foundation

class SettingsLoader {
    private var path: String
    
    private var filename: String = "settings.json"
    
    private var settings: Settings?
    
    init(path: String) {
        self.path = path
    }
    
    func load() {
        let categoriesURL = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: categoriesURL)
            let settings = try JSONDecoder().decode(Settings.self, from: data)
            self.settings = settings
            
            print("Successfully loaded \(filename)")
            print("File loaded from \(categoriesURL.path)")
            
        } catch {
            print("Failed to load settings.json: \(error.localizedDescription)")
        }
    }
    
    func getSettings() -> Settings {
        if let settings = settings {
            return settings
        } else {
            return Settings(categories: [])
        }
    }
}
