//
//  DiscoverView.swift
//  OpenLibrarian
//
//  Created by Sean Molenaar on 19/07/2023.
//

import SwiftUI

struct DiscoverView: View {
    @State var searchText: String = ""
    var body: some View {
        VStack{
            Text("Discover something")
            Form {
                TextField("Search", text: $searchText)
            }
        }
    }
}

#Preview {
    DiscoverView(searchText: "A")
}
