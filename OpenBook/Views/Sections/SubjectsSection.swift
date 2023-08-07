//
//  SubjectsSection.swift
//  OpenBook
//
//  Created by Sean Molenaar on 20/07/2023.
//

import SwiftUI
import OpenLibraryKit

struct SubjectsSection: View {
    let subject: String
    let api: OpenLibraryKit = OpenLibraryKit.shared
    @State var items: [SubjectWork] = []

    var body: some View {
        VStack(alignment: .leading) {
            Text(subject.capitalized)
                .font(.title)
                .padding()
            ScrollView(.horizontal) {
                HStack {
                    ForEach(items, id: \.key) { item in
                        NavigationLink {
                            BookDetailView(work: item.olid).navigationTitle(item.title)
                        } label: {
                            DiscoveryListItemView(work: item)
                        }
                    }
                }
            }.padding(20)
        }.onAppear {
            Task {
                if let subjectInfo = try? await api.subjects.subject(subject) {
                    print("\(subjectInfo.workCount) \(subject) items")
                    self.items = subjectInfo.works
                }
            }
        }
    }
}

#Preview {
    SubjectsSection(subject: "romance")
}
