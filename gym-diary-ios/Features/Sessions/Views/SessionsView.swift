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
    @State private var showingWorkoutSelector = false
    
    var body: some View {
        NavigationView {
            ZStack {
                DesignSystem.Colors.background(for: colorScheme)
                    .ignoresSafeArea()
                
                VStack(spacing: DesignSystem.Spacing.large) {
                    // Header
                    HStack {
                        Text("Workout Sessions")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                        
                        Spacer()
                        
                        if sessionManager.activeSession == nil {
                            Button(action: {
                                showingWorkoutSelector = true
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                    .foregroundColor(DesignSystem.Colors.primary)
                            }
                        }
                    }
                    .padding(.horizontal, DesignSystem.Spacing.large)
                    .padding(.top, DesignSystem.Spacing.large)
                    
                    // Active Session Panel
                    if let session = sessionManager.activeSession {
                        ActiveSessionPanel(session: session) {
                            sessionManager.completeSession(session)
                        } onCancel: {
                            sessionManager.cancelSession(session)
                        }
                        .padding(.horizontal, DesignSystem.Spacing.large)
                    }
                    
                    // Past Sessions - Horizontal Scroll
                    if !sessionManager.pastSessions.isEmpty {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                            Text("Previous Workouts")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                                .padding(.horizontal, DesignSystem.Spacing.large)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: DesignSystem.Spacing.medium) {
                                    ForEach(sessionManager.pastSessions) { session in
                                        CompactSessionCard(session: session)
                                    }
                                }
                                .padding(.horizontal, DesignSystem.Spacing.large)
                            }
                        }
                    } else {
                        // Empty State
                        VStack(spacing: DesignSystem.Spacing.large) {
                            Image(systemName: "timer")
                                .font(.system(size: 60))
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                            
                            Text("No Sessions Yet")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                            
                            Text("Start your first workout session to begin tracking your progress")
                                .font(.body)
                                .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                                .multilineTextAlignment(.center)
                            
                            if sessionManager.activeSession == nil {
                                Button(action: {
                                    showingWorkoutSelector = true
                                }) {
                                    Text("Start Session")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, DesignSystem.Spacing.large)
                                        .padding(.vertical, DesignSystem.Spacing.medium)
                                        .background(
                                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                                .fill(DesignSystem.Colors.primary)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, DesignSystem.Spacing.large)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showingWorkoutSelector) {
            WorkoutSelectorView { workout in
                sessionManager.startSession(from: workout)
                showingWorkoutSelector = false
            }
        }
        .onAppear {
            // No longer needed as workouts are managed by SessionManager
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
