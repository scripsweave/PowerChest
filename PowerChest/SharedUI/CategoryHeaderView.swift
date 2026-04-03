import SwiftUI

struct CategoryHeaderView: View {
    let item: SidebarItem
    let subtitle: String?

    init(_ item: SidebarItem, subtitle: String? = nil) {
        self.item = item
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.ultraThinMaterial)
                    .frame(width: 64, height: 64)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(item.iconColor.gradient.opacity(0.6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(.white.opacity(0.3), lineWidth: 0.5)
                    )
                    .shadow(color: item.iconColor.opacity(0.25), radius: 8, y: 4)

                Image(systemName: item.systemImage)
                    .font(.system(size: 30, weight: .medium))
                    .foregroundStyle(.white)
            }

            Text(item.displayName)
                .font(.title2)
                .fontWeight(.bold)

            if let subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}
