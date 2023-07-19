//
//  ContentView.swift
//  OpenLibrarian
//
//  Created by Sean Molenaar on 14/06/2023.
//

import SwiftUI
import SwiftData
import OpenLibraryKit

fileprivate enum NavigationTabs: Int {
    case library = 0
    case currentlyReading = 1
    case read = 2
    case user = 3
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State var presentLogin: Bool = false
    @State var tab: Int = 0
    @State var pick: ReadingLogType = ReadingLogType.reading
    @State var navigationTitle = "Library"
    @AppStorage("username") var username: String?

    let repository: LibraryRepository

    init() {
        repository = LibraryRepository()
    }

    var body: some View {
        NavigationView {
            TabView(selection: $tab) {
                CollectionView(type: ReadingLogType.wanted)
                    .tabItem {
                        Label("Library", systemImage: "books.vertical")
                    }.tag(0)
                CollectionView(type: ReadingLogType.reading)
                    .tabItem {
                        Label("Currently Reading", systemImage: "book")
                    }.tag(1)
                CollectionView(type: ReadingLogType.read)
                    .tabItem {
                        Label("Read", systemImage: "book.closed")
                    }.tag(2)
                HStack {
                    Text(username ?? "User")
                }.tabItem {
                    Label(username ?? "User", systemImage: "person")
                }.tag(3)
            }.navigationTitle(navigationTitle)
        }.task {
            guard username != nil else {
                presentLogin.toggle()
                return
            }
            await repository.refreshLibrary(username: username).forEach { item in
                modelContext.insert(item)
            }
        }.onChange(of: username) {
            Task(priority: .background) {
                await repository.refreshLibrary(username: username).forEach { item in
                    modelContext.insert(item)
                }
            }
            presentLogin.toggle()
        }
        .onChange(of: tab) {
            switch tab {
            case NavigationTabs.library.rawValue:
                navigationTitle = "library".capitalized
            case NavigationTabs.currentlyReading.rawValue:
                navigationTitle = "currently reading".capitalized
            case NavigationTabs.read.rawValue:
                navigationTitle = "read".capitalized
            case NavigationTabs.user.rawValue:
                navigationTitle = username?.capitalized ?? "user".capitalized
            default:
                navigationTitle = "????"
            }

        }.refreshable {
            await repository.refreshLibrary(username: username).forEach { item in
                modelContext.insert(item)
            }
        }.sheet(isPresented: $presentLogin) {
            LoginSheet()
        }
    }
    public func toggleLogin() {
        presentLogin.toggle()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: CollectionItem.self, inMemory: true)

}
