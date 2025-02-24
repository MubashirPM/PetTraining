//
//  CustomTextField.swift
//  Petapp
//
//  Created by MUNAVAR PM on 15/02/25.
//

import SwiftUI

struct CustomTextField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    @State private var isSecured: Bool = true

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)

            if isSecure {
                if isSecured {
                    SecureField(placeholder, text: $text)
                        .autocapitalization(.none)
                        .textContentType(.oneTimeCode)
                } else {
                    TextField(placeholder, text: $text)
                        .autocapitalization(.none)
                        .textContentType(.oneTimeCode)
                }

                Button(action: {
                    isSecured.toggle()
                }) {
                    Image(systemName: isSecured ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            } else {
                TextField(placeholder, text: $text)
                    .autocapitalization(.none)
            }
        }
        .padding()
        .frame(height: 50)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 3)
    }
}

