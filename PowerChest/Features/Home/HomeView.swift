import SwiftUI

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @State private var statusMessage: String?
    @State private var showConfetti = false

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
                        Label("Panic snapshot", systemImage: "camera.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.white.opacity(0.2))

                    Button {
                        appState.selectedSidebarItem = .snapshots
                    } label: {
                        Text("Open safety center")
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

            Text("Day \(Calendar.current.component(.day, from: .now)) energy")
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(.ultraThinMaterial, in: Capsule())
                .foregroundStyle(.white)
                .padding(20)
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
                     caption: "That's \(Int(Double(metrics.customizedSettings) / Double(max(metrics.totalSettings, 1)) * 100))% of the catalog",
                     accent: .orange,
                     progress: Double(metrics.customizedSettings) / Double(max(metrics.totalSettings, 1)))

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
        let presets = appState.catalogService.presets
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
                    ForEach(presets) { preset in
                        PresetCard(preset: preset,
                                   highlights: presetHighlights(for: preset),
                                   isHighlighted: appState.spotlightPresetID == preset.id) {
                            applyPreset(preset)
                        }
                    }
                }
                .padding(.vertical, 4)
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

    private var currentMetrics: HomeMetrics {
        let total = appState.catalogService.shippingDefinitions().count
        let customized = appState.settingStates.values.filter { $0.keyExists }.count
        let snapshots = appState.snapshotService.listSnapshots().count
        let presets = appState.catalogService.presets.count
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

private struct PresetCard: View {
    let preset: PresetDefinition
    let highlights: [String]
    let isHighlighted: Bool
    let onApply: () -> Void
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
        switch preset.name {
        case _ where preset.name.contains("Developer"): return "chevron.left.forwardslash.chevron.right"
        case _ where preset.name.contains("Screenshot"): return "camera.viewfinder"
        case _ where preset.name.contains("Snappy"): return "hare.fill"
        case _ where preset.name.contains("Minimal"): return "square.split.diagonal.2x2"
        default: return "wand.and.stars"
        }
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
