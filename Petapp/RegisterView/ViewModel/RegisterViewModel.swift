//
//  File.swift
//  Petapp
//
//  Created by MUNAVAR PM on 15/02/25.
//

import Foundation
import FirebaseAuth


class RegisterViewModel : ObservableObject {
    
    func createAccount(
        email: String,
        password: String ,
        completion: @escaping (Bool,String) -> Void
    ) {
        Auth
            .auth()
            .createUser(withEmail: email, password: password) {
 result,
 error in
            
                if let error = error {
                    print(
                        "Firebase Signup Error: \(error.localizedDescription)"
                    )

                    completion(false,error.localizedDescription)
                    return
                }
            
                if let user = result?.user {
                    print("User signed up successfully: \(user.uid)")

                    completion(true,"")
                }
            }
    }
}
