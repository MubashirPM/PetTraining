//
//  WhislistView.swift
//  Petapp
//
//  Created by MUNAVAR PM on 27/02/25.
//

import SwiftUI
import SwiftData

struct WishlistView: View {
    let favoritePets: Set<String>
    let toggleFavorite: (PetProfile) -> Void
    let isFavorite: (PetProfile) -> Bool
    @Binding var selectedTab: AppTab  //  Use AppTab instead
    @Environment(\.modelContext) private var modelContext //  Fetch manually
    @State private var favoriteList: [PetProfile] = []  //  Store manually

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                // Header
                HStack {
                    Text("❤️ Wishlist").font(.largeTitle).bold()
                    Spacer()
                }
                .padding(.horizontal)

                if favoriteList.isEmpty {
                    Text("No favorite pets yet!").foregroundColor(.gray)
                } else {
                    List {
                        ForEach(favoriteList, id: \.id) { pet in
                            NavigationLink(destination: AnimalDetailView(animal: pet.toAnimal())) {
                                PetRowView(pet: pet, toggleFavorite: toggleFavorite, isFavorite: isFavorite)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .listStyle(.plain)
                }

                Spacer()
                //  Updated Tab Bar for navigation
                TabBar(selectedTab: $selectedTab)
            }
            .onAppear {
                loadFavoritePets() } //  Load pets when view appears
        }
    }

    //  Function to Load Favorite Pets
    private func loadFavoritePets() {
        do {
            let allPets: [PetProfile] = try modelContext.fetch(FetchDescriptor<PetProfile>())
            favoriteList = allPets.filter { favoritePets.contains(String(describing: $0.id)) }
            print("Loaded Favorite Pets: \(favoriteList.count)") //  Debugging
        } catch {
            print("Error fetching pets: \(error)")
        }
    }
}

struct PetRowView: View {
    let pet: PetProfile
    let toggleFavorite: (PetProfile) -> Void
    let isFavorite: (PetProfile) -> Bool

    var body: some View {
        HStack {
            if let imageData = pet.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(pet.petName)
                    .font(.headline)
                    .bold()

                Text(pet.location)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text("Gender: \(pet.gender)")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            Spacer()

            Button(action: { toggleFavorite(pet) }) {
                Image(systemName: isFavorite(pet) ? "heart.fill" : "heart")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(isFavorite(pet) ? .red : .gray)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(.trailing, 10)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).shadow(radius: 3))
    }
}
