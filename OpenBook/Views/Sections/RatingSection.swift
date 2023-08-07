//
//  RatingView.swift
//  OpenBook
//
//  Created by Sean Molenaar on 19/07/2023.
//

import SwiftUI
import OpenLibraryKit

struct RatingSection: View {
    let workId: OpenLibraryID
    let api: OpenLibraryKit = OpenLibraryKit.shared
    @State var rating: BookRating?

    var body: some View {
        HStack {
            if let rating = self.rating, let summary = rating.summary, summary.count > 0 {
                VStack {
                    StarsComponent(maxRating: 5, rating: summary.average ?? 0)
                        .frame(width: 150, height: 30)
                    Text("\(String(format: "%.1f", summary.average ?? 0)) stars")

                }
                Divider()
                VStack(alignment: .leading) {
                    ForEach((1...5).reversed(), id: \.self) { item in
                        HStack {
                            StarsComponent(maxRating: 5, rating: Double(item))
                                .frame(width: 80, height: 15)
                                .padding(0)
                            Text("\(rating.counts["\(item)"] ?? 0)")
                        }.padding(0)
                    }
                }
            }
        }
        .onAppear {
            Task {
                let ratingInfo = try? await api.books.ratings(id: workId)
                if let rating = ratingInfo {
                    self.rating = rating
                }
            }
        }
    }
}
//
//#Preview {
//    RatingView()
//}
