

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    
    @StateObject var viewModel = RegisterViewModel()
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String = ""
    @State private var showErrorAlert = false
    @State private var isLoading = false
    @State private var navigateToProfile = false

    var body: some View {
        NavigationView {  //  Wrap with NavigationView
            VStack(spacing: 20) {
                Text("Hey there,")
                    .font(.headline)
                    .foregroundColor(.black)

                Text("Create an Account")
                    .font(.title)
                    .fontWeight(.bold)

                VStack(spacing: 15) {
                    CustomTextField(icon: "person", placeholder: "First Name", text: $fullName)
                        .autocapitalization(.none)

                    CustomTextField(icon: "envelope", placeholder: "Email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)

                    CustomTextField(icon: "lock", placeholder: "Password", text: $password, isSecure: true)

                    CustomTextField(icon: "lock", placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)
                }
                .padding(.horizontal)

                // Register Button
                Button(action: {
                    signUpUser()
                }) {
                    ZStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Text("Register")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
                    .padding(.horizontal)
                }
                .disabled(isLoading)

                //  Fix Navigation Issue
                NavigationLink(
                    destination: RegisterProfileView()
                        .navigationBarHidden(true), // Correctly placed
                    isActive: $navigateToProfile
                ) {
                    EmptyView()
                }
                .hidden()

                // OR Divider
                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.3))
                    Text("Or")
                        .foregroundColor(.gray)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.3))
                }
                .padding(.horizontal)

                // Already have an account Login
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.gray)

                    NavigationLink(destination: LoginView()) {
                        Text("Login")
                            .foregroundColor(.purple)
                            .fontWeight(.bold)
                    }
                }
            }
            .padding()
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                // Reset fields when the view appears again
                clearFields()
            }
            .navigationBarBackButtonHidden(true)
        } //  End of NavigationView
    }

    private func signUpUser() {
        guard !fullName.trimmingCharacters(in: .whitespaces).isEmpty else {
            showError(message: "Full name is required.")
            return
        }

        guard fullName.count >= 6 else {
            showError(message: "Full name must be at least 6 characters.")
            return
        }

        guard let firstLetter = fullName.first, firstLetter.isUppercase else {
            showError(message: "Full name must start with a capital letter.")
            return
        }

        guard !email.isEmpty else {
            showError(message: "Email is required.")
            return
        }

        guard email.contains("@") && email.contains(".") else {
            showError(message: "Enter a valid email address.")
            return
        }

        guard !password.isEmpty else {
            showError(message: "Password is required.")
            return
        }

        guard password.count >= 6 else {
            showError(message: "Password must be at least 6 characters long.")
            return
        }

        guard password == confirmPassword else {
            showError(message: "Passwords do not match.")
            return
        }

        isLoading = true

        viewModel.createAccount(email: email, password: password) { success, message in
            DispatchQueue.main.async {
                isLoading = false // Reset loading indicator
                if success {
                    navigateToProfile = true  //  Ensure state change happens on the main thread
                    clearFields()
                } else {
                    showError(message: message)
                }
            }
        }
    }

    private func showError(message: String) {
        errorMessage = message
        showErrorAlert = true
    }

    private func clearFields() {
        fullName = ""
        email = ""
        password = ""
        confirmPassword = ""
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
