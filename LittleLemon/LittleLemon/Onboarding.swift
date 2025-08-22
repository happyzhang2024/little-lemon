//
//  Onboarding.swift
//  Little Lemon
//
//  Created by 化石星星的橡木盾 on 8/2/25.
//


import SwiftUI

let kFirstName = "first_name_key"
let kLastName = "last_name_key"
let kEmail = "email_key"
let kPhone = "phone_key"
let kIsLoggedIn = "kIsLoggedIn"

let kOrderStatus = "notifyOrderStatus_key"
let kPasswordChanges = "notifyPasswordChanges_key"
let kSpecialOffers = "notifySpecialOffers_key"
let kNewsletter = "notifyNewsletter_key"

let kProfileImage = "profileImage_key"

struct Onboarding: View {
    @AppStorage(kIsLoggedIn) private var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("Logo")
                    .cornerRadius(8)

                VStack(alignment: .leading, spacing: 0) {
                    Text("Little Lemon")
                        .appFont(.display)
                        .foregroundColor(.primary2)
                    
                    HeroView()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .background(Color("Primary 1"))
                .frame(maxWidth: .infinity, alignment: .top)
                .ignoresSafeArea(edges: .top)
                
                RegisterView()
                Spacer()
                
            }
        }
    }
}

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
}

enum FontDumper {
    static func print(_ keyword: String? = nil) {
        for family in UIFont.familyNames.sorted() {
            if let k = keyword, !family.localizedCaseInsensitiveContains(k) { continue }
            Swift.print("▶︎ \(family)")
            for name in UIFont.fontNames(forFamilyName: family).sorted() {
                Swift.print("   - \(name)")
            }
        }
    }
}

struct RegisterView: View {
    @AppStorage(kIsLoggedIn) private var isLoggedIn: Bool = true
    
    @AppStorage(kFirstName) private var firstName: String = ""
    @AppStorage(kLastName) private var lastName: String = ""
    @AppStorage(kEmail) private var email: String = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    
    var body: some View {
        VStack {
            Text("Name*")
                .frame(maxWidth: .infinity, alignment: .leading)
                .appFont(.categories)
            TextField("Name", text: $firstName)
                .textFieldStyle(.roundedBorder)
                .appFont(.categories)
            /*
            Text("Last Name*")
                .frame(maxWidth: .infinity, alignment: .leading)
                .appFont(.categories)
            
            TextField("Last Name", text: $lastName)
                //.textFieldStyle(.roundedBorder)
                .appFont(.categories)
            */
            Text("Email*")
                .frame(maxWidth: .infinity, alignment: .leading)
                .appFont(.categories)
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .appFont(.categories)
            
            Button("Next") {
                guard !firstName.isEmpty, !email.isEmpty else {
                    alertMessage = "Fields must not be empty"
                    showAlert = true
                    return
                }
                guard isValidEmail(email) else {
                    alertMessage = "Invalid email format"
                    showAlert = true
                    return
                }
                isLoggedIn = true
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical,12)
            .foregroundColor(.white)
            .background(Color("Primary 1"))
            .appFont(.cardTitle)
            .cornerRadius(8)
            .controlSize(.large)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .top)
        .ignoresSafeArea(edges: .top)
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}

#Preview {
    Onboarding()
}
