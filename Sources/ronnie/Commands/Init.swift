//
//  File.swift
//  
//
//  Created by Daniel Weatrowski on 5/22/22.
//

import Foundation
import ArgumentParser

struct Init: ParsableCommand {
    public static let configuration = CommandConfiguration(abstract: "Initialize a new Ronnie directory and create the necessary directories and files to begin using the Ronnie finance tool.")

    @Argument(help: "Optional path argument to initialize ronnie directory. The default path is the current working directory")
    private var path: String = "."
    
    init() {}
    
    mutating func run() throws {
        let currentYear = Date.getCurrentYear()
        
        let rootURL = URL(fileURLWithPath: path)
        createDirectory(pathURL: rootURL, directoryName: "Ronnie")
        
        let ronnieURL = rootURL.appendingPathComponent("Ronnie")
        createDirectory(pathURL: ronnieURL, directoryName: currentYear)
        
        let currentYearURL = ronnieURL.appendingPathComponent(currentYear)
        createMonthDirectories(pathURL: currentYearURL)
        createSettings(pathURL: ronnieURL)
    }
    
    private func createDirectory(pathURL: URL, directoryName: String) {
        let directoryURL = pathURL.appendingPathComponent(directoryName)
        if !FileManager.default.fileExists(atPath: directoryURL.path) {
            do {
                try FileManager.default.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: true, attributes: nil)
                print("Successfully created \(directoryName) directory")
                print("Directory is located at \(directoryURL.path)")
            } catch {
                print("Error: Failed to created categories directory")
                print(error.localizedDescription)
            }
        }
    }
    
    private func createSettings(pathURL: URL) {
        let settings = Settings(categories: [], banks: [])
        
        let pathWithFilename = pathURL.appendingPathComponent(FileName.settings.rawValue)
        do {
            let encodedSettings = try JSONEncoder().encode(settings)
            let settingsString = String(data: encodedSettings, encoding: .utf8)
            try settingsString?.write(to: pathWithFilename,atomically: true, encoding: .utf8)
        } catch {
            print("Failed to initialize \(pathWithFilename)")
        }
    }
    
    private func createMonthDirectories(pathURL: URL) {
        for month in Date.getMonths() {
            createDirectory(pathURL: pathURL, directoryName: month)
        }
    }

}


