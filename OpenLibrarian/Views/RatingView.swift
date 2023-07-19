//
//  RatingView.swift
//  OpenLibrarian
//
//  Created by Sean Molenaar on 19/07/2023.
//

import SwiftUI
import OpenLibraryKit

struct RatingView: View {
    @State var book: CollectionItem
    @State var rating: BookRating?

    var body: some View {
        StarsView(maxRating: 5, rating: rating?.summary.average ?? 0)
            .frame(width: 100, height: 20)
            .task {
                let ratingInfo = try? await OpenLibraryKit().books().ratings(id: book.workId)
                if let rating = ratingInfo {
                    self.rating = rating
                }
            }
    }
}
//
//#Preview {
//    RatingView()
//}
