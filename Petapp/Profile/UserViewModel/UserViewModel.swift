//
//  ViewModel.swift
//  Petapp
//
//  Created by MUNAVAR PM on 30/03/25.
//
import Foundation
import SwiftUI
import UIKit
import SwiftData

class ProfileEditorViewModel: ObservableObject {
    @Published var userProfile: UserProfileData
    @Published var showImagePicker = false
    
    init(userProfile: UserProfileData = UserProfileData()) {
        self.userProfile = userProfile
    }
    
    func saveChanges() {
        // Here you would typically save to a database or backend
        print("Profile saved: \(userProfile)")
    }
}
