//
//  LibraryView.swift
//  OpenBook
//
//  Created by Sean Molenaar on 19/07/2023.
//

import SwiftUI
import OpenLibraryKit
import CoreData

struct LibraryPage: View {
    @AppStorage("username") var username: String?
    @State private var selectedType: String = ReadingLogType.wanted.rawValue
    let api: OpenLibraryKit = OpenLibraryKit.shared

    var body: some View {
        VStack {
            Picker("Info", selection: $selectedType) {
                ForEach(ReadingLogType.allCases, id: \.rawValue) {
                    Text($0.rawValue)
                }
            }.pickerStyle(.segmented)
            .padding()
            if selectedType == ReadingLogType.wanted.rawValue {
                CollectionShelveSection(type: ReadingLogType.wanted)
            } else if selectedType == ReadingLogType.reading.rawValue {
                CollectionShelveSection(type: ReadingLogType.reading)
            } else if selectedType == ReadingLogType.read.rawValue {
                CollectionShelveSection(type: ReadingLogType.read)
            }
        }.refreshable {
            await refreshLibrary()
        }.onChange(of: username) { _ in
            Task(priority: .background) {
                await refreshLibrary()
            }
        }
    }

    public func refreshLibrary() async {
        guard let user = username else {
            return
        }
        var returnItems: [CollectionItem] = []
        let moc = PersistenceController.shared.container.newBackgroundContext()

        let read = try? await api.myBooks.read(user: user)
        read?.forEach { book in
            if book.loggedEdition != nil {
                returnItems.append(CollectionItem(moc, entry: book, type: .read))
            }
        }
        let wanted = try? await api.myBooks.wanted(user: user)
        wanted?.forEach { book in
            if book.loggedEdition != nil {
                returnItems.append(CollectionItem(moc, entry: book, type: .wanted))
            }
        }
        let reading = try? await api.myBooks.reading(user: user)
        reading?.forEach { book in
            if book.loggedEdition != nil {
                returnItems.append(CollectionItem(moc, entry: book, type: .reading))
            }
        }

        let fetchRequest: NSFetchRequest = CollectionItem.fetchRequest()

        returnItems.forEach { item in
            fetchRequest.predicate = NSPredicate(format: "editionId == %@", item.editionId)
            guard let existing = try? moc.fetch(fetchRequest).first as? CollectionItem else {
                moc.insert(item)
                return
            }
            existing.title = item.title
        }
        try? moc.save()
    }
}

#Preview {
    LibraryPage()
}
