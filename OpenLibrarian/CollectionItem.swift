//
//  Item.swift
//  OpenLibrarian
//
//  Created by Sean Molenaar on 14/06/2023.
//

import Foundation
import SwiftData
import OpenLibraryKit

@Model
final class CollectionItem {
    var title: String
    var cover: URL?
    var thumbnail: URL?
    @Attribute(.unique) var edition: String
    var workId: String
    var authorNames: [String]
    var type: String
    var start: Date?

    init(entry: ReadingLogEntry, type: ReadingLogType) {
        self.title = entry.work.title
        self.start = entry.loggedDate
        self.authorNames = entry.work.authorNames
        self.type = type.rawValue
        self.workId = entry.work.key.replacingOccurrences(of: "/works/", with: "")
        if let id = entry.loggedEdition?.replacingOccurrences(of: "/books/", with: "") {
            self.edition = id
            self.cover = URL(string: "https://covers.openlibrary.org/b/olid/\(id)-L.jpg?default=false")!
            self.thumbnail = URL(string: "https://covers.openlibrary.org/b/olid/\(id)-S.jpg?default=false")!
        }
    }
}

enum ReadingLogType: String, CaseIterable, Identifiable, CustomStringConvertible {
    case wanted = "wanted"
    case reading = "reading"
    case read = "read"

    var id: String { self.rawValue }
    var description: String { self.rawValue }
}
