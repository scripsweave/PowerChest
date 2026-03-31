import SwiftUI

struct RestartBadgeView: View {
    let requirement: RestartRequirement

    var body: some View {
        if requirement.isRequired {
            HStack(spacing: 2) {
                Image(systemName: "arrow.triangle.2.circlepath")
                Text(shortLabel)
            }
            .font(.caption2)
            .foregroundStyle(.orange)
        }
    }

    private var shortLabel: String {
        switch requirement {
        case .finder: return "Finder"
        case .dock: return "Dock"
        case .systemUIServer: return "Menu bar"
        case .controlCenter: return "Menu bar"
        case .safari: return "Safari"
        case .app(let id): return id
        case .signOut: return "Sign out"
        case .reboot: return "Reboot"
        case .none: return ""
        }
    }
}
