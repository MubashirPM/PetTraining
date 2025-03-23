//
//  login.swift
//  Petapp
//
//  Created by MUNAVAR PM on 12/02/25.
//
//
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var isSecured = true
    @State private var alertMessage = ""
    @State private var navigateToHome = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Hey there,")
                        .font(.title2)
                        .foregroundColor(.gray)

                    Text("Welcome Back")
                        .font(.title)
                        .bold()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 60)

                VStack(spacing: 24) {
                    // Email Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        TextField("Enter your email", text: $email)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }

                    // Password Field with Eye Toggle
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        HStack {
                            if isSecured {
                                SecureField("Enter your password", text: $password)
                                    .autocapitalization(.none)
                                    .textContentType(.oneTimeCode)
                            } else {
                                TextField("Enter your password", text: $password)
                                    .autocapitalization(.none)
                                    .textContentType(.oneTimeCode)
                            }

                            Button(action: { isSecured.toggle() }) {
                                Image(systemName: isSecured ? "eye.slash" : "eye")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }

                    // Forgot Password
                    Button("Forgot your password?") {
                        // Forgot password action
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)

                    // Login Button
                    Button(action: {
                        viewModel.login(email: email, password: password) { success in
                            if success {
                                navigateToHome = true
                            }
                        }
                    }) {
                        Text("Login")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue, .purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                    }
                    .padding(.top, 16)
                    .fullScreenCover(isPresented: $navigateToHome) {
                        HomeView()
                    }

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
                    .padding(.vertical, 24)

                    // Register Navigation
                    HStack(spacing: 4) {
                        Text("Don't have an account yet?")
                            .foregroundColor(.gray)

                        NavigationLink(destination: RegisterView().navigationBarBackButtonHidden(true)) {
                            Text("Register")
                                .foregroundColor(.purple)
                                .fontWeight(.semibold)
                        }
                    }
                }
                .padding(.top, 40)

                Spacer()
            }
            .padding(.horizontal, 24)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Login Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationBarHidden(true)
            .tint(.purple)
        }
        .navigationViewStyle(.stack)
    }
}

// MARK: - Preview
#Preview {
    LoginView()
}
