//
//  UserProfile.swift
//  Little Lemon
//
//  Created by 化石星星的橡木盾 on 8/4/25.
//

import SwiftUI

struct UserProfile: View {
    @State private var firstName = UserDefaults.standard.string(forKey: "first_name_key")
    @State private var lastName = UserDefaults.standard.string(forKey: "last_name_key")
    @State private var email = UserDefaults.standard.string(forKey: "email_key")
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack {
            Text("Personal information")
            Image("profile-image-placeholder")
            Text("\(firstName ?? "")")
            Text("\(lastName ?? "")")
            Text("\(email ?? "")")
            Button("Logout") {
                UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                self.presentation.wrappedValue.dismiss()
            }
            Spacer()
        }
    }
}

#Preview {
    UserProfile()
}
