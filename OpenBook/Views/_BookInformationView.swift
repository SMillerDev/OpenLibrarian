//
//  BookInformationView.swift
//  OpenBook
//
//  Created by Sean Molenaar on 30/07/2023.
//

import OpenLibraryKit
import SwiftUI

private struct BookInformationView: View {
    let authors: [TypeClass]
    let pages: Int?
    let started: Date?
    @State var pageProgress: Int?

    init(authors: [TypeClass], pages: Int?, started: Date?, pageProgress: Int) {
        self.authors = authors
        self.pages = pages
        self.started = started
        self.pageProgress = pageProgress
    }

    var body: some View {
        Text("a")
    }
}
