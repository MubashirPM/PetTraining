//
//  ViewModel.swift
//  Petapp
//
//  Created by MUNAVAR PM on 17/02/25.
//
//

import SwiftUI
import SwiftData

class HomeViewModel: ObservableObject {
    @Published var pets: [PetProfile] = [] //  Holds pets list
    private var modelContext: ModelContext //  Store SwiftData Context

    //  Initialize with SwiftData Context
    init(context: ModelContext) {
        self.modelContext = context
        fetchPets()
    }

    //  Fetch pets from SwiftData
    func fetchPets() {
        let request = FetchDescriptor<PetProfile>() // Fetch all pets
        do {
            pets = try modelContext.fetch(request)
        } catch {
            print("Error fetching pets: \(error.localizedDescription)")
        }
    }

    //  Add new pet (syncs with SwiftData)
    func addPet(_ pet: PetProfile) {
        modelContext.insert(pet)
        fetchPets() //  Refresh pet list after adding
    }
}
