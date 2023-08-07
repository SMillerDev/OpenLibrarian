//
//  CollectionView.swift
//  OpenBook
//
//  Created by Sean Molenaar on 21/06/2023.
//

import SwiftUI
import CoreData
import ConfettiSwiftUI

struct CollectionShelveSection: View {
    @FetchRequest var items: FetchedResults<CollectionItem>
    let type: ReadingLogType

    init(type: ReadingLogType) {
        _items = FetchRequest<CollectionItem>(sortDescriptors: [SortDescriptor(\.title)],
                              predicate: NSPredicate(format: "type == %@", argumentArray: [type.rawValue]) )
        self.type = type
    }

    var body: some View {
        VStack(alignment: .center) {
            Text("\(items.count) \(type.rawValue) items").font(.footnote).foregroundStyle(.gray)
            List {
                ForEach(items, id: \.objectID) { item in
                    NavigationLink {
                        CollectionBookDetailView(item: item).navigationTitle(item.title)
                    } label: {
                        CollectionItemListView(item, thumbnail: true)
                    }
                }
            }.listStyle(.plain)
            .overlay(Group {
                if items.isEmpty {
                    Text("Nothing on your \(type.rawValue) list...")
                }
            })
        }
    }
}
