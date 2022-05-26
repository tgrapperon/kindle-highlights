//
//  File.swift
//  
//
//  Created by Alejandro Martinez on 28/4/22.
//

import Foundation
import Parsing
import Baggins

extension Parsers {
    static let prefixUpToNewline = Prefix { !$0.isNewline }
}


