import Foundation

struct Highlight: Equatable {
    let book: Book
    let metadata: Metadata
    let text: String
}

struct Book: Equatable {
    let title: String
    let author: String
}

struct Metadata: Equatable {
    let page: Page?
    let location: Location
//    let date: Date
    let date: String?
}

struct Page: Equatable {
    let number: Int
}

struct Location: Equatable {
    let start: Int
    let end: Int?
}
