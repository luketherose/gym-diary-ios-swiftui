import SwiftUI
import MessageUI

// MARK: - Help & Support View
struct HelpSupportView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var showingContactForm = false
    @State private var showingFAQ = false
    @State private var showingTutorial = false
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: DesignSystem.Spacing.large) {
                        // Header Section
                        VStack(spacing: DesignSystem.Spacing.medium) {
                            // App Icon
                            ZStack {
                                Circle()
                                    .fill(DesignSystem.Gradients.primary)
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "dumbbell.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            }
                            
                            Text("Help & Support")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            
                            Text("We're here to help you get the most out of your fitness journey")
                                .font(.body)
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, DesignSystem.Spacing.large)
                        
                        // Quick Actions Grid
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: DesignSystem.Spacing.medium), count: 2), spacing: DesignSystem.Spacing.medium) {
                            // FAQ Card
                            HelpSupportCard(
                                icon: "questionmark.circle.fill",
                                title: "FAQ",
                                subtitle: "Common questions",
                                gradient: DesignSystem.Gradients.primary,
                                action: { showingFAQ = true }
                            )
                            
                            // Tutorial Card
                            HelpSupportCard(
                                icon: "play.circle.fill",
                                title: "Tutorial",
                                subtitle: "Learn the basics",
                                gradient: DesignSystem.Gradients.secondary,
                                action: { showingTutorial = true }
                            )
                            
                            // Contact Card
                            HelpSupportCard(
                                icon: "envelope.fill",
                                title: "Contact Us",
                                subtitle: "Get in touch",
                                gradient: DesignSystem.Gradients.success,
                                action: { showingContactForm = true }
                            )
                            
                            // Report Bug Card
                            HelpSupportCard(
                                icon: "exclamationmark.triangle.fill",
                                title: "Report Bug",
                                subtitle: "Help us improve",
                                gradient: DesignSystem.Gradients.warning,
                                action: { showingContactForm = true }
                            )
                        }
                        .padding(.horizontal, DesignSystem.Spacing.large)
                        
                        // Support Options
                        VStack(spacing: DesignSystem.Spacing.medium) {
                            Text("Other Ways to Get Help")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            
                            VStack(spacing: DesignSystem.Spacing.small) {
                                HelpSupportRow(
                                    icon: "globe",
                                    title: "Visit our website",
                                    subtitle: "gymdiary.app/support",
                                    action: { openWebsite() }
                                )
                                
                                HelpSupportRow(
                                    icon: "message.fill",
                                    title: "Live Chat",
                                    subtitle: "Available 24/7",
                                    action: { openLiveChat() }
                                )
                                
                                HelpSupportRow(
                                    icon: "person.2.fill",
                                    title: "Community Forum",
                                    subtitle: "Connect with users",
                                    action: { openCommunity() }
                                )
                            }
                            .padding(.horizontal, DesignSystem.Spacing.large)
                        }
                        
                        // App Version Info
                        VStack(spacing: DesignSystem.Spacing.small) {
                            Text("App Version 1.0.0")
                                .font(.caption)
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                            
                            Text("Build 2025.08.16")
                                .font(.caption2)
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        }
                        .padding(.top, DesignSystem.Spacing.large)
                        .padding(.bottom, DesignSystem.Spacing.large)
                    }
                }
            }
            .navigationTitle("Help & Support")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.Colors.primary)
                }
            }
        }
        .sheet(isPresented: $showingFAQ) {
            FAQView()
        }
        .sheet(isPresented: $showingTutorial) {
            TutorialView()
        }
        .sheet(isPresented: $showingContactForm) {
            ContactFormView()
        }
    }
    
    private func openWebsite() {
        if let url = URL(string: "https://gymdiary.app/support") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openLiveChat() {
        // Implement live chat functionality
        print("Opening live chat...")
    }
    
    private func openCommunity() {
        if let url = URL(string: "https://community.gymdiary.app") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Help Support Card
struct HelpSupportCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let gradient: LinearGradient
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: DesignSystem.Spacing.medium) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(
                        Circle()
                            .fill(gradient)
                    )
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(DesignSystem.Spacing.large)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .fill(Color(.systemBackground))
                    .shadow(
                        color: Color.black.opacity(0.1),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Help Support Row
struct HelpSupportRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignSystem.Spacing.medium) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(DesignSystem.Colors.primary)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(DesignSystem.Spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .fill(Color(.systemBackground))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - FAQ View
struct FAQView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    private let faqs = [
        FAQ(question: "How do I create a new workout?", answer: "Tap the + button in any section to create a new workout. You can then add exercises and customize the workout to your needs."),
        FAQ(question: "Can I track my progress?", answer: "Yes! The app automatically tracks your workout history, including when you last performed each workout and your exercise progress."),
        FAQ(question: "How do I organize my workouts?", answer: "Create sections to group related workouts together. For example, you might have 'Push Day', 'Pull Day', and 'Legs Day' sections."),
        FAQ(question: "Can I customize workout icons and colors?", answer: "Absolutely! When creating a workout, you can choose from 20 different fitness icons and 8 color options to make your workouts easily identifiable."),
        FAQ(question: "How do I add exercises to a workout?", answer: "After creating a workout, tap on it to open the workout details, then use the + button to add exercises with sets, reps, and weights."),
        FAQ(question: "Is my data saved locally?", answer: "Yes, all your workout data is stored locally on your device. You can also enable iCloud sync in the settings to backup your data."),
        FAQ(question: "How do I change the app theme?", answer: "Go to Profile > General Settings and toggle between Light and Dark themes. The app remembers your preference."),
        FAQ(question: "Can I export my workout data?", answer: "Currently, the app supports basic data export. We're working on more advanced export options for future updates.")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: DesignSystem.Spacing.medium) {
                        ForEach(faqs) { faq in
                            FAQRow(faq: faq)
                        }
                    }
                    .padding(DesignSystem.Spacing.large)
                }
            }
            .navigationTitle("Frequently Asked Questions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.Colors.primary)
                }
            }
        }
    }
}

// MARK: - FAQ Model
struct FAQ: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

// MARK: - FAQ Row
struct FAQRow: View {
    let faq: FAQ
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(faq.question)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                Text(faq.answer)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(DesignSystem.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                .fill(Color(.systemBackground))
                .shadow(
                    color: Color.black.opacity(0.05),
                    radius: 4,
                    x: 0,
                    y: 2
                )
        )
    }
}

// MARK: - Tutorial View
struct TutorialView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var currentPage = 0
    
    private let tutorialPages = [
        TutorialPage(
            title: "Welcome to Gym Diary!",
            subtitle: "Your personal fitness companion",
            description: "Track your workouts, monitor progress, and stay motivated with our intuitive fitness app.",
            imageName: "dumbbell.fill",
            gradient: DesignSystem.Gradients.primary
        ),
        TutorialPage(
            title: "Create Workouts",
            subtitle: "Build your fitness routine",
            description: "Tap the + button to create custom workouts. Choose from 20 fitness icons and 8 colors to personalize your experience.",
            imageName: "plus.circle.fill",
            gradient: DesignSystem.Gradients.secondary
        ),
        TutorialPage(
            title: "Track Progress",
            subtitle: "Monitor your fitness journey",
            description: "Record sets, reps, and weights for each exercise. View your workout history and track improvements over time.",
            imageName: "chart.line.uptrend.xyaxis",
            gradient: DesignSystem.Gradients.success
        ),
        TutorialPage(
            title: "Stay Organized",
            subtitle: "Keep workouts structured",
            description: "Group workouts into sections like 'Push/Pull/Legs' or 'Upper/Lower Body' for better organization.",
            imageName: "folder.fill",
            gradient: DesignSystem.Gradients.warning
        )
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Tutorial Content
                    TabView(selection: $currentPage) {
                        ForEach(0..<tutorialPages.count, id: \.self) { index in
                            TutorialPageView(page: tutorialPages[index])
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    
                    // Navigation Buttons
                    HStack(spacing: DesignSystem.Spacing.medium) {
                        if currentPage > 0 {
                            Button("Previous") {
                                withAnimation {
                                    currentPage -= 1
                                }
                            }
                            .foregroundColor(DesignSystem.Colors.primary)
                        }
                        
                        Spacer()
                        
                        if currentPage < tutorialPages.count - 1 {
                            Button("Next") {
                                withAnimation {
                                    currentPage += 1
                                }
                            }
                            .foregroundColor(DesignSystem.Colors.primary)
                        } else {
                            Button("Get Started") {
                                dismiss()
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, DesignSystem.Spacing.large)
                            .padding(.vertical, DesignSystem.Spacing.medium)
                            .background(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                    .fill(DesignSystem.Colors.primary)
                            )
                        }
                    }
                    .padding(DesignSystem.Spacing.large)
                }
            }
            .navigationTitle("Tutorial")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Skip") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.Colors.primary)
                }
            }
        }
    }
}

// MARK: - Tutorial Page Model
struct TutorialPage {
    let title: String
    let subtitle: String
    let description: String
    let imageName: String
    let gradient: LinearGradient
}

// MARK: - Tutorial Page View
struct TutorialPageView: View {
    let page: TutorialPage
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(page.gradient)
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.imageName)
                    .font(.system(size: 60))
                    .foregroundColor(.white)
            }
            
            // Text Content
            VStack(spacing: DesignSystem.Spacing.medium) {
                Text(page.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.primary)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.body)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignSystem.Spacing.large)
            }
            
            Spacer()
        }
        .padding(DesignSystem.Spacing.large)
    }
}

// MARK: - Contact Form View
struct ContactFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var name = ""
    @State private var email = ""
    @State private var subject = "General Inquiry"
    @State private var message = ""
    @State private var showingMailComposer = false
    
    private let subjects = ["General Inquiry", "Bug Report", "Feature Request", "Account Issue", "Other"]
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: DesignSystem.Spacing.large) {
                        // Header
                        VStack(spacing: DesignSystem.Spacing.medium) {
                            Image(systemName: "envelope.fill")
                                .font(.system(size: 50))
                                .foregroundColor(DesignSystem.Colors.primary)
                            
                            Text("Get in Touch")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            
                            Text("We'd love to hear from you. Send us a message and we'll respond as soon as possible.")
                                .font(.body)
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, DesignSystem.Spacing.large)
                        
                        // Form
                        VStack(spacing: DesignSystem.Spacing.medium) {
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                                Text("Name")
                                    .font(.headline)
                                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                
                                TextField("Your name", text: $name)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                                Text("Email")
                                    .font(.headline)
                                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                
                                TextField("your.email@example.com", text: $email)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                            }
                            
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                                Text("Subject")
                                    .font(.headline)
                                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                
                                Picker("Subject", selection: $subject) {
                                    ForEach(subjects, id: \.self) { subject in
                                        Text(subject).tag(subject)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .background(
                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                        .fill(Color(.systemBackground))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                                .stroke(Color(.systemGray4), lineWidth: 1)
                                        )
                                )
                            }
                            
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                                Text("Message")
                                    .font(.headline)
                                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                
                                TextEditor(text: $message)
                                    .frame(minHeight: 120)
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                            .fill(Color(.systemBackground))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                                    .stroke(Color(.systemGray4), lineWidth: 1)
                                            )
                                    )
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.large)
                        
                        // Send Button
                        Button(action: {
                            showingMailComposer = true
                        }) {
                            HStack {
                                Image(systemName: "paperplane.fill")
                                Text("Send Message")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(DesignSystem.Spacing.medium)
                            .background(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                    .fill(DesignSystem.Colors.primary)
                            )
                        }
                        .disabled(name.isEmpty || email.isEmpty || message.isEmpty)
                        .opacity(name.isEmpty || email.isEmpty || message.isEmpty ? 0.6 : 1.0)
                        .padding(.horizontal, DesignSystem.Spacing.large)
                        
                        // Alternative Contact Methods
                        VStack(spacing: DesignSystem.Spacing.medium) {
                            Text("Or contact us directly:")
                                .font(.caption)
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                            
                            HStack(spacing: DesignSystem.Spacing.large) {
                                Button(action: { openEmail() }) {
                                    VStack(spacing: 4) {
                                        Image(systemName: "envelope.fill")
                                            .font(.title2)
                                        Text("Email")
                                            .font(.caption)
                                    }
                                    .foregroundColor(DesignSystem.Colors.primary)
                                }
                                
                                Button(action: { openPhone() }) {
                                    VStack(spacing: 4) {
                                        Image(systemName: "phone.fill")
                                            .font(.title2)
                                        Text("Call")
                                            .font(.caption)
                                    }
                                    .foregroundColor(DesignSystem.Colors.primary)
                                }
                            }
                        }
                        .padding(.top, DesignSystem.Spacing.large)
                        .padding(.bottom, DesignSystem.Spacing.large)
                    }
                }
            }
            .navigationTitle("Contact Us")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.Colors.primary)
                }
            }
        }
        .sheet(isPresented: $showingMailComposer) {
            MailComposerView(
                name: name,
                email: email,
                subject: subject,
                message: message
            )
        }
    }
    
    private func openEmail() {
        if let url = URL(string: "mailto:support@gymdiary.app") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openPhone() {
        if let url = URL(string: "tel:+1234567890") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Mail Composer View
struct MailComposerView: UIViewControllerRepresentable {
    let name: String
    let email: String
    let subject: String
    let message: String
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = context.coordinator
        composer.setToRecipients(["support@gymdiary.app"])
        composer.setSubject("Gym Diary Support: \(subject)")
        composer.setMessageBody("""
        Name: \(name)
        Email: \(email)
        Subject: \(subject)
        
        Message:
        \(message)
        """, isHTML: false)
        return composer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }
}
