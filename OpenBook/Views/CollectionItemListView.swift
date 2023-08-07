//
//  CollectionItemView.swift
//  OpenBook
//
//  Created by Sean Molenaar on 21/06/2023.
//

import SwiftUI
import OpenLibraryKit

struct CollectionItemListView: View {
    let title: String
    let authors: Set<String>
    let image: URL?

    init(_ item: CollectionItem, thumbnail: Bool = false) {
        self.init(title: item.title,
                  authors: item.authorNames ?? Set(),
                  image: thumbnail ? item.thumbnail : item.cover)
    }

    init(_ item: SearchResult) {
        let id = item.coverId ?? 0
        self.init(title: item.title,
                  authors: Set(item.authors ?? []),
                  image: URL(string: "https://covers.openlibrary.org/b/id/\(id)-S.jpg?default=true"))
    }

    init (title: String, authors: Set<String>, image: URL?) {
        self.title = title
        self.authors = authors
        self.image = image
    }

    var body: some View {
        HStack(alignment: .center) {
            ZStack {
                AsyncImage(url: image) { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFit()
                    } else if phase.error != nil {
                        Color.red.opacity(0.2) // Indicates an error.
                    } else {
                        Color.gray.opacity(0.2) // Acts as a placeholder.
                    }
                }
                .shadow(radius: 3)
            }.frame(width: 60, height: 60, alignment: .center)

            VStack(alignment: .leading) {
                Text(title)
                    .bold()
                    .lineLimit(1)
                Text(authors.joined(separator: ", "))
                    .font(.subheadline)
                    .lineLimit(1)
            }
        }
    }
}

#Preview {
    CollectionItemListView(title: "Hitchhiker's guide to the galaxy",
                       authors: ["Douglas Adams"],
                       image: URL(string: "https://covers.openlibrary.org/b/olid/OL27273349M-L.jpg?default=false"))
}
