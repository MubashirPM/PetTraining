//
//  View.swift
//  Petapp
//
//  Created by MUNAVAR PM on 30/03/25.
//
import SwiftUI
import SwiftData

struct SettingsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var userProfile: [PetProfile]  // Fetch user profile from SwiftData
    
    @StateObject private var viewModel = ProfileEditorViewModel(
        userProfile: UserProfileData(
            name: "",
            email: "",
            country: ""
        )
    )
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var authManager: AuthManager
    @State private var isNavigateToRegistation = false
    
    @Binding var selectedTab: AppTab
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    if let profile = userProfile.first {
                        Section(header: Text("Profile Photo")) {
                            HStack {
                                Spacer()
                                ProfilePhotoSelectorView(
                                    image: Binding(
                                        get: { viewModel.userProfile.profileImage },
                                        set: { viewModel.userProfile.profileImage = $0 }
                                    ),
                                    showImagePicker: $viewModel.showImagePicker
                                )
                                Spacer()
                            }
                        }
                        
                        Section(header: Text("Personal Information")) {
                            TextField("Enter your name", text: Binding(
                                get: { profile.petName },
                                set: { profile.petName = $0 }))
                                .autocapitalization(.words)
                            
                            TextField("Enter your email", text: $viewModel.userProfile.email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            
                            TextField("Enter your country", text: $viewModel.userProfile.country)
                        }
                        
                        Section {
                            Button(action: {
                                try? modelContext.save()
                                viewModel.saveChanges()
                                
                            }) {
                                Text("Save Changes")
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    } else {
                        Text("No Profile Data Found")
                    }
                }
                Spacer()
                CustomTabBar(selectedTab: $selectedTab, primaryColor: .green)
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationTitle("Edit Profile")
            .navigationBarBackButtonHidden(true)
            .onAppear(perform: {
                print("authManager.isLoggedIn Settings = \(authManager.isLoggedIn)")
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        authManager.logout()
                    } label: {
                        Image("ic-logoutBT")
                            .resizable()
                            .foregroundColor(.black)
                            .frame(width: 20, height: 20)
                    }
                    .foregroundColor(.red)
                }
            }
            .sheet(isPresented: $viewModel.showImagePicker) {
                PhotoSelectionView(image: Binding(
                    get: { viewModel.userProfile.profileImage },
                    set: { viewModel.userProfile.profileImage = $0 }
                ))
            }
        }
        .fullScreenCover(isPresented: Binding(
            get: { !authManager.isLoggedIn },
            set: { _ in }
        )) {
            LoginView()
                .environmentObject(authManager)
        }
    }
}

class AuthManager: ObservableObject {
    @Published var isLoggedIn = true
    @Published var isSelectedTabBar: AppTab = .home
    func logout() {
        isLoggedIn = false
    }
    
    func login() {
        isLoggedIn = true
        isSelectedTabBar = .home
    }
}

struct ProfilePhotoSelectorView: View {
    @Binding var image: UIImage?
    @Binding var showImagePicker: Bool

    var body: some View {
        Button(action: {
            showImagePicker = true
        }) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
            }
        }
        .overlay(
            Circle()
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

//struct PhotoSelectionView: UIViewControllerRepresentable {
//    @Binding var image: UIImage?
//    @Environment(\.presentationMode) var presentationMode
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        picker.sourceType = .photoLibrary
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//        let parent: PhotoSelectionView
//
//        init(_ parent: PhotoSelectionView) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//            if let uiImage = info[.originalImage] as? UIImage {
//                parent.image = uiImage
//            }
//            parent.presentationMode.wrappedValue.dismiss()
//        }
//    }
//}
