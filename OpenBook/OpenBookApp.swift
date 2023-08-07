//
//  OpenBookApp.swift
//  OpenBook
//
//  Created by Sean Molenaar on 14/06/2023.
//

import SwiftUI

@main
struct OpenBookApp: App {
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
