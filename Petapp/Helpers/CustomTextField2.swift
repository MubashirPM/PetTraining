//
//  CustomTextField2.swift
//  Petapp
//
//  Created by MUNAVAR PM on 15/02/25.
//

import SwiftUI
// MARK: - Custom TextField Component
struct CustomTextField2: View {
    var icon: String
    var placeholder: String
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
            TextField(placeholder, text: $text)
                .disableAutocorrection(true)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

