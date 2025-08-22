//
//  gym_diary_iosApp.swift
//  gym-diary-ios
//
//  Created by luca.la.rosa on 14/08/25.
//

import SwiftUI
// import FirebaseCore

@main
struct gym_diary_iosApp: App {
    @StateObject private var firebaseManager = FirebaseManager.shared
    
    init() {
        // FirebaseApp.configure()
        
        // Test ExerciseCatalog loading
        print("🚀 AppMain: Testing ExerciseCatalog...")
        let catalog = ExerciseCatalog.shared
        print("🚀 AppMain: Catalog has \(catalog.archetypes.count) archetypes")
        
        // Test search
        let searchResults = catalog.searchArchetypes(query: "bench")
        print("🚀 AppMain: Search for 'bench' returned \(searchResults.count) results")
        for result in searchResults {
            print("🚀 AppMain: Found: \(result.displayName)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(firebaseManager)
        }
    }
}
