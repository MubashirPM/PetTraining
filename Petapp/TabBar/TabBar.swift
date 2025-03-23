//
//  TabBar.swift
//  Petapp
//
//  Created by MUNAVAR PM on 27/02/25.
//

import Foundation
import SwiftUI

//  Renamed TabSelection to AppTab
enum AppTab: CaseIterable {
    case home, wishlist, profile
}

struct TabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack {
            Spacer()
            TabBarButton(icon: "house.fill", label: "Home", color: .blue, isSelected: selectedTab == .home) {
                selectedTab = .home
            }
            Spacer()
            TabBarButton(icon: "heart.fill", label: "Wishlist", color: .red, isSelected: selectedTab == .wishlist) {
                selectedTab = .wishlist
            }
            Spacer()
            TabBarButton(icon: "person.fill", label: "Profile", color: .green, isSelected: selectedTab == .profile) {
                selectedTab = .profile
            }
            Spacer()
        }
        .frame(height: 70)
        .background(Color.white) //  Removed shadow
    }
}


struct TabBarButton: View {
    let icon: String
    let label: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(isSelected ? color : .gray)
                Text(label)
                    .font(.footnote)
                    .foregroundColor(isSelected ? color : .gray)
            }
        }
    }
}
