//
//  ActiveSessionPanel.swift
//  gym-diary-ios
//
//  Created by luca.la.rosa on 14/08/25.
//

import SwiftUI

struct ActiveSessionPanel: View {
    let session: Session
    let onComplete: () -> Void
    let onCancel: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.medium) {
            // Header
            HStack {
                Image(systemName: "timer")
                    .font(.title2)
                    .foregroundColor(.green)
                
                Text("Active Session")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                
                Spacer()
                
                Text(formatTime(elapsedTime))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .monospacedDigit()
            }
            
            // Session Info
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text("Workout: \(getWorkoutName())")
                    .font(.subheadline)
                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                
                Text("Started: \(formatDate(session.startedAt))")
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Action Buttons
            HStack(spacing: DesignSystem.Spacing.medium) {
                Button(action: onCancel) {
                    Text("Cancel")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, DesignSystem.Spacing.large)
                        .padding(.vertical, DesignSystem.Spacing.medium)
                        .background(
                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                .fill(.red)
                        )
                }
                
                Button(action: onComplete) {
                    Text("Complete")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, DesignSystem.Spacing.large)
                        .padding(.vertical, DesignSystem.Spacing.medium)
                        .background(
                            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                                .fill(.green)
                        )
                }
            }
        }
        .padding(DesignSystem.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                .fill(DesignSystem.Colors.surfaceBackground(for: colorScheme))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                )
        )
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if let startTime = session.startedAt {
                elapsedTime = Date().timeIntervalSince(startTime)
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) % 3600 / 60
        let seconds = Int(timeInterval) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown" }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: date)
    }
    
    private func getWorkoutName() -> String {
        // TODO: Get actual workout name from workoutId
        // For now, return a placeholder
        return "Workout #\(session.workoutId.suffix(4))"
    }
}

#Preview {
    let mockSession = Session(
        userId: "user123",
        workoutId: "workout1",
        status: .inProgress,
        startedAt: Date().addingTimeInterval(-1800), // 30 minutes ago
        exercises: [],
        circuits: []
    )
    
    return ActiveSessionPanel(
        session: mockSession,
        onComplete: {},
        onCancel: {}
    )
    .padding()
    .background(Color(.systemBackground))
}
