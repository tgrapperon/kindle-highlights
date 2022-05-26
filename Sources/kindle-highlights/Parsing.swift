import Foundation
import Parsing
import Baggins

struct Highlight {
    let metadata: Metadata
    let text: String
}

struct Metadata {
    let page: Int?
    let location: (Int, Int?)
    let date: Date
}

private let newline = "\r\n"

// - Your Highlight on page 266 | location 4071-4072 | Added on Thursday, 19 April 2018 10:44:34
private let metadataDateFormatter = DateFormatter().then {
    $0.dateFormat = "EEEE, d MMM yyyy HH:mm:ss"
    $0.locale = Locale(identifier: "en_US")
}

private let location = Parse {
    Int.parser()
    Optionally {
        "-"
        Int.parser()
    }
}

// location 4071-4072
private let locationPart = Parse {
    "location "
    location
}

// Your Highlight at location 153-154
private let locationHighlight = Parse {
    OneOf {
        "Your Highlight at location "
        "Your Note at location "
    }
    location
}

// Your Highlight on page 266
private let pageHighlight = Parse {
    OneOf {
        "Your Highlight on page "
        "Your Note on page "
    }
    Int.parser()
}


// Added on Thursday, 19 April 2018 10:44:34
private let addedDate = Parse {
    "Added on "
    Parsers.prefixUpToNewline
        .map { (str: Substring) in
            metadataDateFormatter.date(from: String(str))!
        }
}

private let metadata = Parse {
    "- "
    OneOf {
        Parse {
            pageHighlight
            " | "
            locationPart
        }
        .map { (page, location) -> (Int?, (Int, Int?)) in
            (page, location)
        }
        
        locationHighlight
            .map { location -> (Int?, (Int, Int?)) in
                (nil, location)
            }
    }
    " | "
    addedDate
}.map { (args: ((Int?, (Int, Int?)), Date)) in
    Metadata(page: args.0.0, location: args.0.1, date: args.1)
}

private let highlight = Parse(Highlight.init(metadata:text:)) {
    Skip { PrefixThrough(newline) } // title (author)
    metadata
    Whitespace(.vertical)

    PrefixUpTo("==========")
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

    "=========="
}

let myClippingsParser = Many {
    highlight
} separator: {
    newline
} terminator: {
    Whitespace()
    End()
}
