import ArgumentParser
import Flow
import Foundation
import Parsing
import Baggins

@main
struct App: ParsableCommand {
    @Argument(help: #"Path to the "My Clippings.txt" file"#)
    var clippingsFilePath: String

    @Option(name: [.customLong("from"), .short])
    var fromDate = Date.distantPast

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

        for h in highlights {
            print("- \(h.text)")
        }
        print("\n> \(lastDate)")
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


