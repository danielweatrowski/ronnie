//
//  File.swift
//  
//
//  Created by Daniel Weatrowski on 5/2/22.
//

import ArgumentParser

struct Ronnie: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A Swift command-line tool to assistance with all financial needs.",
        subcommands: [Generate.self, View.self])

    init() { }
}
