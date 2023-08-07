//
//  ReadingStatsSection.swift
//  OpenBook
//
//  Created by Sean Molenaar on 30/07/2023.
//

import SwiftUI
import OpenLibraryKit

struct ReadingStatsSection: View {
    let api: OpenLibraryKit = OpenLibraryKit.shared
    let id: OpenLibraryID
    @State var shelves: Dictionary<String, Int> = Dictionary()

    var body: some View {
        VStack {
            if !shelves.isEmpty {
                Text("\(shelves["wanted"]!) people want to read this")
                Text("\(shelves["reading"]!) people are reading this")
                Text("\(shelves["read"]!) people have read this")
            }
        }.padding()
        .onAppear {
            Task {
                guard let shelves = try? await api.books.shelves(id: id) else {
                    print("❌ failed to get shelves!")
                    return
                }
                debugPrint(shelves.counts)
                self.shelves["wanted"] = shelves.counts.wantToRead
                self.shelves["reading"] = shelves.counts.currentlyReading
                self.shelves["read"] = shelves.counts.alreadyRead
            }
        }

    }
}
