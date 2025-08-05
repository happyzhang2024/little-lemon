//
//  Little_LemonApp.swift
//  Little Lemon
//
//  Created by 化石星星的橡木盾 on 7/29/25.
//

import SwiftUI

@main
struct Little_LemonApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            Onboarding()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
