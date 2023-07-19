//
//  BookView.swift
//  OpenLibrarian
//
//  Created by Sean Molenaar on 18/06/2023.
//

import SwiftUI
import OpenLibraryKit

struct BookView: View {
    let book: CollectionItem
    @State var bookDescription: String = ""

    init(book: CollectionItem) {
        self.book = book
    }

    var body: some View {
        ScrollView {
            VStack {
                if let url = book.cover {
                    AsyncImage(url: url, scale: 1).padding(0)
                }
                HStack {
                    Text("By: ")
                    ForEach(book.authorNames, id: \.self) { author in
                        Text(author)
                    }
                }
                if let start = book.start {
                    Text("Added on \(start, format: .dateTime)")
                }
                Text(bookDescription)
//                GenreView()
                RatingView(book: book)
//                ReviewView()
            }
        }.navigationTitle(book.title)
            .navigationBarTitleDisplayMode(.automatic)
            .task {
                let workInfo = try? await OpenLibraryKit().books().work(id: book.workId)
                if let desc = workInfo?.bookDescription {
                    debugPrint(desc)
                    bookDescription = desc
                }
                let editionInfo = try? await OpenLibraryKit().books().edition(id: book.edition)
                if let notes = editionInfo?.notes {
                    debugPrint(notes)
                }
            }
    }
}
