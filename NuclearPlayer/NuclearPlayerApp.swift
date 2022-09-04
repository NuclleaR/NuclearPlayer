//
//  NuclearPlayerApp.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 30.08.2022.
//

import SwiftUI

// TODO move core data logic too class
// TODO Create view model to handle import from different places
// TODO search for core data listener to refresh library after import
// TODO Check if file exists before play

@main
struct NuclearPlayerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
