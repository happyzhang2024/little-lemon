//
//  Home.swift
//  Little Lemon
//
//  Created by 化石星星的橡木盾 on 8/3/25.
//

import SwiftUI
import CoreData

struct Home: View {
    let persistence = PersistenceController.shared
    
    @State private var showProfileOnLaunch = true
    @State private var showProfileSheet = true
    
    var body: some View {
        TabView {
            NavigationStack {
                Menu()
                    .toolbar(.hidden, for: .navigationBar)
            }
            .tabItem {Label("Menu", systemImage: "list.dash") }
            .navigationBarBackButtonHidden(true)

            NavigationStack {
                UserProfile()
            }
            .toolbar(.visible, for: .navigationBar)
            .toolbarTitleDisplayMode(.inline)
            .tabItem { Label("Profile", systemImage: "square.and.pencil") }
            
        }
        .sheet(isPresented: $showProfileSheet) {
            NavigationStack {
                UserProfile()
            }
            .toolbar(.visible, for: .navigationBar)
            .toolbarTitleDisplayMode(.inline)
        }
        .onAppear {
            showProfileOnLaunch = false
            showProfileSheet = true
        }
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color(.systemBackground), for: .tabBar)
    }
}

#Preview {
    Home()
}
