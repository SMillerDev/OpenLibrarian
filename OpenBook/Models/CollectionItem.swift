//
//  Item.swift
//  OpenBook
//
//  Created by Sean Molenaar on 14/06/2023.
//

import Foundation
import CoreData
import OpenLibraryKit

final class CollectionItem: NSManagedObject {
    @NSManaged var workId: String
    @NSManaged var editionId: String
    @NSManaged var title: String
    @NSManaged var cover: URL?
    @NSManaged var thumbnail: URL?
    @NSManaged var authorNames: Set<String>?
    @NSManaged var type: String
    @NSManaged var start: Date?
    @NSManaged var progress: NSNumber?

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    init(context: NSManagedObjectContext) {
        super.init(entity: CollectionItem.entity(), insertInto: context)
    }

    init(_ context: NSManagedObjectContext, workId: String, editionId: String, title: String, type: ReadingLogType) {
        super.init(entity: CollectionItem.entity(), insertInto: context)
        self.workId = workId
        self.editionId = editionId
        self.title = title
        self.type = type.rawValue
    }

    init(_ context: NSManagedObjectContext, entry: ReadingLogEntry, type: ReadingLogType) {
        super.init(entity: CollectionItem.entity(), insertInto: context)
        self.title = entry.work.title
        self.start = entry.loggedDate
        self.authorNames = Set(entry.work.authorNames)
        self.type = type.rawValue
        self.workId = entry.work.olid
        if let id = entry.loggedEdition?.replacingOccurrences(of: "/books/", with: "") {
            self.editionId = id
            self.cover = URL(string: "https://covers.openlibrary.org/b/olid/\(id)-L.jpg?default=false")!
            self.thumbnail = URL(string: "https://covers.openlibrary.org/b/olid/\(id)-S.jpg?default=false")!
        }
    }
}
