//
//  LibraryRepository.swift
//  OpenLibrarian
//
//  Created by Sean Molenaar on 21/06/2023.
//

import SwiftData
import OpenLibraryKit

struct LibraryRepository {
    public func refreshLibrary(username: String?) async -> [CollectionItem] {
        guard let user = username else {
            return []
        }
        var returnItems: [CollectionItem] = []

        let read = try? await OpenLibraryKit().myBooks().read(user: user)
        read?.forEach { book in
            returnItems.append(CollectionItem(entry: book, type: .read))
        }
        let wanted = try? await OpenLibraryKit().myBooks().wanted(user: user)
        wanted?.forEach { book in
            returnItems.append(CollectionItem(entry: book, type: .wanted))
        }
        let reading = try? await OpenLibraryKit().myBooks().reading(user: user)
        reading?.forEach { book in
            returnItems.append(CollectionItem(entry: book, type: .reading))
        }

        return returnItems
    }
}
