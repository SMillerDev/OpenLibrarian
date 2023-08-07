//
//  StarsView.swift
//  OpenBook
//
//  Created by Sean Molenaar on 19/07/2023.
//

import SwiftUI

struct StarsComponent: View {
    let maxRating: Int
    @State var rating: Double

    var body: some View {
        let stars = HStack(spacing: 0) {
            ForEach(0..<maxRating, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: -1)
            }
        }

        stars.overlay(
            GeometryReader { geo in
                let width = CGFloat(rating) / CGFloat(maxRating) * geo.size.width
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: width)
                        .foregroundColor(.yellow)
                }
            }
            .mask(stars)
        )
        .foregroundColor(.gray)
    }
}

#Preview {
    StarsComponent(maxRating: 5, rating: 4.5)
}
