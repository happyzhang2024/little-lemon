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
let kIsLoggedIn = "kIsLoggedIn"

struct Onboarding: View {
    @State var firstName = ""
    @State var lastName = ""
    @State var email = ""
    @State var isLoggedIn = false
    
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("First Name", text: $firstName)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                
                Button("Register") {
                    if !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty {
                        if isValidEmail(email) {
                            UserDefaults.standard.set(firstName, forKey: kFirstName)
                            UserDefaults.standard.set(lastName, forKey: kLastName)
                            UserDefaults.standard.set(email, forKey: kEmail)
                            UserDefaults.standard.set(true, forKey: kIsLoggedIn)
                            isLoggedIn = true
                        } else {
                            print("Invalid email format")
                        }
                    } else {
                        print("Fields must not be empty")
                    }
                }
                .padding()
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

#Preview {
    Onboarding()
}
