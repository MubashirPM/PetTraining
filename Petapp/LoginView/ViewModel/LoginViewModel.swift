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
    
    func login(
        email: String,
        password: String,
        completion: @escaping (Bool) -> Void
    ) {
        Auth
            .auth()
            .signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                    completion(false)
                
                } else {
                    completion(true)
                }
            }
    }
}
