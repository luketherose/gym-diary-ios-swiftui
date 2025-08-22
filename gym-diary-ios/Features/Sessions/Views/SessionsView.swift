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
            }
        }
        .sheet(isPresented: $showingEmptyWorkout) {
            EmptyWorkoutView {
                showingEmptyWorkout = false
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
        )
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    // MARK: - New Session View
    private var newSessionView: some View {
        ScrollView {
            VStack(spacing: DesignSystem.Spacing.large) {
                // Active Session Panel (if any)
                if let session = sessionManager.activeSession {
                    ActiveSessionPanel(session: session) {
                        sessionManager.completeSession(session)
                    } onCancel: {
                        sessionManager.cancelSession(session)
                    }
                    .padding(.horizontal, DesignSystem.Spacing.large)
                } else {
                    // New Session Options
                    VStack(spacing: DesignSystem.Spacing.large) {
                        // Start with Empty Workout
                        Button(action: {
                            showingEmptyWorkout = true
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

// MARK: - Empty Workout View
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
                
                Text("Start a free-form workout session where you can add exercises as you go")
                    .font(.body)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DesignSystem.Spacing.large)
                
                Spacer()
                
                Button("Start Empty Session") {
                    // TODO: Implement empty session start
                    onDismiss()
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, DesignSystem.Spacing.large)
                .padding(.vertical, DesignSystem.Spacing.medium)
                .background(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                        .fill(DesignSystem.Colors.primary)
                )
                .padding(.bottom, DesignSystem.Spacing.large)
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
