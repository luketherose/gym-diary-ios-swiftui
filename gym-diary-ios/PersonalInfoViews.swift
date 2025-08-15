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
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: DesignSystem.Spacing.large) {
                        PersonalInfoPhotoSection()
                        PersonalInfoDetailsSection(
                            firstName: $firstName,
                            lastName: $lastName,
                            email: $email,
                            phone: $phone,
                            birthDate: $birthDate
                        )
                        PersonalInfoPhysicalSection(
                            height: $height,
                            weight: $weight
                        )
                        PersonalInfoAccountSection(
                            registrationDate: registrationDate,
                            showingPasswordChange: $showingPasswordChange
                        )
                        PersonalInfoDangerSection(
                            showingDeleteAccount: $showingDeleteAccount
                        )
                    }
                    .padding(DesignSystem.Spacing.large)
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
}

// MARK: - Personal Info Sub-Components
struct PersonalInfoPhotoSection: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        CardContainer {
            HStack {
                Spacer()
                VStack(spacing: DesignSystem.Spacing.medium) {
                    GradientIcon(
                        systemName: "person.circle.fill",
                        gradient: DesignSystem.Gradients.primary,
                        size: 80
                    )
                    
                    Button("Change Photo") {
                        // Mock action
                    }
                    .font(.subheadline)
                    .foregroundColor(DesignSystem.Colors.primary)
                }
                Spacer()
            }
            .padding(.vertical, DesignSystem.Spacing.small)
        }
    }
}

struct PersonalInfoDetailsSection: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var email: String
    @Binding var phone: String
    @Binding var birthDate: Date
    
    var body: some View {
        CardContainer {
            VStack(spacing: DesignSystem.Spacing.medium) {
                HStack {
                    Text("Personal Information")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                    Spacer()
                }
                
                VStack(spacing: DesignSystem.Spacing.medium) {
                    PersonalInfoRow(title: "First Name", text: $firstName)
                    PersonalInfoRow(title: "Last Name", text: $lastName)
                    PersonalInfoRow(title: "Email", text: $email, keyboardType: .emailAddress)
                    PersonalInfoRow(title: "Phone", text: $phone, keyboardType: .phonePad)
                    PersonalInfoDateRow(title: "Birth Date", date: $birthDate)
                }
            }
        }
    }
}

struct PersonalInfoPhysicalSection: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var height: String
    @Binding var weight: String
    
    var body: some View {
        CardContainer {
            VStack(spacing: DesignSystem.Spacing.medium) {
                HStack {
                    Text("Physical Information")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                    Spacer()
                }
                
                VStack(spacing: DesignSystem.Spacing.medium) {
                    PersonalInfoRow(title: "Height (cm)", text: $height, keyboardType: .numberPad, suffix: "cm")
                    PersonalInfoRow(title: "Weight (kg)", text: $weight, keyboardType: .numberPad, suffix: "kg")
                }
            }
        }
    }
}

struct PersonalInfoAccountSection: View {
    @Environment(\.colorScheme) private var colorScheme
    let registrationDate: Date
    @Binding var showingPasswordChange: Bool
    
    var body: some View {
        CardContainer {
            VStack(spacing: DesignSystem.Spacing.medium) {
                HStack {
                    Text("Account Information")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                    Spacer()
                }
                
                VStack(spacing: DesignSystem.Spacing.medium) {
                    HStack {
                        Text("Registration Date")
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        Spacer()
                        Text(registrationDate, style: .date)
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                    }
                    
                    Button(action: {
                        showingPasswordChange = true
                    }) {
                        HStack {
                            Text("Change Password")
                                .foregroundColor(DesignSystem.Colors.primary)
                            Spacer()
                            GradientIcon(
                                systemName: "chevron.right",
                                gradient: DesignSystem.Gradients.primary,
                                size: 16
                            )
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct PersonalInfoDangerSection: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var showingDeleteAccount: Bool
    
    var body: some View {
        CardContainer {
            VStack(spacing: DesignSystem.Spacing.medium) {
                HStack {
                    Text("Danger Zone")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(DesignSystem.Colors.error)
                    Spacer()
                }
                
                Button(action: {
                    showingDeleteAccount = true
                }) {
                    HStack {
                        GradientIcon(
                            systemName: "trash.fill",
                            gradient: DesignSystem.Gradients.error,
                            size: 20
                        )
                        
                        Text("Delete Account")
                            .foregroundColor(DesignSystem.Colors.error)
                        Spacer()
                        
                        GradientIcon(
                            systemName: "chevron.right",
                            gradient: DesignSystem.Gradients.error,
                            size: 16
                        )
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

struct PersonalInfoRow: View {
    @Environment(\.colorScheme) private var colorScheme
    let title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var suffix: String?
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
            Spacer()
            TextField(title, text: $text)
                .multilineTextAlignment(.trailing)
                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                .keyboardType(keyboardType)
                .autocapitalization(keyboardType == .emailAddress ? .none : .sentences)
            if let suffix = suffix {
                Text(suffix)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                    .font(.caption)
            }
        }
    }
}

struct PersonalInfoDateRow: View {
    @Environment(\.colorScheme) private var colorScheme
    let title: String
    @Binding var date: Date
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
            Spacer()
            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
        }
    }
}

struct PasswordChangeView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    
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
                                    systemName: "lock.fill",
                                    gradient: DesignSystem.Gradients.primary,
                                    size: 32
                                )
                                
                                Text("Change Password")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                
                                Spacer()
                            }
                            
                            // Form fields
                            VStack(spacing: DesignSystem.Spacing.medium) {
                                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                                    Text("Current Password")
                                        .font(.headline)
                                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                    
                                    SecureField("Enter current password", text: $currentPassword)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .background(
                                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                                .fill(DesignSystem.Colors.surfaceBackground(for: colorScheme))
                                        )
                                }
                                
                                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                                    Text("New Password")
                                        .font(.headline)
                                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                    
                                    SecureField("Enter new password", text: $newPassword)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .background(
                                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                                .fill(DesignSystem.Colors.surfaceBackground(for: colorScheme))
                                        )
                                }
                                
                                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                                    Text("Confirm New Password")
                                        .font(.headline)
                                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                    
                                    SecureField("Confirm new password", text: $confirmPassword)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .background(
                                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                                .fill(DesignSystem.Colors.surfaceBackground(for: colorScheme))
                                        )
                                }
                            }
                            
                            // Info text
                            HStack {
                                GradientIcon(
                                    systemName: "info.circle.fill",
                                    gradient: DesignSystem.Gradients.warning,
                                    size: 16
                                )
                                
                                Text("Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, and one number.")
                                    .font(.caption)
                                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                                
                                Spacer()
                            }
                            
                            // Buttons
                            HStack(spacing: DesignSystem.Spacing.medium) {
                                Button("Cancel") {
                                    dismiss()
                                }
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                                .padding(.horizontal, DesignSystem.Spacing.large)
                                .padding(.vertical, DesignSystem.Spacing.medium)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                        .fill(DesignSystem.Colors.surfaceBackground(for: colorScheme))
                                )
                                
                                GradientButton(
                                    title: "Save",
                                    gradient: DesignSystem.Gradients.primary
                                ) {
                                    // Mock save action
                                    dismiss()
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
