import SwiftUI

// MARK: - Personal Info View
struct PersonalInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var firstName = "John"
    @State private var lastName = "Doe"
    @State private var email = "john.doe@example.com"
    @State private var phone = "+1 (555) 123-4567"
    @State private var birthDate = Date()
    @State private var height = "175"
    @State private var weight = "70"
    @State private var showingPasswordChange = false
    @State private var showingDeleteAccount = false
    
    // Mock registration date
    private let registrationDate = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 15)) ?? Date()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Profile Photo Section
                        profilePhotoSection
                        
                        // Personal Information Section
                        personalInfoSection
                        
                        // Physical Information Section
                        physicalInfoSection
                        
                        // Account Information Section
                        accountInfoSection
                        
                        // Danger Zone Section
                        dangerZoneSection
                        
                        // App Version footer
                        appVersionFooter
                    }
                }
            }
            .navigationTitle("Personal Information")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    // Mock save action
                    dismiss()
                }
            )
            .sheet(isPresented: $showingPasswordChange) {
                PasswordChangeView()
            }
            .alert("Delete Account", isPresented: $showingDeleteAccount) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    // Mock delete action
                }
            } message: {
                Text("Are you sure you want to delete your account? This action cannot be undone.")
            }
        }
    }
    
    // MARK: - Profile Photo Section
    private var profilePhotoSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Button("Change Photo") {
                // Mock action
            }
            .font(.subheadline)
            .foregroundColor(.blue)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color(.systemBackground))
        .listRowInsets(EdgeInsets())
    }
    
    // MARK: - Personal Information Section
    private var personalInfoSection: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "Personal Information")
            
            VStack(spacing: 0) {
                SettingsRow(title: "First Name", value: $firstName)
                Divider()
                SettingsRow(title: "Last Name", value: $lastName)
                Divider()
                SettingsRow(title: "Email", value: $email, keyboardType: .emailAddress)
                Divider()
                SettingsRow(title: "Phone", value: $phone, keyboardType: .phonePad)
                Divider()
                SettingsDateRow(title: "Birth Date", date: $birthDate)
            }
            .background(Color(.systemBackground))
        }
        .padding(.top, 20)
    }
    
    // MARK: - Physical Information Section
    private var physicalInfoSection: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "Physical Information")
            
            VStack(spacing: 0) {
                SettingsRow(title: "Height", value: $height, keyboardType: .numberPad, suffix: "cm")
                Divider()
                SettingsRow(title: "Weight", value: $weight, keyboardType: .numberPad, suffix: "kg")
            }
            .background(Color(.systemBackground))
        }
        .padding(.top, 20)
    }
    
    // MARK: - Account Information Section
    private var accountInfoSection: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "Account Information")
            
            VStack(spacing: 0) {
                HStack {
                    Text("Registration Date")
                        .foregroundColor(.primary)
                    Spacer()
                    Text(registrationDate, style: .date)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                Divider()
                
                Button(action: {
                    showingPasswordChange = true
                }) {
                    HStack {
                        Text("Change Password")
                            .foregroundColor(.blue)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
            }
            .background(Color(.systemBackground))
        }
        .padding(.top, 20)
    }
    
    // MARK: - Danger Zone Section
    private var dangerZoneSection: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "Danger Zone")
            
            Button(action: {
                showingDeleteAccount = true
            }) {
                HStack {
                    Text("Delete Account")
                        .foregroundColor(.red)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(Color(.systemBackground))
        }
        .padding(.top, 20)
    }
    
    // MARK: - App Version Footer
    private var appVersionFooter: some View {
        VStack {
            Text(appVersionString())
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 32)
        .padding(.bottom, 20)
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .textCase(.uppercase)
                .tracking(0.5)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}

// MARK: - Settings Row
struct SettingsRow: View {
    let title: String
    @Binding var value: String
    var keyboardType: UIKeyboardType = .default
    var suffix: String?
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.primary)
            Spacer()
            
            HStack(spacing: 4) {
                TextField("", text: $value)
                    .keyboardType(keyboardType)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.primary)
                
                if let suffix = suffix {
                    Text(suffix)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Settings Date Row
struct SettingsDateRow: View {
    let title: String
    @Binding var date: Date
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.primary)
            Spacer()
            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

// MARK: - Password Change View
struct PasswordChangeView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.blue)
                        
                        Text("Change Password")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .padding(.top, 20)
                    
                    // Form fields
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Current Password")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            SecureField("Enter current password", text: $currentPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("New Password")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            SecureField("Enter new password", text: $newPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm New Password")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            SecureField("Confirm new password", text: $confirmPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    
                    // Info text
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.orange)
                        
                        Text("Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one number.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    // Buttons
                    VStack(spacing: 12) {
                        Button("Save") {
                            // Mock save action
                            dismiss()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        
                        Button("Cancel") {
                            dismiss()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray5))
                        .foregroundColor(.primary)
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Helpers
private func appVersionString() -> String {
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    return "Version \(version) (\(build))"
}
