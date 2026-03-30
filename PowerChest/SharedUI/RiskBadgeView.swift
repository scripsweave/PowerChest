import SwiftUI

struct RiskBadgeView: View {
    let risk: RiskLevel

    var body: some View {
        Text(label)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.15), in: Capsule())
            .foregroundStyle(color)
    }

    private var label: String {
        switch risk {
        case .safe: return "Safe"
        case .advanced: return "Advanced"
        case .systemSensitive: return "Sensitive"
        }
    }

    private var color: Color {
        switch risk {
        case .safe: return .green
        case .advanced: return .orange
        case .systemSensitive: return .red
        }
    }
}

struct AdminBadgeView: View {
    var body: some View {
        Label("Admin", systemImage: "lock.fill")
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.purple.opacity(0.15), in: Capsule())
            .foregroundStyle(.purple)
    }
}
