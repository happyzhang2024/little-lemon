//
//  Home.swift
//  Little Lemon
//
//  Created by 化石星星的橡木盾 on 8/3/25.
//

import SwiftUI

struct Home: View {
    var body: some View {
        TabView {
            Menu()
                .tabItem({
                    Label("Menu", systemImage: "list.dash")
                })
            UserProfile()
                .tabItem {
                    Label("Profile", systemImage: "square.and.pencil")
                }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    Home()
}
