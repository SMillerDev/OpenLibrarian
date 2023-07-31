//
//  LibraryView.swift
//  OpenBook
//
//  Created by Sean Molenaar on 19/07/2023.
//

import SwiftUI
import OpenLibraryKit

struct LibraryView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("username") var username: String?
    @State private var selectedType: String = ReadingLogType.wanted.rawValue
    let api: OpenLibraryKit = OpenLibraryKit()

    var body: some View {
        VStack {
            Picker("Info", selection: $selectedType) {
                ForEach(ReadingLogType.allCases, id: \.rawValue) {
                    Text($0.rawValue)
                }
            }.pickerStyle(.segmented)
                .padding()
            if selectedType == ReadingLogType.wanted.rawValue {
                CollectionView(type: ReadingLogType.wanted)
            } else if selectedType == ReadingLogType.reading.rawValue {
                CollectionView(type: ReadingLogType.reading)
            } else if selectedType == ReadingLogType.read.rawValue {
                CollectionView(type: ReadingLogType.read)
            }
        }.refreshable {
            await refreshLibrary()
        }.onChange(of: username) {
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

        let read = try? await api.myBooks.read(user: user)
        read?.forEach { book in
            if let _ = book.loggedEdition {
                returnItems.append(CollectionItem(entry: book, type: .read))
            }
        }
        let wanted = try? await api.myBooks.wanted(user: user)
        wanted?.forEach { book in
            if let _ = book.loggedEdition {
                returnItems.append(CollectionItem(entry: book, type: .wanted))
            }
        }
        let reading = try? await api.myBooks.reading(user: user)
        reading?.forEach { book in
            if let _ = book.loggedEdition {
                returnItems.append(CollectionItem(entry: book, type: .reading))
            }
        }

        returnItems.forEach { item in
            modelContext.insert(item)
        }
    }
}

#Preview {
    LibraryView().modelContainer(for: CollectionItem.self, inMemory: true)
}
