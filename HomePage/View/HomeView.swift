//
import SwiftUI
import SwiftData

//  Main App View with TabBar
struct ContentView: View {
    @State private var selectedTab: TabSelection = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(TabSelection.home)

            WishlistView()
                .tabItem { Label("Wishlist", systemImage: "heart.fill") }
                .tag(TabSelection.wishlist)

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.fill") }
                .tag(TabSelection.profile)
        }
    }
}

//  Enum for Tabs
enum TabSelection { case home, wishlist, profile }

//  Home View with Delete & Edit
struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var pets: [PetProfile]
    @State private var selectedCategory: String? = nil
    @State private var searchText = ""
    @State private var favoritePets: Set<PersistentIdentifier> = []
    @State private var navigateToRegister = false
    @State private var petToEdit: PetProfile?
    @State private var selectedTab: TabSelection = .home  //  Added for TabBar inside HomeView

    var filteredPets: [PetProfile] {
        pets.filter { pet in
            (selectedCategory == nil || pet.category.caseInsensitiveCompare(selectedCategory ?? "") == .orderedSame) &&
            (searchText.isEmpty || pet.petName.localizedCaseInsensitiveContains(searchText))
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                //  Header
                HStack {
                    Text("🐾 PetRegistry").font(.largeTitle).bold()
                    Spacer()
                    Button(action: { navigateToRegister = true }) {
                        Image(systemName: "plus.circle.fill").resizable().frame(width: 30, height: 30).foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)

                //  Search Bar
                TextField("Search pets...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                //  Category Filter
                HStack(spacing: 15) {
                    CategoryButton(title: "Cat", selectedCategory: $selectedCategory)
                    CategoryButton(title: "Dog", selectedCategory: $selectedCategory)
                }
                .padding(.top, 5)

                //  Pets List with Delete & Edit
                List {
                    ForEach(filteredPets, id: \.id) { pet in
                        NavigationLink(destination: AnimalDetailView(animal: pet.toAnimal())) {
                            PetRowView(
                                pet: pet,
                                isFavorite: favoritePets.contains(pet.id),
                                toggleFavorite: { toggleFavorite(pet) }
                            )
                        }
                        .swipeActions {
                            Button(role: .destructive) { deletePet(pet) } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            Button { petToEdit = pet } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                        }
                    }
                }

                //  Bottom Tab Bar
                TabBar(selectedTab: $selectedTab)  //  Added TabBar inside HomeView
            }
            .navigationDestination(isPresented: $navigateToRegister) { RegisterProfileView() }
            .sheet(item: $petToEdit) { pet in EditProfileView(pet: pet) }
        }
    }

    //  Delete Pet
    private func deletePet(_ pet: PetProfile) {
        modelContext.delete(pet)
        try? modelContext.save()
    }

    //  Toggle Favorite
    private func toggleFavorite(_ pet: PetProfile) {
        if favoritePets.contains(pet.id) {
            favoritePets.remove(pet.id)
        } else {
            favoritePets.insert(pet.id)
        }
    }
}

//  Bottom TabBar (Custom for HomeView)
struct TabBar: View {
    @Binding var selectedTab: TabSelection

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
        .background(Color.white.shadow(radius: 3))
    }
}

// Tab Bar Button
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
            .padding(.top, 5)
        }
    }
}

//  Category Button
struct CategoryButton: View {
    let title: String
    @Binding var selectedCategory: String?

    var body: some View {
        Button(action: { withAnimation { selectedCategory = (selectedCategory == title) ? nil : title } }) {
            Text(title)
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(selectedCategory == title ? Color.blue.opacity(0.7) : Color.gray.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(selectedCategory == title ? .white : .black)
                .shadow(radius: selectedCategory == title ? 3 : 0)
        }
    }
}

//  Wishlist View
struct WishlistView: View {
    var body: some View {
        VStack {
            Text("❤️ Wishlist").font(.largeTitle).bold()
            Text("Your favorite pets will appear here.")
            Spacer()
        }
    }
}

//  Profile View
struct ProfileView: View {
    var body: some View {
        VStack {
            Text("👤 Profile").font(.largeTitle).bold()
            Text("Manage your profile and settings.")
            Spacer()
        }
    }
}

//  Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
//  Pet Row View (Displays Each Pet in List)
struct PetRowView: View {
    let pet: PetProfile
    var isFavorite: Bool
    var toggleFavorite: () -> Void

    var body: some View {
        HStack {
            //  Pet Image
            if let imageData = pet.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }

            //  Pet Details
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

            //  Favorite Button
            Button(action: toggleFavorite) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .gray)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).shadow(radius: 3))
    }
}
//         Edit Profile View (Allows Editing Pet Details)
struct EditProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    @State private var petName: String
    @State private var location: String
    var pet: PetProfile

    init(pet: PetProfile) {
        self.pet = pet
        _petName = State(initialValue: pet.petName)
        _location = State(initialValue: pet.location)
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Pet Name", text: $petName)
                TextField("Location", text: $location)
            }
            .navigationTitle("Edit Pet")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveChanges() }
                }
            }
        }
    }

    private func saveChanges() {
        pet.petName = petName
        pet.location = location
        try? modelContext.save()
        presentationMode.wrappedValue.dismiss()
    }
}
