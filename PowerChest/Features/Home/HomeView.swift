import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @State private var statusMessage: String?
    @State private var showConfetti = false
    @State private var showingResetConfirmation = false
    @State private var pendingImport: ImportPreview?
    @State private var showingCustomizedPopover = false
    @State private var showingSavePresetSheet = false

    var body: some View {
        let metrics = currentMetrics
        return ZStack(alignment: .top) {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    heroCard(metrics: metrics)
                    statGrid(metrics: metrics)
                    presetCarousel
                    recentTimeline
                }
                .padding(.horizontal, 28)
                .padding(.vertical, 32)
            }
            .background(Color(nsColor: .controlBackgroundColor))

            if let msg = statusMessage {
                ApplyResultBanner(message: msg) { withAnimation { statusMessage = nil } }
                    .padding(.top, 20)
                    .padding(.horizontal, 30)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }

            if showConfetti {
                ConfettiOverlay()
                    .frame(height: 180)
                    .padding(.top, 10)
                    .transition(.opacity)
            }
        }
        .animation(.spring(duration: 0.35, bounce: 0.3), value: statusMessage)
        .confirmationDialog(
            "Reset all settings to macOS defaults?",
            isPresented: $showingResetConfirmation,
            titleVisibility: .visible
        ) {
            Button("Reset everything", role: .destructive) {
                resetToMacOSDefaults()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will delete every customized setting and return your Mac to factory behavior. A snapshot will be created first so you can undo this.")
        }
        .sheet(item: $pendingImport) { preview in
            ImportPreviewSheet(preview: preview) {
                applyImport(preview)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .menuCreateSnapshot)) { note in
            guard note.object as? String == "forwarded" else { return }
            createHeroSnapshot()
        }
        .onReceive(NotificationCenter.default.publisher(for: .menuExportConfig)) { note in
            guard note.object as? String == "forwarded" else { return }
            exportConfig()
        }
        .onReceive(NotificationCenter.default.publisher(for: .menuImportConfig)) { note in
            guard note.object as? String == "forwarded" else { return }
            importConfig()
        }
        .onReceive(NotificationCenter.default.publisher(for: .menuSavePreset)) { note in
            guard note.object as? String == "forwarded" else { return }
            showingSavePresetSheet = true
        }
        .onReceive(NotificationCenter.default.publisher(for: .menuResetToDefaults)) { note in
            guard note.object as? String == "forwarded" else { return }
            showingResetConfirmation = true
        }
    }

    private func heroCard(metrics: HomeMetrics) -> some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 16) {
                Text(heroTitle)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.white)
                Text(heroSubtitle(metrics: metrics))
                    .foregroundStyle(.white.opacity(0.85))
                    .font(.title3)

                HStack(spacing: 18) {
                    Label("\(metrics.snapshotCount) safety net\(metrics.snapshotCount == 1 ? "" : "s")", systemImage: "lifepreserver")
                        .font(.callout)
                        .foregroundStyle(.white.opacity(0.85))
                    Label(appState.userMode == .powerUser ? "Friendly mode" : "Nerd mode", systemImage: "bolt.fill")
                        .font(.callout)
                        .foregroundStyle(.white.opacity(0.85))
                }

                HStack(spacing: 12) {
                    Button {
                        createHeroSnapshot()
                    } label: {
                        Label("Create snapshot", systemImage: "camera.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.white.opacity(0.2))

                    Button {
                        appState.selectedSidebarItem = .snapshots
                    } label: {
                        Text("Restore")
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(.white)

                    Button {
                        showingResetConfirmation = true
                    } label: {
                        Label("Reset to defaults", systemImage: "arrow.counterclockwise")
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(.white)

                    Button {
                        exportConfig()
                    } label: {
                        Label("Export config", systemImage: "square.and.arrow.up")
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(.white)

                    Button {
                        importConfig()
                    } label: {
                        Label("Import config", systemImage: "square.and.arrow.down")
                    }
                    .buttonStyle(.bordered)
                    .foregroundStyle(.white)
                }
            }
            .padding(28)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(heroGradient)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .overlay(alignment: .bottomTrailing) {
                Image(systemName: appState.userMode == .powerUser ? "wand.and.stars" : "terminal.fill")
                    .font(.system(size: 60, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.25))
                    .padding(24)
            }

        }
    }

    private func statGrid(metrics: HomeMetrics) -> some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]

        return LazyVGrid(columns: columns, spacing: 18) {
            StatCard(title: "Managed settings",
                     value: "\(metrics.totalSettings)",
                     caption: "Curated by humans",
                     accent: .mint,
                     progress: Double(metrics.customizedSettings) / Double(max(metrics.totalSettings, 1)))

            StatCard(title: "Customized",
                     value: "\(metrics.customizedSettings)",
                     caption: metrics.customizedSettings == 0 ? "Stock macOS — untouched" : "That's \(Int(Double(metrics.customizedSettings) / Double(max(metrics.totalSettings, 1)) * 100))% of the catalog",
                     accent: .orange,
                     progress: Double(metrics.customizedSettings) / Double(max(metrics.totalSettings, 1)))
            .onTapGesture {
                if metrics.customizedSettings > 0 {
                    showingCustomizedPopover = true
                }
            }
            .popover(isPresented: $showingCustomizedPopover, arrowEdge: .bottom) {
                customizedListPopover
            }

            StatCard(title: "Snapshots",
                     value: "\(metrics.snapshotCount)",
                     caption: metrics.snapshotCount == 0 ? "Try capturing one before going wild" : "Auto + manual safety net",
                     accent: .indigo)

            StatCard(title: "Presets",
                     value: "\(metrics.presetCount)",
                     caption: "One-click vibes",
                     accent: .pink)
        }
    }

    private var presetCarousel: some View {
        let presets = appState.allPresets
        return VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Preset decks")
                    .font(.title2).bold()
                Spacer()
                Text("One tap applies the bundle. We auto-snapshot first.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 18) {
                    SavePresetCard {
                        showingSavePresetSheet = true
                    }

                    ForEach(presets) { preset in
                        let isCustom = appState.customPresetIDs.contains(preset.id)
                        PresetCard(preset: preset,
                                   highlights: presetHighlights(for: preset),
                                   isHighlighted: appState.spotlightPresetID == preset.id,
                                   isCustom: isCustom,
                                   onApply: { applyPreset(preset) },
                                   onDelete: isCustom ? { appState.deleteCustomPreset(id: preset.id) } : nil)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .sheet(isPresented: $showingSavePresetSheet) {
            SavePresetSheet { name, description in
                saveCurrentAsPreset(name: name, description: description)
            }
        }
    }

    @ViewBuilder
    private var recentTimeline: some View {
        let recent = appState.changeLogService.recentRecords(limit: 5)
        if recent.isEmpty {
            EmptyView()
        } else {
            VStack(alignment: .leading, spacing: 12) {
                Text("Recent tinkering")
                    .font(.title2).bold()
                VStack(spacing: 0) {
                    ForEach(recent) { record in
                        TimelineRow(record: record)
                        if record.id != recent.last?.id {
                            Divider()
                        }
                    }
                }
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color(nsColor: .textBackgroundColor))
                        .shadow(color: .black.opacity(0.1), radius: 12, y: 6)
                )
            }
        }
    }

    private func applyPreset(_ preset: PresetDefinition) {
        guard !appState.isApplying else { return }
        appState.isApplying = true
        defer { appState.isApplying = false }
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
        appState.enqueueRestartRequests(result.pendingRestarts)

        let applied = result.outcomes.filter { if case .applied = $0.result { return true }; return false }.count
        statusMessage = "Preset \"\(preset.name)\" applied. \(applied) change\(applied == 1 ? "" : "s")."
        appState.spotlightPresetID = nil
        appState.presentToast(title: "\(preset.name) applied",
                              subtitle: "\(applied) change\(applied == 1 ? "" : "s")",
                              icon: "sparkles")
        triggerConfetti()
    }

    private func saveCurrentAsPreset(name: String, description: String) {
        let ids = customizedSettingIDs
        let items: [PresetItem] = ids.compactMap { id in
            guard let state = appState.settingStates[id],
                  let value = state.currentValue else { return nil }
            return PresetItem(settingID: id, targetState: .explicitValue(value))
        }

        guard !items.isEmpty else {
            statusMessage = "Nothing to save — no customized settings."
            return
        }

        let preset = PresetDefinition(
            id: "custom-\(UUID().uuidString.prefix(8))",
            name: name,
            description: description,
            items: items,
            riskSummary: .safe
        )
        appState.saveCustomPreset(preset)
        statusMessage = "Preset \"\(name)\" saved with \(items.count) setting\(items.count == 1 ? "" : "s")."
        appState.presentToast(title: "Preset saved", subtitle: "\(items.count) setting\(items.count == 1 ? "" : "s")", icon: "tray.and.arrow.down.fill")
    }

    private func createHeroSnapshot() {
        do {
            let stamp = DateFormatter.localizedString(from: .now, dateStyle: .none, timeStyle: .short)
            _ = try appState.snapshotService.createManualSnapshot(name: "Lightning @ \(stamp)", notes: "Captured from Home hero")
            statusMessage = "Snapshot captured."
            triggerConfetti()
        } catch {
            statusMessage = "Snapshot failed: \(error.localizedDescription)"
        }
    }

    private func resetToMacOSDefaults() {
        guard !appState.isApplying else { return }
        appState.isApplying = true
        let definitions = appState.catalogService.shippingDefinitions()
        let items: [ApplyItem] = definitions.map { def in
            ApplyItem(
                settingID: def.id,
                targetState: .systemDefault,
                mechanism: def.mechanism,
                domain: def.domain,
                keyPath: def.keyPath,
                restartRequirement: def.restartRequirement
            )
        }

        let request = ApplyRequest(source: .restore, items: items)

        DispatchQueue.global(qos: .userInitiated).async {
            let result = appState.applyEngine.apply(request) { progress in
                DispatchQueue.main.async {
                    appState.applyProgress = progress
                }
            }
            DispatchQueue.main.async {
                appState.isApplying = false
                appState.applyProgress = nil
                appState.refreshAllStates()
                appState.lastApplyResult = result
                appState.enqueueRestartRequests(result.pendingRestarts)

                let applied = result.outcomes.filter { if case .applied = $0.result { return true }; return false }.count
                statusMessage = "Reset complete. \(applied) setting\(applied == 1 ? "" : "s") returned to macOS defaults."
                appState.presentToast(title: "Reset to defaults", subtitle: "\(applied) setting\(applied == 1 ? "" : "s") restored", icon: "arrow.counterclockwise")
                triggerConfetti()
            }
        }
    }

    private func exportConfig() {
        do {
            let stamp = DateFormatter.localizedString(from: .now, dateStyle: .short, timeStyle: .short)
            let snapshotID = try appState.snapshotService.createManualSnapshot(name: "Export @ \(stamp)", notes: "Captured for profile export")
            guard let snapshot = appState.snapshotService.listSnapshots().first(where: { $0.id == snapshotID }) else {
                statusMessage = "Export failed: could not locate snapshot."
                return
            }

            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(snapshot)

            let panel = NSSavePanel()
            panel.title = "Export PowerChest Profile"
            panel.nameFieldStringValue = "PowerChest Profile.powerchestprofile"
            panel.allowedContentTypes = [.init(filenameExtension: "powerchestprofile") ?? .json]
            panel.canCreateDirectories = true

            if panel.runModal() == .OK, let url = panel.url {
                try data.write(to: url, options: .atomic)
                statusMessage = "Profile exported."
                appState.presentToast(title: "Profile exported", subtitle: url.lastPathComponent, icon: "square.and.arrow.up")
            }
        } catch {
            statusMessage = "Export failed: \(error.localizedDescription)"
        }
    }

    private func importConfig() {
        let panel = NSOpenPanel()
        panel.title = "Import PowerChest Profile"
        panel.allowedContentTypes = [
            .init(filenameExtension: "powerchestprofile") ?? .json,
            .json
        ]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false

        guard panel.runModal() == .OK, let url = panel.url else { return }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let snapshot = try decoder.decode(SnapshotRecord.self, from: data)

            let diff = appState.snapshotService.diffSnapshotToCurrent(snapshot: snapshot)
            let changes = diff.filter { $0.classification == .changed }

            guard !changes.isEmpty else {
                statusMessage = "Nothing to import — your settings already match this profile."
                return
            }

            guard let plan = appState.snapshotService.buildRestorePlan(snapshot: snapshot, selectedSettingIDs: nil) else {
                statusMessage = "Nothing to import — your settings already match this profile."
                return
            }

            pendingImport = ImportPreview(
                fileName: url.lastPathComponent,
                snapshot: snapshot,
                changes: changes,
                plan: plan
            )
        } catch {
            statusMessage = "Import failed: \(error.localizedDescription)"
        }
    }

    private func applyImport(_ preview: ImportPreview) {
        guard !appState.isApplying else { return }
        appState.isApplying = true
        let request = preview.plan.applyRequest

        DispatchQueue.global(qos: .userInitiated).async {
            let result = appState.applyEngine.apply(request) { progress in
                DispatchQueue.main.async {
                    appState.applyProgress = progress
                }
            }
            DispatchQueue.main.async {
                appState.isApplying = false
                appState.applyProgress = nil
                appState.refreshAllStates()
                appState.lastApplyResult = result
                appState.enqueueRestartRequests(result.pendingRestarts)

                let applied = result.outcomes.filter { if case .applied = $0.result { return true }; return false }.count
                statusMessage = "Profile imported. \(applied) setting\(applied == 1 ? "" : "s") applied."
                appState.presentToast(title: "Profile imported", subtitle: "\(applied) change\(applied == 1 ? "" : "s")", icon: "square.and.arrow.down")
                triggerConfetti()
            }
        }
    }

    private var heroTitle: String {
        switch appState.userMode {
        case .powerUser: return "Tinker boldly, we have your back."
        case .propellerhead: return "Raw settings, zero fluff."
        }
    }

    private func heroSubtitle(metrics: HomeMetrics) -> String {
        "You've personalized \(metrics.customizedSettings) of \(metrics.totalSettings) settings. Keep stacking the deck."
    }

    private var heroGradient: LinearGradient {
        let colors: [Color]
        switch appState.userMode {
        case .powerUser:
            colors = [.purple, .pink, .orange]
        case .propellerhead:
            colors = [.indigo, .blue, .teal]
        }
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    private func triggerConfetti() {
        withAnimation(.easeInOut(duration: 0.2)) {
            showConfetti = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation(.easeOut(duration: 0.3)) {
                showConfetti = false
            }
        }
    }

    private func presetHighlights(for preset: PresetDefinition) -> [String] {
        var seen = Set<String>()
        var highlights: [String] = []

        for item in preset.items {
            guard let def = appState.catalogService.definition(for: item.settingID) else { continue }
            let base = def.powerUserLabel ?? def.displayName
            let short = shortHighlightLabel(base)
            let key = short.lowercased()
            if seen.insert(key).inserted {
                highlights.append(short)
            }
            if highlights.count == 3 { break }
        }

        return highlights
    }

    private func shortHighlightLabel(_ text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count <= 32 { return trimmed }
        return trimmed.prefix(29) + "…"
    }

    private var customizedListPopover: some View {
        let ids = customizedSettingIDs
        let defs = ids.compactMap { appState.catalogService.definition(for: $0) }
            .sorted { $0.displayName < $1.displayName }

        return VStack(alignment: .leading, spacing: 0) {
            Text("Customized settings")
                .font(.headline)
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .padding(.bottom, 8)

            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(defs) { def in
                        let state = appState.settingStates[def.id]
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(def.displayName)
                                    .font(.body)
                                Text(def.category.rawValue.capitalized)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(state?.effectiveDisplayValue ?? "—")
                                .font(.body.monospacedDigit())
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)

                        if def.id != defs.last?.id {
                            Divider().padding(.leading, 16)
                        }
                    }
                }
            }
            .frame(maxHeight: 320)
        }
        .frame(width: 360)
        .padding(.bottom, 10)
    }

    private var customizedSettingIDs: [String] {
        appState.settingStates.compactMap { id, state in
            guard let def = appState.catalogService.definition(for: id) else { return nil }
            return state.isCustomized(definition: def) ? id : nil
        }
    }

    private var currentMetrics: HomeMetrics {
        let total = appState.catalogService.shippingDefinitions().count
        let customized = customizedSettingIDs.count
        let snapshots = appState.snapshotService.listSnapshots().count
        let presets = appState.allPresets.count
        return HomeMetrics(totalSettings: total,
                           customizedSettings: customized,
                           snapshotCount: snapshots,
                           presetCount: presets)
    }
}

// MARK: - Supporting Cards

private struct StatCard: View {
    let title: String
    let value: String
    let caption: String
    let accent: Color
    var progress: Double? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: "chart.bar.xaxis")
                .font(.caption)
                .foregroundStyle(accent.opacity(0.9))
            Text(value)
                .font(.system(size: 32, weight: .bold))
            Text(caption)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if let progress {
                ProgressView(value: min(max(progress, 0), 1))
                    .tint(accent)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(nsColor: .textBackgroundColor))
                .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
        )
    }
}

private struct SavePresetCard: View {
    let onTap: () -> Void
    @State private var hovering = false

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 32))
                .foregroundStyle(.secondary)
            Text("Save preset")
                .font(.title3).bold()
            Text("Capture your current customizations as a reusable preset.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(20)
        .frame(width: 200, height: 210)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(hovering ? Color.accentColor.opacity(0.08) : Color(nsColor: .textBackgroundColor))
                .strokeBorder(Color.secondary.opacity(0.3), style: StrokeStyle(lineWidth: 1.5, dash: [8, 5]))
                .shadow(color: .black.opacity(hovering ? 0.12 : 0.06), radius: hovering ? 12 : 6, y: 4)
        )
        .scaleEffect(hovering ? 1.01 : 1)
        .onHover { hovering = $0 }
        .onTapGesture { onTap() }
    }
}

private struct PresetCard: View {
    let preset: PresetDefinition
    let highlights: [String]
    let isHighlighted: Bool
    var isCustom: Bool = false
    let onApply: () -> Void
    var onDelete: (() -> Void)? = nil
    @State private var hovering = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(Color.accentColor.opacity(0.2), in: RoundedRectangle(cornerRadius: 12))
                Spacer()
                if isCustom, let onDelete {
                    Button(role: .destructive) {
                        onDelete()
                    } label: {
                        Image(systemName: "trash")
                            .font(.caption)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                    .help("Delete preset")
                }
                Text("\(preset.items.count) setting\(preset.items.count == 1 ? "" : "s")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text(preset.name)
                .font(.title3).bold()
            Text(preset.description)
                .font(.callout)
                .foregroundStyle(.secondary)

            if !highlights.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(highlights, id: \.self) { highlight in
                        Label(highlight, systemImage: "checkmark.seal.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Spacer(minLength: 8)

            Button {
                onApply()
            } label: {
                Label("Apply this vibe", systemImage: "sparkles")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(20)
        .frame(width: 250, height: 210)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill((hovering || isHighlighted) ? Color.accentColor.opacity(0.12) : Color(nsColor: .textBackgroundColor))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(isHighlighted ? Color.accentColor : .clear, lineWidth: 2)
                )
                .shadow(color: .black.opacity(isHighlighted ? 0.25 : 0.15), radius: isHighlighted ? 18 : (hovering ? 14 : 8), y: 6)
        )
        .scaleEffect(isHighlighted ? 1.02 : (hovering ? 1.01 : 1))
        .onHover { hovering = $0 }
    }

    private var icon: String {
        if isCustom { return "person.crop.circle" }
        switch preset.name {
        case _ where preset.name.contains("Developer"): return "chevron.left.forwardslash.chevron.right"
        case _ where preset.name.contains("Screenshot"): return "camera.viewfinder"
        case _ where preset.name.contains("Snappy"): return "hare.fill"
        case _ where preset.name.contains("Minimal"): return "square.split.diagonal.2x2"
        default: return "wand.and.stars"
        }
    }
}

private struct SavePresetSheet: View {
    let onSave: (String, String) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var description = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Save preset")
                .font(.title2).bold()
            Text("Captures all your currently customized settings as a reusable preset deck.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            VStack(alignment: .leading, spacing: 12) {
                TextField("Name", text: $name, prompt: Text("My Setup"))
                    .textFieldStyle(.roundedBorder)
                TextField("Description", text: $description, prompt: Text("A short note about this preset"))
                    .textFieldStyle(.roundedBorder)
            }

            HStack(spacing: 12) {
                Button("Cancel", role: .cancel) { dismiss() }
                    .keyboardShortcut(.cancelAction)
                Button("Save") {
                    onSave(name, description)
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .padding(28)
        .frame(width: 380)
    }
}

private struct TimelineRow: View {
    let record: ChangeRecord

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack {
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 10, height: 10)
                Rectangle()
                    .fill(Color.accentColor.opacity(0.3))
                    .frame(width: 2)
                    .opacity(record.source == .preset ? 1 : 0)
            }
            .frame(width: 12)

            VStack(alignment: .leading, spacing: 2) {
                Text(record.displayName)
                    .fontWeight(.semibold)
                Text(record.source.rawValue.capitalized)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            ValueChangeChip(old: record.oldValue?.displayString ?? "default",
                            new: record.newValue?.displayString ?? "default")

            Text(record.appliedAt, style: .time)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 10)
    }
}

private struct ValueChangeChip: View {
    let old: String
    let new: String

    var body: some View {
        HStack(spacing: 6) {
            Text(old)
                .foregroundStyle(.secondary)
            Image(systemName: "arrow.right")
                .font(.caption2)
                .foregroundStyle(.tertiary)
            Text(new)
                .fontWeight(.semibold)
        }
        .font(.callout)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Capsule().fill(Color.accentColor.opacity(0.08)))
    }
}

private struct HomeMetrics {
    let totalSettings: Int
    let customizedSettings: Int
    let snapshotCount: Int
    let presetCount: Int
}

// MARK: - Import Preview

struct ImportPreview: Identifiable {
    let id = UUID()
    let fileName: String
    let snapshot: SnapshotRecord
    let changes: [SnapshotDiffItem]
    let plan: RestorePlan
}

private struct ImportPreviewSheet: View {
    let preview: ImportPreview
    let onApply: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Import \"\(preview.fileName)\"")
                        .font(.headline)
                    Text("\(preview.changes.count) setting\(preview.changes.count == 1 ? "" : "s") will change")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button("Cancel") { dismiss() }
                    .buttonStyle(.bordered)
                    .keyboardShortcut(.cancelAction)
                Button("Apply \(preview.changes.count) change\(preview.changes.count == 1 ? "" : "s")") {
                    onApply()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.defaultAction)
            }

            List(preview.changes) { item in
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.displayName)
                            .fontWeight(.medium)
                        Text(item.settingID)
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                            .fontDesign(.monospaced)
                    }
                    Spacer()
                    Text(item.currentValue?.displayString ?? "default")
                        .foregroundStyle(.secondary)
                    Image(systemName: "arrow.right")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                    Text(item.snapshotValue?.displayString ?? "default")
                        .foregroundStyle(.blue)
                        .fontWeight(.medium)
                }
                .font(.callout)
            }
            .listStyle(.bordered)
        }
        .padding(24)
        .frame(width: 620, height: 480)
    }
}
