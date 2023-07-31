//
//  SearchSection.swift
//  OpenBook
//
//  Created by Sean Molenaar on 21/07/2023.
//

import SwiftUI
import OpenLibraryKit

struct SearchSection: View {
    @State var searchText: String = ""
    @State var results: [SearchResult] = []
    @State var task: Task<Void, Never>? = nil  // reference to the task
    
    let api: OpenLibraryKit = OpenLibraryKit()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Search")
                .font(.title)
                .padding()
            TextField("Search", text: $searchText, prompt: Text("Search for books"))
                .autocorrectionDisabled()
                .textContentType(.none)
                .backgroundStyle(.gray)
                .padding()
            if !results.isEmpty {
                Divider()
            }
            List {
                ForEach(results, id: \.key) { result in
                    NavigationLink {
                        BookView(work: result.olid)
                    } label: {
                        CollectionItemListView(result)
                    }
                }
            }.frame(height: results.isEmpty ? 0 : 300)
                .listStyle(.plain)
            Divider()
        }
        .onChange(of: searchText) {
            self.task?.cancel()
            if searchText.isEmpty || searchText.count < 3 {
                results = []
                return
            }
            self.task = Task {
                let searchResults = try? await api.search.search(searchText)
                if let results = searchResults, !Task.isCancelled {
                    print("\(results.count) search results")
                    self.results = results
                }
            }
        }
    }
}

#Preview {
    SearchSection()
}
