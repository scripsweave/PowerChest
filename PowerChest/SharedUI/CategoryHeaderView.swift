import SwiftUI

struct CategoryHeaderView: View {
    let item: SidebarItem
    let subtitle: String?

    init(_ item: SidebarItem, subtitle: String? = nil) {
        self.item = item
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: item.systemImage)
                .font(.system(size: 32, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(item.iconColor.gradient, in: RoundedRectangle(cornerRadius: 14))
                .shadow(color: item.iconColor.opacity(0.3), radius: 6, y: 3)

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
