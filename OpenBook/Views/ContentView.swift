//
//  ContentView.swift
//  OpenBook
//
//  Created by Sean Molenaar on 14/06/2023.
//

import SwiftUI
import SwiftData
import OpenLibraryKit

private enum NavigationTabs: Int {
    case library = 0
    case discover = 1
    case user = 2
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var modelContext
    @State var presentLogin: Bool = false
    @State var tab: Int = 0
    @State var pick: ReadingLogType = ReadingLogType.reading
    @State var navigationTitle = "Library"
    @AppStorage("username") var username: String?

    init() {
//        self.username = nil
    }

    var body: some View {
        NavigationStack {
            TabView(selection: $tab) {
                LibraryPage().navigationTitle("Library")
                .tabItem {
                    Label("Library", systemImage: "books.vertical")
                }.tag(0)
                DiscoverPage().navigationTitle("Discover")
                .tabItem {
                    Label("Discover", systemImage: "rectangle.and.text.magnifyingglass")
                }.tag(1)
                AccountPage().navigationTitle(username ?? "User")
                .tabItem {
                    Label(username ?? "User", systemImage: "person")
                }.tag(2)
            }.navigationTitle(navigationTitle)
        }.task {
            guard username != nil else {
                presentLogin.toggle()
                return
            }
        }.onChange(of: username, perform: { _ in
            presentLogin.toggle()
        })
        .onChange(of: tab, perform: { tab in
            switch tab {
            case NavigationTabs.library.rawValue:
                navigationTitle = "library".capitalized
            case NavigationTabs.discover.rawValue:
                navigationTitle = "discover".capitalized
            case NavigationTabs.user.rawValue:
                navigationTitle = username ?? "user".capitalized
            default:
                navigationTitle = "????"
            }

        }).sheet(isPresented: $presentLogin) {
            LoginSheet()
        }
    }

    public func toggleLogin() {
        presentLogin.toggle()
    }
}

// #Preview {
//    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
// }
