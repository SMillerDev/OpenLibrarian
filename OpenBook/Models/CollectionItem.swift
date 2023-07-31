//
//  Item.swift
//  OpenBook
//
//  Created by Sean Molenaar on 14/06/2023.
//

import Foundation
import SwiftData
import OpenLibraryKit

@Model
final class CollectionItem: ObservableObject {
    @Attribute(.unique) var workId: String
    @Attribute(.unique) var editionId: String
    var title: String
    var cover: URL?
    var thumbnail: URL?
    var authorNames: [String]?
    var type: String
    var start: Date?
    var progress: Int?

    init(workId: String, editionId: String, title: String, type: ReadingLogType) {
        self.workId = workId
        self.editionId = editionId
        self.title = title
        self.type = type.rawValue
    }

    init(entry: ReadingLogEntry, type: ReadingLogType) {
        self.title = entry.work.title
        self.start = entry.loggedDate
        self.authorNames = entry.work.authorNames
        self.type = type.rawValue
        self.workId = entry.work.olid
        if let id = entry.loggedEdition?.replacingOccurrences(of: "/books/", with: "") {
            self.editionId = id
            self.cover = URL(string: "https://covers.openlibrary.org/b/olid/\(id)-L.jpg?default=false")!
            self.thumbnail = URL(string: "https://covers.openlibrary.org/b/olid/\(id)-S.jpg?default=false")!
        }
    }
}
