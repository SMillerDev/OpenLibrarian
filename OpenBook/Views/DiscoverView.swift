//
//  DiscoverView.swift
//  OpenBook
//
//  Created by Sean Molenaar on 19/07/2023.
//

import SwiftUI

struct DiscoverView: View {
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                SearchSection()
                TrendingSection()
                SubjectsSection(subject: "romance")
                SubjectsSection(subject: "detective")
            }
        }
    }
}

#Preview {
    DiscoverView()
}
