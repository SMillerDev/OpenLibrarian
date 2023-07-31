//
//  BookView.swift
//  OpenBook
//
//  Created by Sean Molenaar on 18/06/2023.
//

import SwiftUI
import OpenLibraryKit

struct BookView: View {
    @State var work: Work? = nil
    @State var edition: Edition? = nil
    @State var selectedType: String = ""
    @State var pageProgressText: String = ""
    @ObservedObject var item: CollectionItem
    let api: OpenLibraryKit = OpenLibraryKit()

    let id: String
    let editionId: String?
    let started: Date?
    let showBorrow: Bool
    let isReading: Bool
    let pageProgress: Int

    init(item: CollectionItem) {
        self.init(work: item.workId, edition: item.editionId, started: item.start, selectedType: ReadingLogType(rawValue: item.type), pageProgress: item.progress ?? 0)
        self.item = item
    }

    init(work: String, edition: String? = nil, started: Date? = nil, selectedType: ReadingLogType? = nil, pageProgress: Int = 0) {
        self.id = work
        self.editionId = edition
        self.started = started
        self.showBorrow = (selectedType == nil || selectedType == .wanted)
        self.isReading = selectedType == .reading
        _selectedType = State(initialValue: selectedType?.rawValue ?? "")
        self.pageProgress = pageProgress
        self.item = CollectionItem(workId: work, editionId: edition!, title: "", type: selectedType!)
    }

    var imageView: some View {
        Group {
            if let url = work?.getImage(size: "L", useDefault: false) ?? edition?.getImage(size: "L", useDefault: false) {
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

    var authorView: some View {
        HStack {
            if let authors = edition?.authors, !authors.isEmpty {
                
                Label("By: ", systemImage: "person")
                ForEach(authors, id: \.key) { author in
                    Text(author.key)
                        .textContentType(.name)
                }.padding(5)
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack {
                self.imageView
                self.typeSelector
                VStack(alignment: .leading) {
                    self.authorView
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
                RatingView(workId: id)
//                ReviewView()
                Divider()
                GenreView(genres: work?.subjects ?? [])
                if let links = work?.links {
                    LinksView(links: links)
                }
            }
        }.toolbar {
            if let editionId = editionId {
                ShareLink(item: URL(string: "https://openlibrary.org/books/\(editionId)")!)
            } else {
                ShareLink(item: URL(string: "https://openlibrary.org/works/\(id)")!)
            }
        }
        .navigationTitle(edition?.title ?? work?.title ?? "")
        .onChange(of: selectedType) {
            var shelveId: BookShelveId = .wantToRead
            if selectedType == ReadingLogType.reading.rawValue {
                shelveId = .reading
            } else if selectedType == ReadingLogType.read.rawValue {
                shelveId = .read
            }
            debugPrint("Switched to shelve: \(selectedType)")
            Task {
                try await OpenLibraryKit().books.setShelve(id: id, shelf: shelveId)
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
        }.onChange(of: pageProgressText) {
            let _ = debugPrint(pageProgressText)
        }
    }
}
