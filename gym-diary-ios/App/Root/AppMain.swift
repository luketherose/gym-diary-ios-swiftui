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
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(firebaseManager)
        }
    }
}
