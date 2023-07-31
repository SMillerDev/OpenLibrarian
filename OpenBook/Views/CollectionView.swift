//
//  CollectionView.swift
//  OpenBook
//
//  Created by Sean Molenaar on 21/06/2023.
//

import SwiftUI
import SwiftData

struct CollectionView: View {
    @Query private var items: [CollectionItem]
    let type: ReadingLogType

    init(type: ReadingLogType) {
        let typeString = type.rawValue
        var upcomingTrips = FetchDescriptor<CollectionItem>(predicate: #Predicate { $0.type == typeString })
        upcomingTrips.includePendingChanges = true
        _items = Query(upcomingTrips)
        self.type = type
    }

    var body: some View {
        VStack(alignment: .center) {
            List(items) { item in
                NavigationLink {
                    BookView(item: item)
                } label: {
                    CollectionItemListView(item, thumbnail: true)
                }
            }.listStyle(.plain)
        }
    }
}
