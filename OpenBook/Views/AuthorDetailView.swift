//
//  AuthorView.swift
//  OpenBook
//
//  Created by Sean Molenaar on 18/06/2023.
//

import SwiftUI
import OpenLibraryKit

struct AuthorDetailView: View {
    let author: Author
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://covers.openlibrary.org/a/olid/\(author.olid)-M.jpg")!)
                HStack {
                    Text(author.title ?? "")
                    Text(author.name).font(.title)
                }
                if let date = author.birthDate {
                    HStack {
                        Text("Born on:")
                        Text(date)
                    }
                }

                if let links = author.links {
                    VStack(alignment: .leading) {
                        Text("Links:")
                        if let wiki = author.wikipedia {
                            Link(destination: wiki, label: {
                                Label("wikipedia", systemImage: "globe")
                            })
                        }
                        ForEach(links, id: \.url) { link in
                            Link(destination: link.url, label: {
                                Label(link.title ?? link.url.absoluteString, systemImage: "globe")
                            })
                        }
                    }
                }

//                if let bio = author.bio, let bioString = bio.string  {
//                    Text(bio)
//                }
                if let desc = author.bio as? String {
                    Text(desc)
                        .padding()
                } else if let obj = author.bio as? StringValue, let desc = obj.value {
                    Text(desc)
                        .padding()
                }
                if let names = author.alternateNames {
                    VStack {
                        Text("Also known as:")
                        List(names, id: \.self) { name in
                            Text(name)
                        }
                    }
                }
            }
        }.toolbar {
            ShareLink(item: URL(string: "https://openlibrary.org/authors/\(author.olid)")!, subject: Text(author.name))
        }
    }
}
