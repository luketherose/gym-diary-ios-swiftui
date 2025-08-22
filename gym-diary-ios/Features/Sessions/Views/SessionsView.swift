//
//  SessionsView.swift
//  gym-diary-ios
//
//  Created by luca.la.rosa on 14/08/25.
//

import SwiftUI

struct SessionsView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var sessionManager = SessionManager.shared
    @State private var selectedTab: SessionTab = .new
    @State private var showingWorkoutSelector = false
    @State private var showingEmptyWorkout = false
    @State private var showingCreateWorkout = false
    @State private var showingActiveWorkout = false
    
    enum SessionTab: String, CaseIterable {
        case new = "new"
        case history = "history"
        case search = "search"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Top Navigation Bar (like Apple Fitness+)
                    topNavigationBar
                    
                    // Active Session Timer Tab (if any)
                    if let session = sessionManager.activeSession {
                        activeSessionTimerTab(session: session)
                    }
                    
                    // Content based on selected tab
                    TabView(selection: $selectedTab) {
                        newSessionView
                            .tag(SessionTab.new)
                        
                        historyView
                            .tag(SessionTab.history)
                        
                        searchView
                            .tag(SessionTab.search)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
            }
        }
        .sheet(isPresented: $showingWorkoutSelector) {
            WorkoutSelectorView { workout in
                sessionManager.startSession(from: workout)
                showingWorkoutSelector = false
            } onNoWorkouts: {
                showingWorkoutSelector = false
                showingCreateWorkout = true
            }
        }
        .sheet(isPresented: $showingEmptyWorkout) {
            EmptyWorkoutView {
                showingEmptyWorkout = false
            }
        }
        .sheet(isPresented: $showingCreateWorkout) {
            CreateWorkoutView(
                sections: [],
                newWorkoutName: .constant(""),
                selectedSectionId: .constant(""),
                onCancel: { showingCreateWorkout = false },
                onCreate: {
                    // Create workout and start session
                    let newWorkout = Workout(
                        id: UUID().uuidString,
                        userId: "user123",
                        name: "New Workout",
                        exercises: [],
                        sectionId: ""
                    )
                    // Add to sections (you'll need to implement this)
                    // For now, just start the session
                    sessionManager.startSession(from: newWorkout)
                    showingCreateWorkout = false
                },
                isEditing: false
            )
        }
        .fullScreenCover(isPresented: $showingActiveWorkout) {
            if let activeSession = sessionManager.activeSession,
               let workout = sessionManager.workouts.first(where: { $0.id == activeSession.workoutId }) {
                WorkoutDetailView(
                    workout: .constant(workout),
                    sections: [],
                    onDelete: nil,
                    onDismiss: { showingActiveWorkout = false }
                )
            }
        }
    }
    
    // MARK: - Top Navigation Bar
    private var topNavigationBar: some View {
        HStack(spacing: 0) {
            // + New Tab
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedTab = .new
                }
            }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                    Text("New")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(selectedTab == .new ? .white : Color(.systemGray))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(selectedTab == .new ? Color(.systemGray3) : Color.clear)
                )
            }
            
            // History Tab
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedTab = .history
                }
            }) {
                Text("History")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(selectedTab == .history ? .white : Color(.systemGray))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(selectedTab == .history ? Color(.systemGray3) : Color.clear)
                    )
            }
            
            Spacer()
            
            // Search Icon
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedTab = .search
                }
            }) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(selectedTab == .search ? .white : Color(.systemGray))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(selectedTab == .search ? Color(.systemGray3) : Color.clear)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    // MARK: - Active Session Timer Tab
    private func activeSessionTimerTab(session: Session) -> some View {
        Button(action: {
            showingActiveWorkout = true
        }) {
            HStack {
                Image(systemName: "timer")
                    .font(.system(size: 14, weight: .medium))
                
                Text(session.formattedDuration)
                    .font(.system(size: 14, weight: .medium))
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(DesignSystem.Colors.primary)
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
    
    // MARK: - New Session View
    private var newSessionView: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.large) {
                // New Session Options (only show if no active session)
                if sessionManager.activeSession == nil {
                    VStack(spacing: DesignSystem.Spacing.large) {
                        // Start with Empty Workout
                        Button(action: {
                            // Start empty session immediately
                            let emptyWorkout = Workout(
                                id: UUID().uuidString,
                                userId: "user123",
                                name: "Empty Workout",
                                exercises: [],
                                sectionId: ""
                            )
                            sessionManager.startSession(from: emptyWorkout)
                        }) {
                            VStack(spacing: DesignSystem.Spacing.medium) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(DesignSystem.Colors.primary)
                                
                                Text("Start with Empty Workout")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                
                                Text("Begin a session without a predefined workout")
                                    .font(.body)
                                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(DesignSystem.Spacing.extraLarge)
                            .background(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                    .fill(DesignSystem.Colors.cardBackground(for: colorScheme))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                            .stroke(DesignSystem.Colors.primary.opacity(0.3), lineWidth: 2)
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Pick Existing Workout
                        Button(action: {
                            showingWorkoutSelector = true
                        }) {
                            VStack(spacing: DesignSystem.Spacing.medium) {
                                Image(systemName: "list.bullet.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(DesignSystem.Colors.primary)
                                
                                Text("Pick an Existing Workout")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                
                                Text("Choose from your saved workout templates")
                                    .font(.body)
                                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(DesignSystem.Spacing.extraLarge)
                            .background(
                                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                    .fill(DesignSystem.Colors.cardBackground(for: colorScheme))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                            .stroke(DesignSystem.Colors.primary.opacity(0.3), lineWidth: 2)
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, DesignSystem.Spacing.large)
                    .padding(.top, DesignSystem.Spacing.large)
                } else {
                    // Active session message
                    VStack(spacing: DesignSystem.Spacing.large) {
                        Image(systemName: "timer.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(DesignSystem.Colors.primary)
                        
                        Text("Workout in Progress")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        
                        Text("Complete or cancel your current workout before starting a new one")
                            .font(.body)
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, DesignSystem.Spacing.large)
                    .padding(.top, DesignSystem.Spacing.extraLarge)
                }
                
                Spacer(minLength: 100)
            }
        }
    }
    
    // MARK: - History View
    private var historyView: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.large) {
                if sessionManager.pastSessions.isEmpty {
                    // Empty History State
                    VStack(spacing: DesignSystem.Spacing.large) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 60))
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        
                        Text("No Workout History")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        
                        Text("Your completed workouts will appear here")
                            .font(.body)
                            .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, DesignSystem.Spacing.large)
                    .padding(.top, DesignSystem.Spacing.extraLarge)
                } else {
                    // Past Sessions List
                    LazyVStack(spacing: DesignSystem.Spacing.medium) {
                        ForEach(sessionManager.pastSessions) { session in
                            CompactSessionCard(session: session)
                                .padding(.horizontal, DesignSystem.Spacing.large)
                        }
                    }
                    .padding(.top, DesignSystem.Spacing.large)
                }
                
                Spacer(minLength: 100)
            }
        }
    }
    
    // MARK: - Search View
    private var searchView: some View {
        VStack(spacing: DesignSystem.Spacing.large) {
            // Search functionality placeholder
            VStack(spacing: DesignSystem.Spacing.large) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 60))
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                
                Text("Search Workouts")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                
                Text("Search functionality coming soon")
                    .font(.body)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, DesignSystem.Spacing.large)
            .padding(.top, DesignSystem.Spacing.extraLarge)
            
            Spacer()
        }
    }
}

// MARK: - Empty Workout View (simplified)
struct EmptyWorkoutView: View {
    let onDismiss: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationView {
            VStack(spacing: DesignSystem.Spacing.large) {
                Text("Empty Workout Session")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                
                Text("Starting empty workout session...")
                    .font(.body)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignSystem.Spacing.large)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        onDismiss()
                    }
                    .foregroundColor(DesignSystem.Colors.primary)
                }
            }
        }
    }
}

#Preview {
    SessionsView()
        .preferredColorScheme(.dark)
}

// MARK: - Compact Session Card
struct CompactSessionCard: View {
    let session: Session
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            // Header with status icon
            HStack {
                Image(systemName: statusIcon)
                    .font(.title3)
                    .foregroundColor(statusColor)
                
                Spacer()
                
                Text(formatDate(session.completedAt ?? session.startedAt))
                    .font(.caption2)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
            }
            
            // Workout name
            Text(getWorkoutName())
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                .lineLimit(1)
            
            // Duration
            HStack {
                Image(systemName: "clock")
                    .font(.caption2)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                
                Text(formatDuration(session.executionSeconds ?? 0))
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
            }
            
            // Notes preview (if any)
            if let notes = session.notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption2)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                    .lineLimit(2)
            }
        }
        .padding(DesignSystem.Spacing.medium)
        .frame(width: 200)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                .fill(DesignSystem.Colors.surfaceBackground(for: colorScheme))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                        .stroke(statusColor.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private var statusIcon: String {
        switch session.status {
        case .finished:
            return "checkmark.circle.fill"
        case .cancelled:
            return "xmark.circle.fill"
        case .inProgress:
            return "timer"
        case .created:
            return "circle"
        }
    }
    
    private var statusColor: Color {
        switch session.status {
        case .finished:
            return .green
        case .cancelled:
            return .red
        case .inProgress:
            return .orange
        case .created:
            return .gray
        }
    }
    
    private func getWorkoutName() -> String {
        // TODO: Get actual workout name from workoutId
        // For now, return a placeholder
        return "Workout #\(session.workoutId.suffix(4))"
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown" }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}
