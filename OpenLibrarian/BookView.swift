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
                    AsyncImage(url: url, scale: 1)
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
                StarsView(maxRating: 5, id: book.workId).frame(width: 100, height: 20)
                Text(bookDescription)
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

struct StarsView: View {
    @State var rating: Double = 0
    var maxRating: Int
    let id: String

    var body: some View {
        let stars = HStack(spacing: 0) {
            ForEach(0..<maxRating, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }

        stars.overlay(
            GeometryReader { g in
                let width = CGFloat(rating) / CGFloat(maxRating) * g.size.width
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: width)
                        .foregroundColor(.yellow)
                }
            }
            .mask(stars)
        )
        .foregroundColor(.gray)
        .task {
            let rating = try? await OpenLibraryKit().books().ratings(id: id)
            self.rating = rating?.summary.average ?? 0
        }
    }
}
