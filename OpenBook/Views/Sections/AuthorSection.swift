//
//  LinksView.swift
//  OpenBook
//
//  Created by Sean Molenaar on 30/07/2023.
//

import SwiftUI
import OpenLibraryKit

struct AuthorSection: View {
    let api: OpenLibraryKit = OpenLibraryKit.shared
    let authorKeys: [TypeClass]
    @State var authors: [Author] = []
    init(_ authors: [TypeClass] = []) {
        self.authorKeys = authors
    }
    var body: some View {
        HStack {
            if !authors.isEmpty {
                Label("By: ", systemImage: "person")
                ForEach(authors, id: \.olid) { author in
                    NavigationLink {
                        AuthorDetailView(author: author).navigationTitle(author.name)
                    } label: {
                        Text(author.name)
                            .textContentType(.name)
                    }

                }.padding(5)
            }
        }.onAppear {
            guard authors.isEmpty else {
                return
            }
            authorKeys.forEach { key in
                Task {
                    guard let author = try? await api.author.author(id: key.olid) else {
                        return
                    }
                    authors.append(author)
                }

            }
        }
    }
}
