import SwiftUI

struct SidebarView: View {
    @Bindable var appState: AppState

    var body: some View {
        List(selection: $appState.selectedSidebarItem) {
            Section {
                sidebarRow(.home)
            }

            Section {
                ForEach(SidebarItem.settingsItems) { item in
                    sidebarRow(item)
                }
            }

            Section {
                ForEach(SidebarItem.utilityItems) { item in
                    sidebarRow(item)
                }
            }

            Section {
                sidebarRow(.appSettings)
            }
        }
        .listStyle(.sidebar)
    }

    private func sidebarRow(_ item: SidebarItem) -> some View {
        Label {
            Text(item.displayName)
        } icon: {
            Image(systemName: item.systemImage)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 24, height: 24)
                .background(item.iconColor.gradient, in: RoundedRectangle(cornerRadius: 6))
        }
        .tag(item)
    }
}
