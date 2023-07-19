//
//  LibraryView.swift
//  OpenLibrarian
//
//  Created by Sean Molenaar on 19/07/2023.
//

import SwiftUI

struct LibraryView: View {
    @State private var selectedType: String = ReadingLogType.wanted.rawValue

    var body: some View {
        VStack {

            if selectedType == ReadingLogType.wanted.rawValue {
                CollectionView(type: ReadingLogType.wanted)
            } else if selectedType == ReadingLogType.reading.rawValue {
                CollectionView(type: ReadingLogType.reading)
            } else if selectedType == ReadingLogType.read.rawValue {
                CollectionView(type: ReadingLogType.read)
            }
        }.toolbar  {
            Picker("Info", selection: $selectedType) {
                ForEach(ReadingLogType.allCases, id: \.rawValue) {
                    Text($0.rawValue)
                }
            }
        }
    }
}

#Preview {
    LibraryView()
}
