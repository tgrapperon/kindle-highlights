import Baggins
import Foundation
import Parsing

/* - Your Highlight on page 266 | location 4071-4072 | Added on Thursday, 19 April 2018 10:44:34
 */


/// Thursday, 19 April 2018 10:44:34
//let metadataDateFormatter = DateFormatter().then {
//    $0.dateFormat = "EEEE, d MMM yyyy HH:mm:ss"
//    $0.locale = Locale(identifier: "en_US")
//}

// MARK: - Book title and author line

/// Tress of the Emerald Sea (Brandon Sanderson)
/// The Final Empire: 1 (MISTBORN) (Sanderson, Brandon)
let bookAndAuthorParser: some Parser<Substring, Book> = Parse {
//    Always("first"[...])
//    Always(["One"[...]])
    
    Always("a")
    Always("b")
    
//    PrefixUpTo("(")
//
//    Many {
//        parenthesisContentParser
//    } separator: {
//        Whitespace(.horizontal)
//    }
}
.map { (_, _) in
//    var rest = rest
//    guard rest.isEmpty == false else {
//        fatalError("Expected at least one text in parenthesis for the author.")
//    }
    let author = "author"//String(rest.removeLast())
    var title = "title"//String(first)
//    if rest.isEmpty == false {
//        title += rest
//            .map { "(\($0))" }
//            .joined(separator: " ")
//    }
    return Book(
        title: title,//.trimmingCharacters(in: .whitespaces),
        author: author
    )
}

/// (something)
/// returns: something
//private let parenthesisContentParser = Parse {
//    "("
//    PrefixUpTo(")")
//    ")"
//}

// MARK: - Metadata line

//private let locationParser = Parse(Location.init(start:end:)) {
//    Int.parser()
//    Optionally {
//        "-"
//        Int.parser()
//    }
//}

/// location 4071-4072
//private let locationPart = Parse {
//    "location "
//    locationParser
//}

/// Your Highlight at location 153-154
//private let locationHighlight = Parse {
//    OneOf {
//        "Your Highlight at location "
//        "Your Note at location "
//    }
//    locationParser
//}

/// Your Highlight on page 266
//private let pageHighlight = Parse(Page.init(number:)) {
//    OneOf {
//        "Your Highlight on page "
//        "Your Note on page "
//    }
//    Int.parser()
//}

/// Added on Thursday, 19 April 2018 10:44:34
//private let addedDate = Parse {
//    "Added on "
//    Parsers.prefixUpToNewline
//        .map { (str: Substring) in
//            metadataDateFormatter.date(from: String(str))!
//        }
//}

let metadataParser: some Parser<Substring, Metadata> = Parse(Metadata.init(page:location:date:)) {
    Always(Page(number: 2))
    Always(Location(start: 1, end: 1))
    Always("")
//    "- "
//    OneOf {
//        Parse {
//            pageHighlight
//            " | "
//            locationPart
//        }
//        .map { page, location -> (Page?, Location) in
//            (page, location)
//        }
//
//        locationHighlight
//            .map { location -> (Page?, Location) in
//                (nil, location)
//            }
//    }
//    " | "
//    addedDate
}

// MARK: - Content

let contentParser: some Parser<Substring, String> = Parse {
    Always("content")
//    PrefixUpTo(highlightSeparator)
//        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
}

// MARK: - Full Highlight

let highlightParser: some Parser<Substring, Highlight> = Parse({ Highlight(book: $0, metadata: $1, text: $2) }) {
    Always(Book(title: "title", author: "author"))
    Always(Metadata(page: .init(number: 2), location: .init(start: 1, end: 1), date: ""))
    PrefixUpTo(highlightSeparator).map(String.init)
    
//    bookAndAuthorParser
//    Whitespace(.vertical)
//    metadataParser
//    Whitespace(.vertical)
//    contentParser
}

private let highlightSeparator = "=========="

// MARK: - My Clippings File, multiple highlights

let myClippingsParser: some Parser<Substring, [Highlight]> = Many {
//    highlightParser
    Always(Highlight.init(book: .init(title: "title", author: "author"), metadata: .init(page: .init(number: 1), location: .init(start: 0, end: nil), date: ""), text: "fake"))
    Skip { PrefixUpTo(highlightSeparator) }
} separator: {
    highlightSeparator
    Whitespace(1, .vertical)
} terminator: {
    highlightSeparator
    Whitespace()
    End()
}
