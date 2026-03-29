import SwiftUI

struct AppSettingsView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var state = appState

        Form {
            Section {
                CategoryHeaderView(.appSettings, subtitle: "Configure how PowerChest works.")
            }
            .listRowBackground(Color.clear)

            Section {
                Picker("Display mode", selection: $state.userMode) {
                    Text("Power User").tag(UserMode.powerUser)
                    Text("Propellerhead").tag(UserMode.propellerhead)
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Mode")
            } footer: {
                Text(appState.userMode == .powerUser
                     ? "Plain-language controls grouped by intent. Friendly and opinionated."
                     : "Individual settings with technical details. Still curated. Less hand-holding.")
            }

            Section("Catalog") {
                LabeledContent("Version", value: "1.0 (dev)")
                LabeledContent("Catalog version", value: "\(SettingsCatalogData.catalogVersion)")
                LabeledContent("Settings", value: "\(appState.catalogService.definitions.count)")
                LabeledContent("Grouped controls", value: "\(appState.catalogService.groupedControls.count)")
                LabeledContent("Presets", value: "\(appState.catalogService.presets.count)")
            }
        }
        .formStyle(.grouped)
    }
}
