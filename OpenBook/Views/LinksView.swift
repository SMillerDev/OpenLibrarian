//
//  LinksView.swift
//  OpenBook
//
//  Created by Sean Molenaar on 30/07/2023.
//

import SwiftUI
import OpenLibraryKit

struct LinksView: View {
    @State var links: [LinkItem] = []
    var body: some View {
        List(links, id: \.url) { link in
            if let title = link.title {
                Link(destination: link.url, label: { Label(title, systemImage: "globe") })
            }
        }
    }
}
