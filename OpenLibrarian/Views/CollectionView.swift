//
//  CollectionView.swift
//  OpenLibrarian
//
//  Created by Sean Molenaar on 21/06/2023.
//

import SwiftUI
import SwiftData

struct CollectionView: View {
    @Query private var items: [CollectionItem]

    init(type: ReadingLogType) {
        let typeString = type.rawValue
        var upcomingTrips = FetchDescriptor<CollectionItem>(predicate: #Predicate { $0.type == typeString })
        upcomingTrips.includePendingChanges = true
        _items = Query(upcomingTrips)
    }

    var body: some View {
        VStack(alignment: .center) {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        BookView(book: item)
                    } label: {
                        CollectionItemListView(item, thumbnail: true)
                    }
                }
            }
        }
    }
}
