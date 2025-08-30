import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingPrivacySettings = false
    @State private var showingGeneralSettings = false
    @State private var showingNotificationsSettings = false
    @State private var showingSupportSettings = false
    
    var body: some View {
        NavigationView {
            List {
                // Privacy & Security Section
                Section {
                    NavigationLink(destination: PrivacySettingsView()) {
                        SettingsMenuRow(
                            icon: "lock.shield.fill",
                            iconColor: .blue,
                            title: "Privacy & Security",
                            subtitle: "Control access to your data"
                        )
                    }
                    
                    NavigationLink(destination: GeneralSettingsView()) {
                        SettingsMenuRow(
                            icon: "gear",
                            iconColor: .gray,
                            title: "General",
                            subtitle: "Basic app preferences"
                        )
                    }
                } header: {
                    Text("Security & Preferences")
                }
                
                // Notifications Section
                Section {
                    NavigationLink(destination: NotificationsSettingsView()) {
                        SettingsMenuRow(
                            icon: "bell.fill",
                            iconColor: .red,
                            title: "Notifications",
                            subtitle: "Manage app alerts and sounds"
                        )
                    }
                } header: {
                    Text("Alerts & Sounds")
                }
                
                // Support & Feedback Section
                Section {
                    NavigationLink(destination: SupportSettingsView()) {
                        SettingsMenuRow(
                            icon: "questionmark.circle.fill",
                            iconColor: .blue,
                            title: "Help & Support",
                            subtitle: "Get help and provide feedback"
                        )
                    }
                    
                    Button(action: {
                        // Rate app action
                    }) {
                        SettingsMenuRow(
                            icon: "star.fill",
                            iconColor: .yellow,
                            title: "Rate App",
                            subtitle: "Share your experience"
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                } header: {
                    Text("Support & Feedback")
                }
                
                // About Section
                Section {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("About Gym Diary")
                                .font(.body)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            
                            Text("Version 1.0.0")
                                .font(.caption)
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("App Information")
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
        }
    }
}

// MARK: - Settings Row Component
struct SettingsMenuRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Privacy Settings View
struct PrivacySettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingCameraPermission = false
    @State private var showingMicrophonePermission = false
    @State private var showingHealthPermission = false
    
    var body: some View {
        List {
            // App Permissions Section
            Section {
                NavigationLink(destination: PermissionDetailView(
                    title: "Camera",
                    description: "Allow Gym Diary to access your camera for taking photos of exercises and form checks.",
                    icon: "camera.fill",
                    iconColor: .gray
                )) {
                    PermissionRow(
                        icon: "camera.fill",
                        iconColor: .gray,
                        title: "Camera",
                        subtitle: "Take exercise photos",
                        accessCount: "0"
                    )
                }
                
                NavigationLink(destination: PermissionDetailView(
                    title: "Microphone",
                    description: "Allow Gym Diary to access your microphone for voice notes and audio feedback during workouts.",
                    icon: "mic.fill",
                    iconColor: .orange
                )) {
                    PermissionRow(
                        icon: "mic.fill",
                        iconColor: .orange,
                        title: "Microphone",
                        subtitle: "Voice notes and feedback",
                        accessCount: "0"
                    )
                }
                
                NavigationLink(destination: PermissionDetailView(
                    title: "Health & Fitness",
                    description: "Allow Gym Diary to access your Health data to sync workout information and track your fitness progress.",
                    icon: "heart.fill",
                    iconColor: .red
                )) {
                    PermissionRow(
                        icon: "heart.fill",
                        iconColor: .red,
                        title: "Health & Fitness",
                        subtitle: "Sync workout data",
                        accessCount: "0"
                    )
                }
            } header: {
                Text("App Permissions")
            } footer: {
                Text("These permissions allow Gym Diary to provide you with the best workout experience. You can change these settings at any time.")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
            }
            
            // Data Privacy Section
            Section {
                NavigationLink(destination: DataPrivacyView()) {
                    SettingsMenuRow(
                        icon: "shield.checkered",
                        iconColor: .green,
                        title: "Data Privacy",
                        subtitle: "Control how your data is used"
                    )
                }
                
                NavigationLink(destination: AnalyticsView()) {
                    SettingsMenuRow(
                        icon: "chart.bar.fill",
                        iconColor: .blue,
                        title: "Analytics & Improvements",
                        subtitle: "Help improve the app"
                    )
                }
            } header: {
                Text("Data & Privacy")
            } footer: {
                Text("Your personal workout data is stored locally on your device and is never shared with third parties without your explicit consent.")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Privacy & Security")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Permission Row Component
struct PermissionRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let accessCount: String
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
            }
            
            Spacer()
            
            Text(accessCount)
                .font(.caption)
                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Permission Detail View
struct PermissionDetailView: View {
    let title: String
    let description: String
    let icon: String
    let iconColor: Color
    @Environment(\.colorScheme) private var colorScheme
    @State private var isEnabled = false
    
    var body: some View {
        List {
            Section {
                HStack(spacing: 12) {
                    Image(systemName: icon)
                        .font(.largeTitle)
                        .foregroundColor(iconColor)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        
                        Text("Permission Status")
                            .font(.caption)
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 8)
            }
            
            Section {
                Toggle("Allow \(title) Access", isOn: $isEnabled)
                    .tint(.blue)
            } header: {
                Text("Access Control")
            } footer: {
                Text(description)
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
            }
            
            if isEnabled {
                Section {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Access Granted")
                            .foregroundColor(.green)
                        Spacer()
                    }
                } header: {
                    Text("Current Status")
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - General Settings View
struct GeneralSettingsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var isDarkTheme = true
    @State private var useKilograms = true
    @State private var defaultRestTime = 60
    @State private var showingRestTimePicker = false
    
    var body: some View {
        List {
            Section {
                Toggle("Dark Theme", isOn: $isDarkTheme)
                    .tint(.blue)
            } header: {
                Text("Appearance")
            } footer: {
                Text("Choose between light and dark themes to match your device preferences.")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
            }
            
            Section {
                Toggle("Use Kilograms", isOn: $useKilograms)
                    .tint(.green)
            } header: {
                Text("Units")
            } footer: {
                Text("Toggle between kilograms (kg) and pounds (lbs) for weight measurements.")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
            }
            
            Section {
                HStack {
                    Text("Default Rest Time")
                    Spacer()
                    Button("\(defaultRestTime) seconds") {
                        showingRestTimePicker = true
                    }
                    .foregroundColor(.blue)
                }
            } header: {
                Text("Workout Preferences")
            } footer: {
                Text("Set the default rest time between sets. You can always adjust this during your workout.")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("General")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showingRestTimePicker) {
            RestTimePickerView(
                selectedTime: $defaultRestTime,
                isPresented: $showingRestTimePicker
            )
            .presentationDetents([.medium])
        }
    }
}

// MARK: - Notifications Settings View
struct NotificationsSettingsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var timerNotificationsEnabled = true
    @State private var soundsEnabled = true
    @State private var workoutRemindersEnabled = true
    
    var body: some View {
        List {
            Section {
                Toggle("Timer Notifications", isOn: $timerNotificationsEnabled)
                    .tint(.red)
                
                Toggle("Sounds", isOn: $soundsEnabled)
                    .tint(.blue)
                
                Toggle("Workout Reminders", isOn: $workoutRemindersEnabled)
                    .tint(.green)
            } header: {
                Text("Notification Types")
            } footer: {
                Text("Control which types of notifications you receive from Gym Diary.")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
            }
            
            if timerNotificationsEnabled {
                Section {
                    HStack {
                        Text("Rest Timer Sound")
                        Spacer()
                        Text("Default")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("Timer Settings")
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Support Settings View
struct SupportSettingsView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        List {
            Section {
                Button(action: {
                    // Open help documentation
                }) {
                    HStack {
                        Image(systemName: "book.fill")
                            .foregroundColor(.blue)
                        Text("User Guide")
                        Spacer()
                        Image(systemName: "arrow.up.right.square")
                            .foregroundColor(.blue)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    // Open FAQ
                }) {
                    HStack {
                        Image(systemName: "questionmark.circle.fill")
                            .foregroundColor(.orange)
                        Text("Frequently Asked Questions")
                        Spacer()
                        Image(systemName: "arrow.up.right.square")
                            .foregroundColor(.orange)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            } header: {
                Text("Help Resources")
            }
            
            Section {
                Button(action: {
                    // Contact support
                }) {
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.green)
                        Text("Contact Support")
                        Spacer()
                        Image(systemName: "arrow.up.right.square")
                            .foregroundColor(.green)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    // Report bug
                }) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text("Report a Bug")
                        Spacer()
                        Image(systemName: "arrow.up.right.square")
                            .foregroundColor(.red)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            } header: {
                Text("Support & Feedback")
            } footer: {
                Text("We're here to help! Contact us if you have any questions or need assistance.")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Help & Support")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Data Privacy View
struct DataPrivacyView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var dataSharingEnabled = false
    @State private var analyticsEnabled = true
    
    var body: some View {
        List {
            Section {
                Toggle("Data Sharing", isOn: $dataSharingEnabled)
                    .tint(.blue)
            } header: {
                Text("Data Control")
            } footer: {
                Text("Control whether your anonymized workout data can be used to improve the app experience.")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
            }
            
            Section {
                Toggle("Analytics", isOn: $analyticsEnabled)
                    .tint(.green)
            } header: {
                Text("Usage Analytics")
            } footer: {
                Text("Help us improve Gym Diary by sharing anonymous usage statistics. Your personal data is never collected.")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
            }
            
            Section {
                HStack {
                    Text("Data Export")
                    Spacer()
                    Button("Export") {
                        // Export data action
                    }
                    .foregroundColor(.blue)
                }
                
                HStack {
                    Text("Delete All Data")
                    Spacer()
                    Button("Delete") {
                        // Delete data action
                    }
                    .foregroundColor(.red)
                }
            } header: {
                Text("Data Management")
            } footer: {
                Text("Export your workout data or permanently delete all information from the app.")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Data Privacy")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Analytics View
struct AnalyticsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var crashReportsEnabled = true
    @State private var performanceDataEnabled = true
    
    var body: some View {
        List {
            Section {
                Toggle("Crash Reports", isOn: $crashReportsEnabled)
                    .tint(.red)
                
                Toggle("Performance Data", isOn: $performanceDataEnabled)
                    .tint(.blue)
            } header: {
                Text("Data Collection")
            } footer: {
                Text("Help us identify and fix issues by sharing crash reports and performance data. All information is anonymous.")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
            }
            
            Section {
                HStack {
                    Text("Last Report Sent")
                    Spacer()
                    Text("Today")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Reports This Month")
                    Spacer()
                    Text("3")
                        .foregroundColor(.secondary)
                }
            } header: {
                Text("Analytics Summary")
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Analytics & Improvements")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Rest Time Picker View (reuse existing from ContentView)

#Preview {
    SettingsView()
}
