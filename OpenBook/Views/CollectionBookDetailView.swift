//
//  BookView.swift
//  OpenBook
//
//  Created by Sean Molenaar on 18/06/2023.
//

import SwiftUI
import OpenLibraryKit

struct CollectionBookDetailView: View {
    @Environment(\.managedObjectContext) var managedObjectContext

    @State var work: Work?
    @State var edition: Edition?
    @State var selectedType: String = ""
    @State var pageProgressText: String = ""
    @State var done: Int = 0
    @ObservedObject var item: CollectionItem
    let api: OpenLibraryKit = OpenLibraryKit.shared

    let id: String
    let editionId: String?
    let started: Date?
    let showBorrow: Bool
    let isReading: Bool
    let pageProgress: Int

    init(item: CollectionItem) {
        self.id = item.workId
        self.editionId = item.editionId
        self.started = item.start
        let selectedType = ReadingLogType(rawValue: item.type)
        self.showBorrow = selectedType == .wanted
        self.isReading = selectedType == .reading
        _selectedType = State(initialValue: selectedType?.rawValue ?? "")
        self.pageProgress = Int(truncating: item.progress ?? 0)
        self.item = item
    }

    var imageView: some View {
        Group {
            if let url = work?.getImage(size: "L", useDefault: false)
                ?? edition?.getImage(size: "L", useDefault: false) {
                AsyncImage(url: url)
                    .padding(0)
                if let pages = edition?.numberOfPages, isReading {
                    ProgressView(value: Float(pageProgress), total: Float(pages))
                }
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
                    let _ = debugPrint("Borrow")
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
                            if isReading {
                                TextField("page", text: $pageProgressText)
                                    .frame(maxWidth: 60)
                                Text("/")
                            }
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
        .onAppear {
            pageProgressText = "\(item.progress ?? 0)"
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
        }.onChange(of: pageProgressText) { text in
            if let number = Int(text) {
                item.progress = NSNumber(value: number)
                if number == edition?.numberOfPages {
                    done = 1
                    item.type = ReadingLogType.read.rawValue
                } else {
                    done = 0
                }
                try? managedObjectContext.save()
            }
        }.confettiCannon(counter: $done)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
    }
}
