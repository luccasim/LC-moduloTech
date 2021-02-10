//
//  LC_moduloTechApp.swift
//  LC-moduloTech
//
//  Created by owee on 10/02/2021.
//

import SwiftUI

@main
struct LC_moduloTechApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
