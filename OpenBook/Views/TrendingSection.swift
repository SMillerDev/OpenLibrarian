//
//  TrendingSection.swift
//  OpenBook
//
//  Created by Sean Molenaar on 20/07/2023.
//

import SwiftUI
import OpenLibraryKit

struct TrendingSection: View {
    @State var items: [TrendingItem] = []
    let api: OpenLibraryKit = OpenLibraryKit()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Popular today")
                .font(.title)
                .padding()
            ScrollView(.horizontal) {
                HStack {
                    ForEach(items, id: \.key) { item in
                        NavigationLink {
                            BookView(work: item.olid)
                        } label: {
                            DiscoveryListItemView(trendingItem: item)
                        }
                    }
                }
            }.padding(20)
        }.task {
            if let trending = try? await api.trending.trending(.daily) {
                print("\(trending.count) popular daily items")
                self.items = Array(trending[0...10])
            }
        }
    }
}

#Preview {
    TrendingSection()
}
