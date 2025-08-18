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
    @State var isLoggedIn = false
    
    
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
                
                RegisterView(isLoggedIn: $isLoggedIn)
                Spacer()
                
            }
            .onAppear(){
                isLoggedIn = UserDefaults.standard.bool(forKey: kIsLoggedIn)
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                Home()
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
    @Binding var isLoggedIn: Bool
    
    @AppStorage(kFirstName) private var firstNameStored: String = ""
    @AppStorage(kLastName) private var lastNameStored: String = ""
    @AppStorage(kEmail) private var emailStored: String = ""
    
    @State var firstName = ""
    @State var lastName = ""
    @State var email = ""
    
    var body: some View {
        VStack {
            Text("First Name*")
                .frame(maxWidth: .infinity, alignment: .leading)
                .appFont(.categories)
            TextField("First Name", text: $firstName)
                .textFieldStyle(.roundedBorder)
                .appFont(.categories)
            
            Text("Last Name*")
                .frame(maxWidth: .infinity, alignment: .leading)
                .appFont(.categories)
            
            TextField("Last Name", text: $lastName)
                .textFieldStyle(.roundedBorder)
                .appFont(.categories)
            
            Text("Email*")
                .frame(maxWidth: .infinity, alignment: .leading)
                .appFont(.categories)
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .appFont(.categories)
            
            Button("Register") {
                guard !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty else {
                    print("Fields must not be empty"); return
                }
                guard isValidEmail(email) else {
                    print("Invalid email format"); return
                }
                firstNameStored = firstName
                lastNameStored = lastName
                emailStored = email
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
    }
}

#Preview {
    Onboarding()
}
