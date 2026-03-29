import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @State private var applyMessage: String?

    var body: some View {
        Form {
            // Centered header
            Section {
                CategoryHeaderView(.home, subtitle: "Your Mac, your rules. We just make it easy.")
            }
            .listRowBackground(Color.clear)

            if let msg = applyMessage {
                Section {
                    ApplyResultBanner(message: msg) { applyMessage = nil }
                }
            }

            // Quick stats
            Section("At a Glance") {
                let total = appState.catalogService.shippingDefinitions().count
                let customized = appState.settingStates.values.filter { $0.keyExists }.count

                LabeledContent("Managed settings", value: "\(total)")
                LabeledContent("Currently customized", value: "\(customized)")
                LabeledContent("macOS version", value: "\(appState.compatibilityService.currentOSMajorVersion)")
                LabeledContent("Snapshots", value: "\(appState.snapshotService.listSnapshots().count)")
            }

            // Presets
            Section {
                ForEach(appState.catalogService.presets) { preset in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(preset.name)
                            Text(preset.description)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button("Apply") {
                            applyPreset(preset)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                    }
                }
            } header: {
                Text("Presets")
            } footer: {
                Text("One-click bundles of opinionated changes. A snapshot is taken automatically before each apply.")
            }

            // Recent changes
            let recent = appState.changeLogService.recentRecords(limit: 5)
            if !recent.isEmpty {
                Section("Recent Changes") {
                    ForEach(recent) { record in
                        LabeledContent {
                            HStack(spacing: 4) {
                                Text(record.oldValue?.displayString ?? "default")
                                    .foregroundStyle(.secondary)
                                Image(systemName: "arrow.right")
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                                Text(record.newValue?.displayString ?? "default")
                            }
                        } label: {
                            VStack(alignment: .leading, spacing: 1) {
                                Text(record.displayName)
                                Text(record.appliedAt, style: .relative)
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                        .font(.callout)
                    }
                }
            }
        }
        .formStyle(.grouped)
    }

    private func applyPreset(_ preset: PresetDefinition) {
        let items: [ApplyItem] = preset.items.compactMap { presetItem in
            guard let def = appState.catalogService.definition(for: presetItem.settingID) else { return nil }
            return ApplyItem(
                settingID: presetItem.settingID,
                targetState: presetItem.targetState,
                mechanism: def.mechanism,
                domain: def.domain,
                keyPath: def.keyPath,
                restartRequirement: def.restartRequirement
            )
        }

        let request = ApplyRequest(source: .preset, items: items)
        let result = appState.applyEngine.apply(request)
        appState.refreshAllStates()

        let applied = result.outcomes.filter { if case .applied = $0.result { return true }; return false }.count
        applyMessage = "Preset \"\(preset.name)\" applied. \(applied) change\(applied == 1 ? "" : "s")."
    }
}
