//
//  DiscoverView.swift
//  OpenBook
//
//  Created by Sean Molenaar on 19/07/2023.
//

import SwiftUI

struct DiscoverPage: View {
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
    DiscoverPage()
}
