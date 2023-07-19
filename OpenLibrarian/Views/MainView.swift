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
    case discover = 1
    case user = 2
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
                LibraryView()
                .tabItem {
                    Label("Library", systemImage: "books.vertical")
                }.tag(0)
                DiscoverView(searchText: "")
                .tabItem {
                    Label("Discover", systemImage: "rectangle.and.text.magnifyingglass")
                }.tag(1)
                AccountView()
                .tabItem {
                    Label(username ?? "User", systemImage: "person")
                }.tag(2)
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
            case NavigationTabs.discover.rawValue:
                navigationTitle = "discover".capitalized
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