//
//  LoginViewModel.swift
//  Petapp
//
//  Created by MUNAVAR PM on 14/02/25.
//

import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject{
    @Published var  showAlert = false
    @Published var alertMessage = ""
    @Published var isLoading = false
    
    func login(
        email: String,
        password: String,
        completion: @escaping (Bool) -> Void
    ) {
        self.isLoading = true
        Auth
            .auth()
            .signIn(withEmail: email, password: password) { result, error in
                
                if let error = error {
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                    completion(false)
                    self.isLoading = false
                } else {
                    completion(true)
                    print("Gmail == \(email)")
                    self.isLoading = false
                }
            }
    }
}
