//
//  PastSessionCard.swift
//  gym-diary-ios
//
//  Created by luca.la.rosa on 14/08/25.
//

import SwiftUI

struct PastSessionCard: View {
    let session: Session
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            // Header
            HStack {
                Image(systemName: statusIcon)
                    .font(.title3)
                    .foregroundColor(statusColor)
                
                Text(getWorkoutName())
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                
                Spacer()
                
                Text(formatDate(session.completedAt ?? session.startedAt))
                    .font(.caption)
                    .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
            }
            
            // Session Details
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Duration:")
                        .font(.caption)
                        .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                    
                    Text(formatDuration(session.executionSeconds ?? 0))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(DesignSystem.Colors.textPrimary(for: colorScheme))
                }
                
                if let notes = session.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.caption)
                        .foregroundColor(DesignSystem.Colors.textSecondary(for: colorScheme))
                        .lineLimit(2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(DesignSystem.Spacing.medium)
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

#Preview {
    let mockSession = Session(
        userId: "user123",
        workoutId: "workout1",
        status: .finished,
        startedAt: Date().addingTimeInterval(-3600),
        completedAt: Date().addingTimeInterval(-1800),
        exercises: [],
        circuits: [],
        notes: "Great workout! Felt strong today."
    )
    
    PastSessionCard(session: mockSession)
        .padding()
        .background(Color(.systemBackground))
}
