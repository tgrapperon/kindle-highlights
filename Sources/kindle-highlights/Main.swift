import ArgumentParser
import Flow
import Foundation
import Parsing
import Baggins
import AppKit

@main
struct App: ParsableCommand {
    @Argument(help: #"Path to the "My Clippings.txt" file"#)
    var clippingsFilePath: String

    @Option(name: [.customLong("from"), .short])
    var fromDate = Date.distantPast
    
    @Flag(name: [.customLong("cp")])
    var useClipboard = false
    
    @Flag
    var formatAdmonitions = false

    func run() throws {
        var contents = ""
        contents = try String(contentsOfFile: clippingsFilePath)
//        print(contents)

        var input = contents[...]
        let output = try myClippingsParser.parse(&input)
//        print(output)
//        print(">>>", input)
        guard !output.isEmpty else {
            throw SimpleError("No highlights found.")
        }

        let lastDate: String = dateFormatter.string(from: output.last!.metadata.date)

        let highlights = output
            .filter { $0.metadata.date > fromDate }

        guard !highlights.isEmpty else {
            throw SimpleError("No new highlights.")
        }

        var text = ""
        
        for h in highlights {
            if formatAdmonitions {
                print("""
                    > [!summary] \(h.metadata.page.map { "Page \($0)" } ?? "") | Location \(h.metadata.location.0) \(h.metadata.location.1.map { "-\($0)" } ?? "")
                    > \(h.text)
                    
                    
                    """, to: &text)
            } else {
                print("- \(h.text)", to: &text)
            }
        }
        

        print("\n> \(lastDate)", to: &text)
        
        if useClipboard {
            let clipboard = NSPasteboard.general
            clipboard.declareTypes([.string], owner: nil)
            if clipboard.setString(text, forType: .string) {
                print("Copied to clipboard.")
            } else {
                print("Failed to copy to clipboard.")
            }
        } else {
            print(text)
        }
    }
}

let dateFormatter = ISO8601DateFormatter().then {
    $0.timeZone = .current
}

extension Date: ExpressibleByArgument {
    public init?(argument: String) {
        guard let date = dateFormatter.date(from: argument) else {
            return nil
        }
        self = date
    }
}


