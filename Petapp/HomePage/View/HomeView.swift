// Mubashir PM

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var pets: [PetProfile]
    @State private var selectedCategory: String? = nil // for checking the animal
    @State private var searchText = "" // for checking the user enter text
    @State private var navigateToRegister = false
    @State private var petToEdit: PetProfile?
    @State private var selectedTab: AppTab = .home  //  Use AppTab instead
    @State private var showSearchBar = false

    @AppStorage("favoritePets") private var favoritePetsData: Data = Data()
    @State private var favoritePets: Set<String> = []
    
    // Add some color themes
    private let primaryColor = Color.purple
    private let accentColor = Color(red: 0.3, green: 0.8, blue: 0.7)
    private let backgroundColor = Color(UIColor.systemBackground)
    private let secondaryBackgroundColor = Color(
        UIColor.secondarySystemBackground
    )
    
    @State private var showAlert = false
    @State private var article = Article(
        title: "going to delete",
        description: "Are sure about delete this pet"
    )

    ///  filtering the pets -> dog or cats.
    var filteredPets: [PetProfile] {
        pets
            .filter { pet in
                (
                    selectedCategory == nil || pet.category
                        .caseInsensitiveCompare(
                            selectedCategory ?? ""
                        ) == .orderedSame
                ) &&
                (
                    searchText.isEmpty || pet.petName
                        .localizedCaseInsensitiveContains(searchText)
                )
            }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    if selectedTab == .home {
                        homeContent
                    } else if selectedTab == .wishlist {
                        WishlistView(
                            favoritePets: favoritePets,
                            toggleFavorite: toggleFavorite,
                            isFavorite: isFavorite,
                            selectedTab: $selectedTab
                        )
                    } else if selectedTab == .profile {
                        SettingsView(selectedTab: $selectedTab)
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToRegister) {
                RegisterProfileView() //  Correct View Navigation
            }

            .sheet(item: $petToEdit) { pet in
                EditProfileView(pet: pet)
            }
        }
    }
    private var homeContent: some View {
        VStack(spacing: 0) {
            // Custom Header
            headerView //  No need for additional background here
            
            // Category Scrollview
            categoryScrollView
                .padding(.vertical, 12)
                .background(backgroundColor)
            
            if showSearchBar {
                searchBarView
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }
            
            //MARK: Pet List
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filteredPets, id: \.id) { pet in
                        enhancedPetCard(pet)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
            .background(backgroundColor)
            
            // Custom Tab Bar
            enhancedTabBar
                .background(
                    Rectangle()
                        .fill(Color.white)
                        .shadow(
                            color: Color.black.opacity(0.1),
                            radius: 5,
                            x: 0,
                            y: -2
                        )
                )
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    // MARK: - UI Components
    private var headerView: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: 60) // Fixed header height
            .clipShape(
                RoundedRectangle(cornerRadius: 15)
            ) // Clip the background to rounded corners

            // Content
            HStack {
                Text("🐾 PetRegistry")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Spacer() // Pushes buttons to the right

                Button(action: {
                    withAnimation(.spring()) {
                        showSearchBar.toggle()
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Circle().fill(Color.white.opacity(0.3)))
                }

                Button(action: {
                    petToEdit = nil
                    navigateToRegister = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Circle().fill(Color.white.opacity(0.3)))
                }
            }
            .padding(.horizontal) // Padding for the content inside the HStack
        }
        .padding(.horizontal) // Padding for the entire header
        .shadow(radius: 5) // Add subtle shadow for better visibility
    }
    
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 8)
            
            TextField("Search pets...", text: $searchText)
                .padding(10)
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 8)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10).fill(secondaryBackgroundColor)
        )
    }
    
    private var categoryScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                Button(action: {
                    selectedCategory = nil
                    print("Selected Category === All")
                }) {
                    Text("All")
                        .fontWeight(selectedCategory == nil ? .bold : .medium)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(
                                    selectedCategory == "All" ? //  Replace title with "All"
                                    LinearGradient(
                                        gradient: Gradient(
                                            colors: [primaryColor, accentColor]
                                        ),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ) :
                                        LinearGradient(
                                            gradient: Gradient(
                                                colors: [
                                                    Color.gray.opacity(0.15),
                                                    Color.gray.opacity(0.15)
                                                ]
                                            ),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                )
                        )
                        .foregroundColor(
                            selectedCategory == nil ? .white : .primary
                        )
                }
                
                // To selectedCategory we passing "title".
                EnhancedCategoryButton(title: "Cat", icon: "cat", selectedCategory: $selectedCategory,
                                       primaryColor: primaryColor, accentColor: accentColor)
                
                EnhancedCategoryButton(title: "Dog", icon: "dog", selectedCategory: $selectedCategory,
                                       primaryColor: primaryColor, accentColor: accentColor)
                
            }
            .padding(.horizontal)
        }
    }
    private func enhancedPetCard(_ pet: PetProfile) -> some View {
        NavigationLink(
            destination: AnimalDetailView(animal: convertToAnimal(pet))
        ) { //  Wrap in NavigationLink
            VStack(spacing: 0) {
                // Pet Image Section
                ZStack(alignment: .topTrailing) {
                    if let imageData = pet.imageData, let uiImage = UIImage(
                        data: imageData
                    ) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 180)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(
                                        colors: [
                                            .gray.opacity(0.3),
                                            .gray.opacity(0.5)
                                        ]
                                    ),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 180)
                            .overlay(
                                Image(systemName: "pawprint.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60)
                                    .foregroundColor(.white.opacity(0.8))
                            )
                    }

                    // Favorite & Delete Buttons
                    VStack(spacing: 8) {
                        // Favorite Button
                        Button(action: { toggleFavorite(pet) }) {
                            Image(
                                systemName: isFavorite(
                                    pet
                                ) ? "heart.fill" : "heart"
                            )
                            .foregroundColor(isFavorite(pet) ? .red : .white)
                            .padding(8)
                            .background(Circle().fill(Color.black.opacity(0.3)))
                        }

                      
                        Button {
                            showAlert = true
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                                .padding(8)
                                .background(
                                    Circle().fill(Color.black.opacity(0.3))
                                )
                        }
                    }
                    .padding(12)
                    .alert(
                        article.title,
                        isPresented: $showAlert,
                        presenting: article
                    ) {article in
                        Button("Delete") { deletePet(pet)}
                        Button("Cancel", role: .cancel) {}
                    } message: {article in
                        Text(article.description)
                    }
                }

                // Pet Details Section
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(pet.petName)
                            .font(.title3)
                            .fontWeight(.bold)

                        Spacer()

                        Text(pet.category)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(accentColor.opacity(0.2))
                            )
                            .foregroundColor(accentColor)
                    }

                    Divider()

                    HStack(spacing: 20) {
                        LabeledInfo(
                            icon: "mappin.circle.fill",
                            label: pet.location
                        )
                        LabeledInfo(icon: "person.fill", label: pet.gender)
                    }
                }
                .padding()
                .background(Color.white)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle()) //  Fix tap interaction
    }

    private var enhancedTabBar: some View {
        HStack {
            EnhancedTabBarButton(
                icon: "house.fill",
                label: "Home",
                isSelected: selectedTab == AppTab.home,  // Explicitly reference AppTab
                primaryColor: primaryColor,
                action: { selectedTab = AppTab.home }  //  Explicit reference
            )
            
            EnhancedTabBarButton(
                icon: "heart.fill",
                label: "Wishlist",
                isSelected: selectedTab == AppTab.wishlist,  //  Explicitly reference AppTab
                primaryColor: primaryColor,
                action: { selectedTab = AppTab.wishlist }  // Explicit reference
            )
            
            EnhancedTabBarButton(
                icon: "person.fill",
                label: "Profile",
                isSelected: selectedTab == AppTab.profile,  //  Explicitly reference AppTab
                primaryColor: primaryColor,
                action: { selectedTab = AppTab.profile }  // Explicit reference
            )
        }
        .padding(.top, 12)
        .padding(.bottom, 25) // Extra padding for bottom safe area
    }

    // MARK: - Pet Operations
    
    private func deletePet(_ pet: PetProfile) {
        withAnimation {
            modelContext.delete(pet)
            try? modelContext.save()
        }
    }
    
    // MARK: - Favorite Handling
    
    private func isFavorite(_ pet: PetProfile) -> Bool {
        let idString = String(describing: pet.id)
        return favoritePets.contains(idString)
    }

    private func toggleFavorite(_ pet: PetProfile) {
        let idString = String(describing: pet.id)
        if favoritePets.contains(idString) {
            favoritePets.remove(idString)
        } else {
            favoritePets.insert(idString)
        }
        saveFavorites()
    }

    private func saveFavorites() {
        do {
            let data = try JSONEncoder().encode(Array(favoritePets))
            favoritePetsData = data
        } catch {
            print("Failed to save favorites: \(error)")
        }
    }

    private func loadFavorites() {
        do {
            let stringArray = try JSONDecoder().decode(
                [String].self,
                from: favoritePetsData
            )
            favoritePets = Set(stringArray)
        } catch {
            favoritePets = []
        }
    }
}

// MARK: - Enhanced UI Components
struct EnhancedCategoryButton: View {
    let title: String
    let icon: String
    @Binding var selectedCategory: String?
    let primaryColor: Color
    let accentColor: Color

    // Compute if the category is selected
    private var isSelected: Bool {
        selectedCategory == title
    }

    var body: some View {
        Button(action: {
            withAnimation {
                selectedCategory = (selectedCategory == title) ? nil : title
                print("Selected Category === \(title)")
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                
                Text(title)
                    .fontWeight(isSelected ? .bold : .medium)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(
                        isSelected ?
                        LinearGradient(
                            gradient: Gradient(
                                colors: [primaryColor, accentColor]
                            ),
                            startPoint: .leading,
                            endPoint: .trailing
                        ) :
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [
                                        Color.gray.opacity(0.15),
                                        Color.gray.opacity(0.15)
                                    ]
                                ),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                    )
            )
            .foregroundColor(isSelected ? .white : .primary)
        }
    }
}

struct EnhancedTabBarButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let primaryColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(
                            isSelected ? primaryColor.opacity(0.1) : Color.clear
                        )
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(isSelected ? primaryColor : .gray)
                }
                
                Text(label)
                    .font(
                        .system(
                            size: 12,
                            weight: isSelected ? .semibold : .medium
                        )
                    )
                    .foregroundColor(isSelected ? primaryColor : .gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct LabeledInfo: View {
    let icon: String
    let label: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

// Existing Structures & Components (Updated)

struct EditProfileView: View {
    var pet: PetProfile
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var petName: String
    @State private var location: String
    private let accentColor = Color(red: 0.3, green: 0.8, blue: 0.7)

    init(pet: PetProfile) {
        self.pet = pet
        _petName = State(initialValue: pet.petName)
        _location = State(initialValue: pet.location)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Pet Name", text: $petName)
                    TextField("Location", text: $location)
                }
                .listRowBackground(Color(UIColor.secondarySystemBackground))
            }
            .scrollContentBackground(.hidden)
            .background(Color(UIColor.systemBackground))
            .navigationTitle("Edit Pet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveChanges() }
                        .foregroundColor(accentColor)
                }
            }
        }
    }

    private func saveChanges() {
        pet.petName = petName
        pet.location = location
        try? modelContext.save()
        dismiss()
    }
}
struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var pets: [PetProfile] //  Fetch pets from SwiftData

    var body: some View {
        NavigationStack {
            VStack {
                Text("Your Pets")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()

                if pets.isEmpty {
                    Text("No pets added yet!")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(
                            pets,
                            id: \.id
                        ) { pet in // Correct ForEach placement
                            HStack {
                                Text(pet.petName)
                                    .font(.headline)

                                Spacer()

                                //  Delete Button (Optional)
                                Button(action: { deletePet(pet) }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .onDelete(
                            perform: deletePets
                        ) //  Swipe to delete now works!
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Profile")
        }
    }

    // **Delete Pet Function (Ensures Changes are Saved)**
    private func deletePet(_ pet: PetProfile) {
        withAnimation {
            modelContext.delete(pet) //  Delete from SwiftData
            try? modelContext.save() // Ensure changes are saved
        }
    }

    // **Swipe-to-Delete Handler**
    private func deletePets(at offsets: IndexSet) {
        for index in offsets {
            let pet = pets[index]
            modelContext.delete(pet) //  Delete from SwiftData
        }
        do {
            try modelContext.save() //  Ensure changes are saved
        } catch {
            print("❌ Error saving after delete: \(error)")
        }
    }
}

private func convertToAnimal(_ pet: PetProfile) -> Animal {
    return Animal(
        name: pet.petName,
        location: pet.location,
        breed: "Unknown", // You can replace this if breed data exists
        gender: pet.gender,
        description: pet.details,
        image: pet.imageData != nil ? pet.imageData!
            .base64EncodedString() : "default_pet",
        gallery: [], //  Add gallery (empty for now)
        category: pet.category //  Include category from PetProfile
    )
}

#Preview {
    HomeView()
}
