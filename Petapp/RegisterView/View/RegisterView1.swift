

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
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Hey there,")
                        .font(.headline)
                        .foregroundColor(.black)

                    Text("Create an Account")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                VStack(spacing: 15) {
                    CustomTextField(icon: "person", placeholder: "Full Name", text: $fullName)
                        .autocapitalization(.words)

                    CustomTextField(icon: "envelope", placeholder: "Email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)

                    CustomTextField(icon: "lock", placeholder: "Password", text: $password, isSecure: true)

                    CustomTextField(icon: "lock", placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)
                }
                .padding(.horizontal)

                // Register Button
                Button(action: { signUpUser() }) {
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

                // Navigation to Profile after registration
                NavigationLink(
                    destination: RegisterProfileView()
                        .navigationBarBackButtonHidden(true), // Hide Back Button
                    isActive: $navigateToProfile
                ) { EmptyView() }
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

                    NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
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
            .onAppear { clearFields() }
            .navigationBarBackButtonHidden(true) // Hide back button in the registration screen
        }
        .navigationViewStyle(.stack)
    }

    // MARK: - Sign Up Function
    private func signUpUser() {
        guard validateFields() else { return }
        
        isLoading = true

        viewModel.createAccount(email: email, password: password) { success, message in
            DispatchQueue.main.async {
                isLoading = false
                if success {
                    navigateToProfile = true  // Navigate to Profile
                    clearFields()
                } else {
                    showError(message: message)
                }
            }
        }
    }

    // MARK: - Validation Function
    private func validateFields() -> Bool {
        if fullName.trimmingCharacters(in: .whitespaces).isEmpty {
            return showError(message: "Full name is required.")
        }

        if fullName.count < 6 {
            return showError(message: "Full name must be at least 6 characters.")
        }

        if let firstLetter = fullName.first, !firstLetter.isUppercase {
            return showError(message: "Full name must start with a capital letter.")
        }

        if email.isEmpty || !email.contains("@") || !email.contains(".") {
            return showError(message: "Enter a valid email address.")
        }

        if password.isEmpty {
            return showError(message: "Password is required.")
        }

        if password.count < 6 {
            return showError(message: "Password must be at least 6 characters long.")
        }

        if password != confirmPassword {
            return showError(message: "Passwords do not match.")
        }

        return true
    }

    // MARK: - Utility Functions
    private func showError(message: String) -> Bool {
        errorMessage = message
        showErrorAlert = true
        return false
    }

    private func clearFields() {
        fullName = ""
        email = ""
        password = ""
        confirmPassword = ""
    }
}

// MARK: - Preview
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
