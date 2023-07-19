//
//  OpenLibrarianApp.swift
//  OpenLibrarian
//
//  Created by Sean Molenaar on 14/06/2023.
//

import SwiftUI
import SwiftData

@main
struct OpenLibrarianApp: App {
    

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: CollectionItem.self)
    }
}
