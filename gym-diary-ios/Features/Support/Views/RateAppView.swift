import SwiftUI
import StoreKit

// MARK: - Rate App View
struct RateAppView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedRating = 0
    @State private var showingFeedback = false
    @State private var feedbackText = ""
    @State private var showingThankYou = false
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: DesignSystem.Spacing.large) {
                        // Header Section
                        VStack(spacing: DesignSystem.Spacing.medium) {
                            // App Icon with Stars
                            ZStack {
                                Circle()
                                    .fill(DesignSystem.Gradients.primary)
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: "dumbbell.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                            }
                            .overlay(
                                // Floating stars
                                ZStack {
                                    ForEach(0..<5) { index in
                                        Image(systemName: "star.fill")
                                            .font(.title2)
                                            .foregroundColor(.yellow)
                                            .offset(
                                                x: CGFloat(index - 2) * 25,
                                                y: -60
                                            )
                                            .opacity(0.8)
                                    }
                                }
                            )
                            
                            Text("Rate Gym Diary")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            
                            Text("Your feedback helps us improve and motivates us to keep building amazing features for your fitness journey.")
                                .font(.body)
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, DesignSystem.Spacing.large)
                        }
                        .padding(.top, DesignSystem.Spacing.large)
                        
                        // Rating Section
                        VStack(spacing: DesignSystem.Spacing.large) {
                            Text("How would you rate your experience?")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            
                            // Star Rating
                            HStack(spacing: DesignSystem.Spacing.medium) {
                                ForEach(1...5, id: \.self) { star in
                                    Button(action: {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                            selectedRating = star
                                        }
                                    }) {
                                        Image(systemName: star <= selectedRating ? "star.fill" : "star")
                                            .font(.system(size: 40))
                                            .foregroundColor(star <= selectedRating ? .yellow : .gray)
                                            .scaleEffect(star <= selectedRating ? 1.1 : 1.0)
                                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedRating)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            
                            // Rating Description
                            if selectedRating > 0 {
                                Text(ratingDescription)
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundColor(DesignSystem.Colors.primary)
                                    .multilineTextAlignment(.center)
                                    .transition(.opacity.combined(with: .scale))
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.large)
                        
                        // Action Buttons
                        if selectedRating > 0 {
                            VStack(spacing: DesignSystem.Spacing.medium) {
                                // Rate on App Store Button
                                Button(action: rateOnAppStore) {
                                    HStack {
                                        Image(systemName: "star.fill")
                                        Text("Rate on App Store")
                                    }
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(DesignSystem.Gradients.primary)
                                    .cornerRadius(DesignSystem.CornerRadius.medium)
                                }
                                
                                // Share Feedback Button
                                Button(action: {
                                    showingFeedback = true
                                }) {
                                    HStack {
                                        Image(systemName: "message.fill")
                                        Text("Share Feedback")
                                    }
                                    .font(.headline)
                                    .foregroundColor(DesignSystem.Colors.primary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                            .stroke(DesignSystem.Colors.primary, lineWidth: 2)
                                    )
                                }
                            }
                            .padding(.horizontal, DesignSystem.Spacing.large)
                        }
                        
                        // Benefits Section
                        VStack(spacing: DesignSystem.Spacing.large) {
                            Text("Why Rate Us?")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            
                            VStack(spacing: DesignSystem.Spacing.medium) {
                                BenefitRow(
                                    icon: "heart.fill",
                                    title: "Help Other Users",
                                    description: "Your rating helps other fitness enthusiasts discover our app"
                                )
                                
                                BenefitRow(
                                    icon: "gear.fill",
                                    title: "Improve the App",
                                    description: "Your feedback directly influences our development priorities"
                                )
                                
                                BenefitRow(
                                    icon: "star.fill",
                                    title: "Support Development",
                                    description: "High ratings help us continue building amazing features"
                                )
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.large)
                        
                        Spacer(minLength: DesignSystem.Spacing.large)
                    }
                }
            }
            .navigationTitle("Rate App")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                }
            }
        }
        .sheet(isPresented: $showingFeedback) {
            FeedbackView(
                rating: selectedRating,
                feedbackText: $feedbackText,
                showingThankYou: $showingThankYou
            )
        }
        .sheet(isPresented: $showingThankYou) {
            ThankYouView()
        }
    }
    
    private var ratingDescription: String {
        switch selectedRating {
        case 1: return "Terrible - We need to improve!"
        case 2: return "Poor - Not what you expected"
        case 3: return "Okay - Room for improvement"
        case 4: return "Good - Almost there!"
        case 5: return "Excellent - Love it!"
        default: return ""
        }
    }
    
    private func rateOnAppStore() {
        // Request App Store review with availability check
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            // Suppress deprecation warning for now since AppStore module isn't available
            #if compiler(>=5.9)
            if #available(iOS 18.0, *) {
                // Use new API when available
                // AppStore.requestReview(in: scene) // Uncomment when AppStore module is available
            } else {
                SKStoreReviewController.requestReview(in: scene)
            }
            #else
            SKStoreReviewController.requestReview(in: scene)
            #endif
        }
        
        // Also open App Store page as fallback
        if let url = URL(string: "https://apps.apple.com/app/gym-diary/id1234567890") {
            UIApplication.shared.open(url)
        }
        
        dismiss()
    }
}

// MARK: - Benefit Row
struct BenefitRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
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
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
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

// MARK: - Feedback View
struct FeedbackView: View {
    let rating: Int
    @Binding var feedbackText: String
    @Binding var showingThankYou: Bool
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: DesignSystem.Spacing.large) {
                        // Header
                        VStack(spacing: DesignSystem.Spacing.medium) {
                            Image(systemName: "message.fill")
                                .font(.system(size: 50))
                                .foregroundColor(DesignSystem.Colors.primary)
                            
                            Text("Share Your Thoughts")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            
                            Text("We'd love to hear your detailed feedback to make Gym Diary even better.")
                                .font(.body)
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, DesignSystem.Spacing.large)
                        
                        // Rating Display
                        HStack(spacing: DesignSystem.Spacing.small) {
                            ForEach(1...5, id: \.self) { star in
                                Image(systemName: star <= rating ? "star.fill" : "star")
                                    .font(.title2)
                                    .foregroundColor(star <= rating ? .yellow : .gray)
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.large)
                        
                        // Feedback Form
                        VStack(spacing: DesignSystem.Spacing.medium) {
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                                Text("What can we improve?")
                                    .font(.headline)
                                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                
                                TextEditor(text: $feedbackText)
                                    .frame(minHeight: 120)
                                    .padding(12)
                                    .background(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                            .fill(Color(.systemBackground))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                                    .stroke(Color(.systemGray4), lineWidth: 1)
                                            )
                                    )
                                    .overlay(
                                        Group {
                                            if feedbackText.isEmpty {
                                                Text("Share your thoughts, suggestions, or report any issues...")
                                                    .foregroundColor(.secondary)
                                                    .padding(.leading, 16)
                                                    .padding(.top, 20)
                                            }
                                        }
                                    )
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.large)
                        
                        // Submit Button
                        Button(action: {
                            submitFeedback()
                        }) {
                            HStack {
                                Image(systemName: "paperplane.fill")
                                Text("Send Feedback")
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
                        .disabled(feedbackText.isEmpty)
                        .opacity(feedbackText.isEmpty ? 0.6 : 1.0)
                        .padding(.horizontal, DesignSystem.Spacing.large)
                        
                        // Quick Feedback Options
                        VStack(spacing: DesignSystem.Spacing.medium) {
                            Text("Quick feedback (optional)")
                                .font(.caption)
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: DesignSystem.Spacing.small) {
                                QuickFeedbackButton(text: "Great UI/UX", action: { addQuickFeedback("Great UI/UX") })
                                QuickFeedbackButton(text: "Needs features", action: { addQuickFeedback("Needs more features") })
                                QuickFeedbackButton(text: "Bug found", action: { addQuickFeedback("Found a bug") })
                                QuickFeedbackButton(text: "Performance", action: { addQuickFeedback("Performance issues") })
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.large)
                        .padding(.bottom, DesignSystem.Spacing.large)
                    }
                }
            }
            .navigationTitle("Feedback")
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
    }
    
    private func addQuickFeedback(_ text: String) {
        if feedbackText.isEmpty {
            feedbackText = text
        } else {
            feedbackText += "\n\n" + text
        }
    }
    
    private func submitFeedback() {
        // Here you would typically send the feedback to your backend
        // For now, we'll just show the thank you message
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            dismiss()
            showingThankYou = true
        }
    }
}

// MARK: - Quick Feedback Button
struct QuickFeedbackButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.caption)
                .foregroundColor(DesignSystem.Colors.primary)
                .padding(.horizontal, DesignSystem.Spacing.medium)
                .padding(.vertical, DesignSystem.Spacing.small)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                        .fill(Color(.systemBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                .stroke(DesignSystem.Colors.primary, lineWidth: 1)
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Thank You View
struct ThankYouView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: DesignSystem.Spacing.large) {
                    Spacer()
                    
                    // Success Animation
                    ZStack {
                        Circle()
                            .fill(DesignSystem.Gradients.success)
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .scaleEffect(1.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.2), value: 1.0)
                    
                    // Thank You Message
                    VStack(spacing: DesignSystem.Spacing.medium) {
                        Text("Thank You!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        
                        Text("Your feedback has been submitted successfully. We appreciate you taking the time to help us improve Gym Diary.")
                            .font(.body)
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, DesignSystem.Spacing.large)
                    }
                    
                    // Action Buttons
                    VStack(spacing: DesignSystem.Spacing.medium) {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Continue")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(DesignSystem.Spacing.medium)
                                .background(
                                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                        .fill(DesignSystem.Colors.primary)
                                )
                        }
                        
                        Button(action: {
                            // Share app
                            shareApp()
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share Gym Diary")
                            }
                            .font(.body)
                            .foregroundColor(DesignSystem.Colors.primary)
                            .frame(maxWidth: .infinity)
                            .padding(DesignSystem.Spacing.medium)
                            .background(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                    .fill(Color(.systemBackground))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                            .stroke(DesignSystem.Colors.primary, lineWidth: 2)
                                    )
                            )
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.large)
                    
                    Spacer()
                }
            }
            .navigationTitle("Thank You")
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
    
    private func shareApp() {
        let appUrl = "https://apps.apple.com/app/gym-diary/id1234567890"
        let shareText = "Check out Gym Diary - the best fitness tracking app I've used! 🏋️‍♂️💪"
        
        let activityVC = UIActivityViewController(
            activityItems: [shareText, appUrl],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
}
