//
//  DiscoveryListItemView.swift
//  OpenBook
//
//  Created by Sean Molenaar on 22/07/2023.
//

import SwiftUI
import OpenLibraryKit

struct DiscoveryListItemView: View {
    let coverId: Int
    let title: String

    init(work: SubjectWork) {
        self.coverId = work.coverId
        self.title = work.title
    }

    init(trendingItem: TrendingItem) {
        self.coverId = trendingItem.coverId ?? 0
        self.title = trendingItem.title
    }

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "https://covers.openlibrary.org/b/id/\(coverId)-M.jpg?default=true")) { phase in
                if let image = phase.image {
                    image.resizable().scaledToFit().cornerRadius(12)
                } else if phase.error != nil {
                    Color.red.opacity(0.2) // Indicates an error.
                } else {
                    Color.gray.opacity(0.2) // Acts as a placeholder.
                }
            }.frame(width: 100, height: 150, alignment: .bottom)
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.black)
                .frame(maxWidth: 100)
        }.padding([.leading, .trailing], 10)
    }
}
