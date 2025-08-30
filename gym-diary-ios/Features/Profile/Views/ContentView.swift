//
//  ContentView.swift
//  gym-diary-ios
//
//  Created by luca.la.rosa on 14/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isDarkTheme = true
    @State private var selectedTab = 0
    @StateObject private var sessionManager = SessionManager.shared
    
    var body: some View {
        TabView(selection: $selectedTab) {
            WorkoutsView()
                .tabItem {
                    Image(systemName: "dumbbell.fill")
                    Text("Workout")
                }
                .tag(0)
            
            SessionsView()
                .tabItem {
                    Image(systemName: "timer")
                    Text("Workout Sessions")
                }
                .tag(1)
            
            ProfileView(isDarkTheme: $isDarkTheme)
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
                .tag(2)
        }
        .accentColor(.blue)
        .preferredColorScheme(isDarkTheme ? .dark : .light)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea(.all, edges: .bottom)
        )
        .onChange(of: sessionManager.shouldNavigateToSessions) { _, shouldNavigate in
            if shouldNavigate {
                selectedTab = 1
                sessionManager.shouldNavigateToSessions = false
            }
        }
    }
}

// MARK: - Workout View (moved to WorkoutsView.swift)

// MARK: - Workout Card (moved to WorkoutsView.swift)

// MARK: - Workout Detail View (moved to WorkoutsView.swift)

// MARK: - Exercise Detail Row (moved to WorkoutsView.swift)

// MARK: - Workout Icon and Color Selector (moved to WorkoutsView.swift)

// MARK: - Create Workout View (moved to WorkoutsView.swift)


// MARK: - Create Section View (moved to WorkoutsView.swift)

// MARK: - Drop Delegate (moved to WorkoutsView.swift)

// MARK: - Profile View (unchanged)
struct ProfileView: View {
    @Binding var isDarkTheme: Bool
    @State private var timerNotificationsEnabled = true
    @State private var soundsEnabled = true
    @State private var useKilograms = true
    @State private var defaultRestTime = 60
    @State private var showingRestTimePicker = false
    @State private var showingPersonalInfo = false
    @Environment(\.colorScheme) private var colorScheme
    
    // Array of rest time options (0 to 300 seconds)
    private let restTimeOptions = Array(0...300)
    
    var body: some View {
        NavigationView {
            List {
                // Account Section
                ProfileAccountSection(showingPersonalInfo: $showingPersonalInfo)
            
                // General Settings Section
                ProfileGeneralSection(
                    isDarkTheme: $isDarkTheme,
                    useKilograms: $useKilograms,
                    defaultRestTime: $defaultRestTime,
                    showingRestTimePicker: $showingRestTimePicker
                )
            
                // Notifications Section
                ProfileNotificationsSection(
                    timerNotificationsEnabled: $timerNotificationsEnabled,
                    soundsEnabled: $soundsEnabled
                )
            
                // Support Section
                ProfileSupportSection()
            
                // Version Section
                ProfileVersionSection()
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showingRestTimePicker) {
                RestTimePickerView(
                    selectedTime: $defaultRestTime,
                    isPresented: $showingRestTimePicker
                )
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $showingPersonalInfo) {
                PersonalInfoView()
            }
        }
    }
}

// MARK: - Profile Section Components
struct ProfileAccountSection: View {
    @Binding var showingPersonalInfo: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Section {
            Button(action: {
                showingPersonalInfo = true
            }) {
                HStack {
                    Image(systemName: "person.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .frame(width: 50, height: 50)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("User Name")
                            .font(.body)
                            .foregroundColor(.primary)
                        Text("user@email.com")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .buttonStyle(PlainButtonStyle())
        } header: {
            Text("Account")
        }
    }
}

struct ProfileGeneralSection: View {
    @Binding var isDarkTheme: Bool
    @Binding var useKilograms: Bool
    @Binding var defaultRestTime: Int
    @Binding var showingRestTimePicker: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Section {
            Button(action: {
                showingRestTimePicker = true
            }) {
                HStack {
                    Image(systemName: "timer.fill")
                        .font(.body)
                        .foregroundColor(.orange)
                        .frame(width: 24, height: 24)
                    
                    Text("Default Rest Time")
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(defaultRestTime) seconds")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            HStack {
                Image(systemName: "scalemass.fill")
                    .font(.body)
                    .foregroundColor(.green)
                    .frame(width: 24, height: 24)
                
                Text("Units")
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(useKilograms ? "kg" : "lb")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Toggle("", isOn: $useKilograms)
                    .labelsHidden()
            }
            
            HStack {
                Image(systemName: "moon.fill")
                    .font(.body)
                    .foregroundColor(.blue)
                    .frame(width: 24, height: 24)
                
                Text("Theme")
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(isDarkTheme ? "Dark" : "Light")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Toggle("", isOn: $isDarkTheme)
                    .labelsHidden()
            }
        } header: {
            Text("General")
        }
    }
}

struct ProfileNotificationsSection: View {
    @Binding var timerNotificationsEnabled: Bool
    @Binding var soundsEnabled: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Section {
            HStack {
                Image(systemName: "bell.fill")
                    .font(.body)
                    .foregroundColor(.red)
                    .frame(width: 24, height: 24)
                
                Text("Timer Notifications")
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(timerNotificationsEnabled ? "On" : "Off")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Toggle("", isOn: $timerNotificationsEnabled)
                    .labelsHidden()
            }
            
            HStack {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.body)
                    .foregroundColor(.blue)
                    .frame(width: 24, height: 24)
                
                Text("Sounds")
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(soundsEnabled ? "On" : "Off")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Toggle("", isOn: $soundsEnabled)
                    .labelsHidden()
            }
        } header: {
            Text("Notifications")
        }
    }
}

struct ProfileVersionSection: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Section {
            HStack {
                Spacer()
                Text("Version 1.0.0")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
    }
}

// MARK: - Profile Support Section
struct ProfileSupportSection: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingHelpSupport = false
    @State private var showingRateApp = false
    
    var body: some View {
        Section {
            Button(action: {
                showingHelpSupport = true
            }) {
                HStack {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.body)
                        .foregroundColor(.blue)
                        .frame(width: 24, height: 24)
                    
                    Text("Help & Support")
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                showingRateApp = true
            }) {
                HStack {
                    Image(systemName: "star.fill")
                        .font(.body)
                        .foregroundColor(.yellow)
                        .frame(width: 24, height: 24)
                    
                    Text("Rate App")
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .buttonStyle(PlainButtonStyle())
        } header: {
            Text("Support & Feedback")
        }
        .sheet(isPresented: $showingHelpSupport) {
            HelpSupportView()
        }
        .sheet(isPresented: $showingRateApp) {
            RateAppView()
        }
    }
}



struct RestTimePickerView: View {
    @Binding var selectedTime: Int
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    private let restTimeOptions = Array(0...300)
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("Default Rest Time")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Done") {
                    isPresented = false
                }
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
            
            // Picker
            Picker("Rest Time", selection: $selectedTime) {
                ForEach(restTimeOptions, id: \.self) { seconds in
                    Text("\(seconds) seconds").tag(seconds)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 150)
            
            Spacer()
        }
        .padding(.top)
    }
}



#Preview {
    ContentView()
}
