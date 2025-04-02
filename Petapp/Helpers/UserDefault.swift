//
//  UserDefault.swift
//  Petapp
//
//  Created by MUNAVAR PM on 03/04/25.
//

import Foundation
class UserDefaultsManager: UserDefaults {
    static let shared = UserDefaultsManager()
    fileprivate let emailID = "email"
    
    fileprivate var preferenceWithBasicDetails: UserDefaults = {
            UserDefaults.standard
        }()

        fileprivate var preference: UserDefaults = {
            UserDefaults.standard
        }()
    
    var email: String {
           set {
               preferenceWithBasicDetails.set(newValue, forKey: emailID)
           } get {
               if let value = preferenceWithBasicDetails.value(forKey: emailID) as? String {
                   return value
               }
               return ""
           }
       }
    
}
