import Foundation
import Parsing

extension Parsers {
    static let prefixUpToNewline = Prefix { !$0.isNewline }
}

extension Parser where Input == Substring {
    /// Parses the given String encapsulating the boilerplate of dealing with Substring
    func parse(_ raw: String) throws -> Output {
        var input = raw[...]
        return try parse(&input)
    }
}

extension Parser where Input == Substring {
    /// Parses the given String and prints the output and the pending input.
    func printDebug(_ raw: String) throws -> Output {
        var input = raw[...]
        let output = try parse(&input)
        print("             ")
        print("->\(output)<-")
        print("-]\(input)[-")
        print("             ")
        return output
    }
}
