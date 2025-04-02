//
//  MainView.swift
//  Petapp
//
//  Created by MUNAVAR PM on 12/02/25.
//



import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var context // ✅ Use SwiftData context automatically

    var body: some View {
        NavigationStack { // ✅ Updated to NavigationStack
            ZStack {
                // Background Image with overlay
                Image("backgroundpet")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .overlay(Color.black.opacity(0.3))

                // Main content
                VStack(spacing: 0) {
                    Spacer()

                    // Welcome Text
                    VStack(spacing: 10) {
                        Text("Welcome to")
                            .font(.title2)
                            .foregroundColor(.white)
                        Text("PetApp")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 40)

                    // Login Container
                    VStack(spacing: 25) {
                        // Sign In Button (Navigates to LoginView)
                        NavigationLink(destination: LoginView()) {
                            Text("Sign In")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 280, height: 50)
                                .background(
                                    LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)
                                )
                                .clipShape(Capsule())
                        }

                        // Sign Up Button (Navigates to RegisterView)
                        NavigationLink(destination: RegisterView()) {
                            Text("Sign Up")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .frame(width: 280, height: 50)
                                .background(Capsule().fill(Color.white)) // ✅ Simplified background styling
                        }
                    }
                    .padding(30)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.white.opacity(0.2))
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                    )
                    .padding(.horizontal, 20)

                    Spacer()

                    // Bottom Text
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.white.opacity(0.8))
                        NavigationLink("Log In", destination: LoginView())
                            .foregroundColor(.purple)
                            .fontWeight(.medium)
                    }
                    .padding(.bottom, 30)
                    .padding(.top, 20)
                }
            }
        }
        .navigationBarBackButtonHidden(true) // Hides the back button
        .tint(.purple)
    }
}
// the is main thing
// MARK: - Preview
#Preview {
    MainView()
}
