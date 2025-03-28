//
//  Model.swift
//  Petapp
//
//  Created by MUNAVAR PM on 30/03/25.
//

import Foundation
import UIKit
import SwiftData

struct UserProfileData {
    var name: String
    var email: String
    var password: String
    var country: String
    var profileImage: UIImage?
    
    init(name: String = "", email: String = "", password: String = "", country: String = "", profileImage: UIImage? = nil) {
        self.name = name
        self.email = email
        self.password = password
        self.country = country
        self.profileImage = profileImage
    }
}
