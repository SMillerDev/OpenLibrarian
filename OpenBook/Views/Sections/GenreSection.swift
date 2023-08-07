//
//  GenresView.swift
//  OpenBook
//
//  Created by Sean Molenaar on 30/07/2023.
//

import SwiftUI

struct GenreSection: View {
    @State var genres: [String] = []
    var body: some View {
        List(genres, id: \.self) { genre in
            Text(genre)
        }
    }
}
