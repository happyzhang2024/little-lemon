//
//  UserProfile.swift
//  Little Lemon
//
//  Created by 化石星星的橡木盾 on 8/4/25.
//

import SwiftUI
import PhotosUI

struct UserProfile: View {
    
    @AppStorage(kProfileImage) private var profileImageFilename: String?
    
    @AppStorage(kFirstName) private var firstNameStored: String = ""
    @AppStorage(kLastName) private var lastNameStored: String = ""
    @AppStorage(kEmail) private var emailStored: String = ""
    @AppStorage(kPhone) private var phoneStored: String = ""
    
    @AppStorage(kOrderStatus) private var orderStatusStored = false
    @AppStorage(kPasswordChanges) private var passwordChangesStored = false
    @AppStorage(kSpecialOffers) private var specialOffersStored = false
    @AppStorage(kNewsletter) private var newsletterStored = false
    
    @AppStorage(kIsLoggedIn) private var isLoggedIn = true
      
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    
    @State private var orderStatus = false
    @State private var passwordChanges = false
    @State private var specialOffers = false
    @State private var newsletter = false
    
    @State private var avatarImage: UIImage? = nil
    @State private var photoItem: PhotosPickerItem? = nil
    @State private var avatarRemoved = false

    @State private var showLogoutConfirm = false

    @Environment(\.dismiss) var dismiss
    
    @State private var showAlert = false
    @State private var showAlertMessage = ""
    
    var body: some View {
        VStack {
            ScrollView {
                Text("Personal information")
                    .appFont(.subtitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                //.padding(.bottom, 8)
                Text("Avatar")
                    .appFont(.paragraph)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                AvatarRow(
                    image: avatarPreviewImage,
                    onPick: { photoItem = $0 },
                    onRemove: {
                        avatarRemoved = true
                        avatarImage = nil
                    }
                )
                .padding(.horizontal)
                
                formFields
                
                EmailNotificationsSection(
                    orderStatus: $orderStatus,
                    passwordChanges: $passwordChanges,
                    specialOffers: $specialOffers,
                    newsletter: $newsletter
                )
                
                Button(role: .destructive) {
                    showLogoutConfirm = true
                } label: {
                    Text("Log out")
                        .appFont(.cardTitle)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.primary2)
                        .foregroundColor(Color("Secondary 4"))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.red.opacity(0.6), lineWidth: 1)
                        )
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                .alert("Log out?", isPresented: $showLogoutConfirm) {
                    Button("Cancel", role: .cancel) {}
                    Button("Log out", role: .destructive) { logout() }
                } message: {
                    Text("This will clear your profile data on this device.")
                }
                
                HStack(spacing: 12) {
                    Button("Discard changes") { reloadFromStorage() }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        //.background(Color.clear)
                        .foregroundColor(.secondary4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.secondary4, lineWidth: 1)
                        )
                    
                    Button("Save changes") { save() }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(isChanged ? Color("Primary 1") : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.secondary4, lineWidth: 1)
                        )
                        .foregroundColor(isChanged ? Color("Secondary 3") : Color("Secondary 4"))
                        .disabled(!isChanged)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                .appFont(.cardTitle)
            }
            .padding(.horizontal)
            .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 12) }
        }
        .toolbar { ProfileTitleBar { dismiss() } }
        .navigationTitle("")
        .toolbar(.visible, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onAppear{ reloadFromStorage() }
        .alert(showAlertMessage, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
        .onChange(of: photoItem) {
            guard let photoItem  else { return }
            Task {
                if let data = try? await photoItem.loadTransferable(type: Data.self),
                   let ui = UIImage(data: data) {
                    avatarRemoved = false
                    avatarImage = ui
                }
            }
        }
    }
    
    private var formFields: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading){
                Text("First name*")
                TextField("First name", text: $firstName)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.bottom, 8)
            VStack(alignment: .leading){
                Text("Last name*")
                TextField("Last name", text: $lastName)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.bottom, 8)

            VStack(alignment: .leading){
                Text("Email*")
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            .padding(.bottom, 8)

            VStack(alignment: .leading){
                Text("Phone number")
                TextField("Phone number", text: $phone)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
            }
            .padding(.bottom, 8)

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .appFont(.paragraph)
/*
        VStack(alignment: .leading, spacing: 12) {
                    field("First name*", text: $firstName)
                    field("Last name*",  text: $lastName)
                    VStack(alignment: .leading) {
                        Text("Email*")
                        TextField("Email", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .appFont(.paragraph)
 */
    }
/*
    private func field(_ label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(label)
            TextField(label, text: text)
                .textFieldStyle(.roundedBorder)
        }
    }
*/
    
    private func saveAvatarToDish(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.9) else { return nil }
        let filename = UUID().uuidString + ".jpg"
        do {
            try data.write(to: fileURL(for: filename), options: .atomic)
            return filename
        } catch {
            print("write image error:", error)
            return nil
        }
    }
    private func loadAvatarFromDisk() -> UIImage? {
        guard let name = profileImageFilename else { return nil }
        return UIImage(contentsOfFile: fileURL(for: name).path)
    }
    
    
    private var isChanged: Bool {
         let textChanged = firstName != firstNameStored
            || lastName != lastNameStored
            || email != emailStored
            || phone != phoneStored
        
        let diskData: Data? = profileImageFilename.flatMap { try? Data(contentsOf: fileURL(for: $0))}
        let newData: Data? = avatarImage?.jpegData(compressionQuality: 0.9)
        let avatarChanged = avatarRemoved || (newData != diskData)
        
        let notifyChanged = orderStatus != orderStatusStored
            || passwordChanges != passwordChangesStored
            || specialOffers != specialOffersStored
            || newsletter != newsletterStored
        
        return textChanged || avatarChanged || notifyChanged
     }
    
    private func logout() {
        if let old = profileImageFilename {
            try? FileManager.default.removeItem(at: fileURL(for: old))
        }
        profileImageFilename = nil

        firstNameStored = ""
        lastNameStored  = ""
        emailStored     = ""
        phoneStored     = ""

        orderStatusStored    = false
        passwordChangesStored = false
        specialOffersStored  = false
        newsletterStored     = false
        showLogoutConfirm    = true

        avatarRemoved = false
        avatarImage   = nil
        photoItem     = nil

        reloadFromStorage()
        
        DispatchQueue.main.async {
            isLoggedIn = false
        }
    }

    
    private func reloadFromStorage() {
        firstName = firstNameStored
        lastName = lastNameStored
        email = emailStored
        phone = phoneStored
        
        orderStatus = orderStatusStored
        passwordChanges = passwordChangesStored
        specialOffers = specialOffersStored
        newsletter = newsletterStored
        
        avatarImage = loadAvatarFromDisk()
    }
    
    private func save() {
        guard !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty else {
            showAlertMessage = "Required fields cannot be empty"
            showAlert = true
            return
        }
        guard isValidEmail(email) else {
            showAlert = true
            showAlertMessage = "Invalid email format"
            return }

        firstNameStored = firstName
        lastNameStored = lastName
        emailStored = email
        phoneStored = phone
        
        orderStatusStored = orderStatus
        passwordChangesStored = passwordChanges
        specialOffersStored = specialOffers
        newsletterStored = newsletter
        
        if avatarRemoved {
            if let old = profileImageFilename {
                try? FileManager.default.removeItem(at: fileURL(for: old))
            }
            profileImageFilename = nil
        } else if let img = avatarImage {
            if let old = profileImageFilename {
                try? FileManager.default.removeItem(at: fileURL(for: old))
            }
            profileImageFilename = saveAvatarToDish(img)
        }
    }
    
    private var documentsDir: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private func fileURL(for filename: String) -> URL {
        documentsDir.appendingPathComponent(filename)
    }
    

    private var avatarPreviewImage: Image {
        if avatarRemoved {
            return Image(systemName: "person.crop.circle.fill")
        } else if let ui = avatarImage {
             return Image(uiImage: ui)
         } else if let ui = loadAvatarFromDisk() {
             return Image(uiImage: ui)
         } else {
             return Image(systemName: "person.crop.circle.fill")
         }
     }
    
}

private struct AvatarRow: View {
    let image: Image
    var onPick: (PhotosPickerItem?) -> Void
    var onRemove: () -> Void
    
    @State private var pickerItem: PhotosPickerItem? = nil
    
    var body: some View {
        HStack(spacing: 16) {
            image
                .resizable()
                .scaledToFill()
                .frame(width:96, height: 96)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                .clipped()
                .shadow(radius: 1)
            HStack(alignment: .center, spacing: 8) {
                PhotosPicker(
                    selection: $pickerItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Text("Change")
                        .appFont(.cardTitle)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 14)
                        .background(Color("Primary 1"))
                        .foregroundColor(.secondary3)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .onChange(of: pickerItem) {
                    onPick(pickerItem)
                }
                
                Button(role: .destructive) {
                    onRemove()
                } label: {
                    Text("Remove")
                        .appFont(.cardTitle)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 14)
                        .overlay(Rectangle().stroke(Color.primary1.opacity(0.6), lineWidth: 1))
                        .foregroundColor(.primary1)
                  }
            }
        }
    }
}

struct ProfileTitleBar: ToolbarContent {
    let onBack: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(10)
                    .background( Circle().fill(Color("Primary 1")))
                    //.clipShape(Circle())
                    .overlay(Circle().stroke(.black.opacity(0.1), lineWidth: 1))
                    .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 1)
            }
            .accessibilityLabel("back")
        }
        ToolbarItem(placement: .principal) {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(height: 28)
                .accessibilityHidden(true)
            
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Image("Profile")
                .resizable()
                .scaledToFill()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                .clipped()
        }
    }
}

struct Checkbox: View {
    @Binding var isChecked: Bool
    
    var label: String
    
    var body: some View {
        Button(action: { isChecked.toggle() }) {
            HStack {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(isChecked ? Color("Primary 1") : .gray)
                Text(label)
            }
        }
        .buttonStyle(.plain)
    }
}

struct EmailNotificationsSection: View {
    @Binding var orderStatus: Bool
    @Binding var passwordChanges: Bool
    @Binding var specialOffers: Bool
    @Binding var newsletter: Bool



    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Email notifications")
                .appFont(.subtitle)
                .padding(.bottom, 8)
            Checkbox(isChecked: $orderStatus, label: "Order status")
            Checkbox(isChecked: $passwordChanges, label: "Password changes")
            Checkbox(isChecked: $specialOffers, label: "Special offers")
            Checkbox(isChecked: $newsletter, label: "Newsletter")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .appFont(.paragraph)
   }
}

#Preview {
    NavigationStack {
        UserProfile()
    }
}
