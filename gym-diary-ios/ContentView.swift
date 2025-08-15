//
//  ContentView.swift
//  gym-diary-ios
//
//  Created by luca.la.rosa on 14/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isDarkTheme = false
    
    var body: some View {
        TabView {
            WorkoutsView()
                .tabItem {
                    Image(systemName: "dumbbell.fill")
                    Text("Workouts")
                }
            
            ProfileView(isDarkTheme: $isDarkTheme)
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
        }
        .accentColor(.blue)
        .preferredColorScheme(isDarkTheme ? .dark : .light)
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
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: DesignSystem.Spacing.large) {
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
                
                        // Information Section
                        ProfileInformationSection()
                        
                        // Version Section
                        ProfileVersionSection()
                    }
                    .padding(DesignSystem.Spacing.large)
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showingRestTimePicker) {
                RestTimePickerView(
                    selectedTime: $defaultRestTime,
                    isPresented: $showingRestTimePicker
                )
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
        CardContainer {
            Button(action: {
                showingPersonalInfo = true
            }) {
                HStack {
                    GradientIcon(
                        systemName: "person.circle.fill",
                        gradient: DesignSystem.Gradients.primary,
                        size: 50
                    )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("User Name")
                            .font(.headline)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        Text("user@email.com")
                            .font(.subheadline)
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                    }
                    
                    Spacer()
                    
                    GradientIcon(
                        systemName: "chevron.right",
                        gradient: DesignSystem.Gradients.primary,
                        size: 16
                    )
                }
                .padding(.vertical, DesignSystem.Spacing.small)
            }
            .buttonStyle(PlainButtonStyle())
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
        CardContainer {
            VStack(spacing: DesignSystem.Spacing.medium) {
                HStack {
                    Text("General")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                    Spacer()
                }
                
                VStack(spacing: DesignSystem.Spacing.medium) {
                    Button(action: {
                        showingRestTimePicker = true
                    }) {
                        HStack {
                            GradientIcon(
                                systemName: "timer",
                                gradient: DesignSystem.Gradients.secondary,
                                size: 24
                            )
                            
                            Text("Default Rest Time")
                                .font(.body)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            
                            Spacer()
                            
                            Text("\(defaultRestTime) seconds")
                                .font(.subheadline)
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                            
                            GradientIcon(
                                systemName: "chevron.right",
                                gradient: DesignSystem.Gradients.primary,
                                size: 16
                            )
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    HStack {
                        GradientIcon(
                            systemName: "scalemass",
                            gradient: DesignSystem.Gradients.success,
                            size: 24
                        )
                        
                        Text("Units")
                            .font(.body)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        
                        Spacer()
                        
                        Text(useKilograms ? "kg" : "lb")
                            .font(.subheadline)
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        
                        Toggle("", isOn: $useKilograms)
                            .labelsHidden()
                    }
                    .padding(.vertical, 4)
                    
                    HStack {
                        GradientIcon(
                            systemName: "moon.fill",
                            gradient: DesignSystem.Gradients.primary,
                            size: 24
                        )
                        
                        Text("Theme")
                            .font(.body)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        
                        Spacer()
                        
                        Text(isDarkTheme ? "Dark" : "Light")
                            .font(.subheadline)
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        
                        Toggle("", isOn: $isDarkTheme)
                            .labelsHidden()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

struct ProfileNotificationsSection: View {
    @Binding var timerNotificationsEnabled: Bool
    @Binding var soundsEnabled: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        CardContainer {
            VStack(spacing: DesignSystem.Spacing.medium) {
                HStack {
                    Text("Notifications")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                    Spacer()
                }
                
                VStack(spacing: DesignSystem.Spacing.medium) {
                    HStack {
                        GradientIcon(
                            systemName: "bell.fill",
                            gradient: DesignSystem.Gradients.error,
                            size: 24
                        )
                        
                        Text("Timer Notifications")
                            .font(.body)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        
                        Spacer()
                        
                        Text(timerNotificationsEnabled ? "On" : "Off")
                            .font(.subheadline)
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        
                        Toggle("", isOn: $timerNotificationsEnabled)
                            .labelsHidden()
                    }
                    .padding(.vertical, 4)
                    
                    HStack {
                        GradientIcon(
                            systemName: "speaker.wave.2.fill",
                            gradient: DesignSystem.Gradients.primary,
                            size: 24
                        )
                        
                        Text("Sounds")
                            .font(.body)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        
                        Spacer()
                        
                        Text(soundsEnabled ? "On" : "Off")
                            .font(.subheadline)
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        
                        Toggle("", isOn: $soundsEnabled)
                            .labelsHidden()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

struct ProfileInformationSection: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        CardContainer {
            VStack(spacing: DesignSystem.Spacing.medium) {
                HStack {
                    Text("Information")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                    Spacer()
                }
                
                VStack(spacing: DesignSystem.Spacing.medium) {
                    Button(action: {
                        // Help & Support action
                    }) {
                        HStack {
                            GradientIcon(
                                systemName: "questionmark.circle",
                                gradient: DesignSystem.Gradients.primary,
                                size: 24
                            )
                            
                            Text("Help & Support")
                                .font(.body)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            
                            Spacer()
                            
                            GradientIcon(
                                systemName: "chevron.right",
                                gradient: DesignSystem.Gradients.primary,
                                size: 16
                            )
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        // Rate App action
                    }) {
                        HStack {
                            GradientIcon(
                                systemName: "star",
                                gradient: DesignSystem.Gradients.warning,
                                size: 24
                            )
                            
                            Text("Rate App")
                                .font(.body)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            
                            Spacer()
                            
                            GradientIcon(
                                systemName: "chevron.right",
                                gradient: DesignSystem.Gradients.primary,
                                size: 16
                            )
                        }
                        .padding(.vertical, 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct ProfileVersionSection: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        CardContainer {
            HStack {
                Spacer()
                Text("Version 1.0.0")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                Spacer()
            }
            .padding(.vertical, DesignSystem.Spacing.small)
        }
    }
}



struct RestTimePickerView: View {
    @Binding var selectedTime: Int
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    private let restTimeOptions = Array(0...300)
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: DesignSystem.Spacing.large) {
                    ModalContainer {
                        VStack(spacing: DesignSystem.Spacing.large) {
                            // Header
                            HStack {
                                GradientIcon(
                                    systemName: "timer",
                                    gradient: DesignSystem.Gradients.secondary,
                                    size: 32
                                )
                                
                                Text("Select Default Rest Time")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                
                                Spacer()
                            }
                            
                            // Picker
                            Picker("Rest Time", selection: $selectedTime) {
                                ForEach(restTimeOptions, id: \.self) { seconds in
                                    Text("\(seconds) seconds").tag(seconds)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(height: 200)
                            
                            // Buttons
                            HStack(spacing: DesignSystem.Spacing.medium) {
                                Button("Cancel") {
                                    isPresented = false
                                }
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                                .padding(.horizontal, DesignSystem.Spacing.large)
                                .padding(.vertical, DesignSystem.Spacing.medium)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                        .fill(DesignSystem.Colors.surfaceBackground(for: colorScheme))
                                )
                                
                                GradientButton(
                                    title: "Done",
                                    gradient: DesignSystem.Gradients.secondary
                                ) {
                                    isPresented = false
                                }
                            }
                        }
                    }
                }
                .padding(DesignSystem.Spacing.large)
            }
        }
    }
}



#Preview {
    ContentView()
}
