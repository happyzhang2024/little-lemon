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
    
    @AppStorage(kIsLoggedIn) private var isLoggedIn: Bool = false

    init() {
            let ap = UITabBarAppearance()
            ap.configureWithOpaqueBackground()
            ap.backgroundColor = .systemBackground
            UITabBar.appearance().standardAppearance = ap
            UITabBar.appearance().scrollEdgeAppearance = ap  
        }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isLoggedIn {
                    NavigationStack { Home() }
                } else {
                    Onboarding()
                }
            }
            .id(isLoggedIn)
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

