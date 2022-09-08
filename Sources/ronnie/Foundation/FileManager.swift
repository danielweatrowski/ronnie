//
//  FileManager.swift
//  
//
//  Created by Daniel Weatrowski on 5/23/22.
//

import Foundation

extension FileManager {
    func createDirectoryIfNeeded(at pathURL: URL, directoryName: String) {
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
}
