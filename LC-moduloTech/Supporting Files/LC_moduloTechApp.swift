//
//  LC_moduloTechApp.swift
//  LC-moduloTech
//
//  Created by owee on 10/02/2021.
//

import SwiftUI

@main
struct LC_moduloTechApp: App {
    
    var persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView(MainUser: persistenceController.mainUser)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)

        }
    }
}
