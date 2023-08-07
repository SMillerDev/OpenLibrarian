//
//  BookView.swift
//  OpenBook
//
//  Created by Sean Molenaar on 18/06/2023.
//

import SwiftUI
import OpenLibraryKit

struct BookDetailView: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @State var work: Work?
    @State var edition: Edition?
    @State var selectedType: String = ""
    let api: OpenLibraryKit = OpenLibraryKit.shared

    let id: String
    let editionId: String?
    let started: Date?
    let showBorrow: Bool

    init(work: String,
         edition: String? = nil,
         started: Date? = nil,
         selectedType: ReadingLogType? = nil) {
        self.id = work
        self.editionId = edition
        self.started = started
        self.showBorrow = (selectedType == nil || selectedType == .wanted)
        _selectedType = State(initialValue: selectedType?.rawValue ?? "")
    }

    var imageView: some View {
        Group {
            if let url = edition?.getImage(size: "L", useDefault: false) ?? work?.getImage(size: "L", useDefault: false) {
                AsyncImage(url: url)
                    .padding(0)
            }
        }.padding(0)
    }

    var typeSelector: some View {
        HStack {
            Picker("List", selection: $selectedType) {
                Text("Pick a list").tag("")
                ForEach(ReadingLogType.allCases, id: \.rawValue) {
                    Text($0.rawValue)
                }
            }.pickerStyle(.menu)
            if showBorrow {
                Button("Borrow") {
                    let _ = debugPrint("Borrowed")
                }
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack {
                self.imageView
                self.typeSelector
                VStack(alignment: .leading) {
                    if let authors = edition?.authors ?? work?.authors.map({ $0.author }) {
                        AuthorSection(authors)
                    }
                    if let start = started {
                        HStack {
                            Label("Added on: ", systemImage: "clock")
                            Text("\(start, format: .dateTime)")
                                .textContentType(.dateTime)
                        }.padding(5)
                    }
                    if let pages = edition?.numberOfPages {
                        HStack {
                            Label("Pages: ", systemImage: "book")
                            Text(pages.description)
                                .textContentType(.none)
                        }.padding(5)
                    }
                }
                Divider().padding()
                if let excerpt = work?.excerpts?.first?.excerpt {
                    Text(excerpt)
                        .padding()
                }
                if let desc = work?.bookDescription as? String {
                    Text(desc)
                        .padding()
                } else if let obj = work?.bookDescription as? StringValue, let desc = obj.value {
                    Text(desc)
                        .padding()
                }
//                Divider()
//                ReadingStatsSection(id: id)
//                Divider()
                RatingSection(workId: id)
//                ReviewView()
                Divider()
                GenreSection(genres: work?.subjects ?? [])
                if let links = work?.links {
                    LinksSection(links: links)
                }
            }
        }.toolbar {
            if let editionId = editionId {
                ShareLink(item: URL(string: "https://openlibrary.org/books/\(editionId)")!)
            } else {
                ShareLink(item: URL(string: "https://openlibrary.org/works/\(id)")!)
            }
        }
        .onChange(of: selectedType) { selectedType in
            var shelveId: BookShelveId = .wantToRead
            if selectedType == ReadingLogType.reading.rawValue {
                shelveId = .reading
            } else if selectedType == ReadingLogType.read.rawValue {
                shelveId = .read
            }
            debugPrint("Switched to shelve: \(selectedType)")
            Task {
                if let editions = try? await api.books.editions(id: id),
                    let editionId = self.editionId ?? editions.first?.olid,
                    let editionTitle = self.edition?.title ?? editions.first?.title {
                    let item = CollectionItem(managedObjectContext,
                                   workId: id,
                                   editionId: editionId,
                                   title: editionTitle,
                                   type: ReadingLogType(rawValue: selectedType)!)
                    item.start = Date()
                    try? managedObjectContext.save()
                }
            }
            Task {
                try await api.books.setShelve(id: id, shelf: shelveId)
            }
        }
        .onAppear {
            guard let editionId = self.editionId else {
                return
            }
            Task {
                let editionInfo = try? await api.books.edition(id: editionId)
                if let edition = editionInfo {
                    self.edition = edition
                }
            }
        }
        .onAppear {
            Task {
                let workInfo = try? await api.books.work(id: id)
                if let work = workInfo {
                    self.work = work
                }
            }
        }.toolbar(.hidden, for: .tabBar)
    }
}
