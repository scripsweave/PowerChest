import SwiftUI

struct SnapshotsView: View {
    @Environment(AppState.self) private var appState
    @State private var snapshots: [SnapshotRecord] = []
    @State private var selectedSnapshot: SnapshotRecord?
    @State private var showingManualCapture = false
    @State private var manualSnapshotName = ""
    @State private var message: String?
    @State private var collapsedDays: Set<String> = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                if let msg = message {
                    ApplyResultBanner(message: msg) { message = nil }
                }

                SnapshotHeroCard(snapshotCount: snapshots.count) {
                    showingManualCapture = true
                }

                if snapshots.isEmpty {
                    VStack(spacing: 16) {
                        FloatingEmptyIcon(systemImage: "clock.arrow.circlepath", tint: .blue)
                        ContentUnavailableView(
                            "No Snapshots Yet",
                            systemImage: "clock.arrow.circlepath",
                            description: Text("Make a change or create one manually. Snapshots are your safety net.")
                        )
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .fill(Color(nsColor: .textBackgroundColor))
                    )
                    .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
                } else {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Timeline")
                            .font(.title2).bold()

                        let grouped = groupedByDay(snapshots)

                        LazyVStack(spacing: 20) {
                            ForEach(grouped, id: \.dayLabel) { group in
                                daySection(group)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 32)
        }
        .background(Color(nsColor: .controlBackgroundColor))
        .onAppear { refresh() }
        .onChange(of: appState.lastApplyResult?.requestID) {
            refresh()
        }
        .sheet(isPresented: $showingManualCapture) {
            ManualSnapshotSheet(name: $manualSnapshotName) {
                createManualSnapshot()
            }
        }
        .sheet(item: $selectedSnapshot) { snapshot in
            SnapshotDetailSheet(snapshot: snapshot, appState: appState) {
                selectedSnapshot = nil
            }
        }
    }

    // MARK: - Day Section

    @ViewBuilder
    private func daySection(_ group: DayGroup) -> some View {
        let isCollapsed = collapsedDays.contains(group.dayLabel)

        VStack(alignment: .leading, spacing: 12) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    if isCollapsed {
                        collapsedDays.remove(group.dayLabel)
                    } else {
                        collapsedDays.insert(group.dayLabel)
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(isCollapsed ? 0 : 90))

                    Text(group.dayLabel)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text("\(group.snapshots.count)")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 2)
                        .background(Color.secondary.opacity(0.12), in: Capsule())

                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if !isCollapsed {
                LazyVStack(spacing: 16) {
                    ForEach(group.snapshots) { snapshot in
                        SnapshotCard(
                            snapshot: snapshot,
                            onCompare: { selectedSnapshot = snapshot },
                            onRestore: { restoreSnapshot(snapshot) },
                            onDelete: { deleteSnapshot(snapshot) }
                        )
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    // MARK: - Grouping

    private struct DayGroup {
        let dayLabel: String
        let sortDate: Date
        let snapshots: [SnapshotRecord]
    }

    private func groupedByDay(_ snapshots: [SnapshotRecord]) -> [DayGroup] {
        let calendar = Calendar.current
        let now = Date()

        let dict = Dictionary(grouping: snapshots) { snapshot -> String in
            dayLabel(for: snapshot.createdAt, calendar: calendar, now: now)
        }

        return dict.map { key, value in
            let earliest = value.map(\.createdAt).min() ?? now
            return DayGroup(dayLabel: key, sortDate: earliest, snapshots: value.sorted { $0.createdAt > $1.createdAt })
        }
        .sorted { $0.sortDate > $1.sortDate }
    }

    private func dayLabel(for date: Date, calendar: Calendar, now: Date) -> String {
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE d MMMM"
            return formatter.string(from: date)
        }
    }

    // MARK: - Actions

    private func refresh() {
        snapshots = appState.snapshotService.listSnapshots()
    }

    private func createManualSnapshot() {
        do {
            _ = try appState.snapshotService.createManualSnapshot(
                name: manualSnapshotName.isEmpty ? nil : manualSnapshotName,
                notes: nil
            )
            manualSnapshotName = ""
            refresh()
            message = "Snapshot created."
        } catch {
            message = "Failed: \(error.localizedDescription)"
        }
    }

    private func restoreSnapshot(_ snapshot: SnapshotRecord) {
        guard !appState.isApplying else { return }
        guard let plan = appState.snapshotService.buildRestorePlan(snapshot: snapshot, selectedSettingIDs: nil) else {
            message = "Nothing to restore — everything already matches."
            return
        }
        appState.isApplying = true
        let request = plan.applyRequest
        let snapshotName = snapshot.name

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
                message = "Restored \(applied) setting\(applied == 1 ? "" : "s") from \"\(snapshotName)\"."
                refresh()
            }
        }
    }

    private func deleteSnapshot(_ snapshot: SnapshotRecord) {
        appState.snapshotService.deleteSnapshot(id: snapshot.id)
        refresh()
    }
}

// MARK: - Snapshot Cards

private struct SnapshotHeroCard: View {
    let snapshotCount: Int
    let onCreate: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Time Machine")
                .font(.largeTitle).bold()
                .foregroundStyle(.white)
            Text("Every change creates a restore point. Go back to any moment.")
                .foregroundStyle(.white.opacity(0.85))

            HStack(spacing: 16) {
                Label("\(snapshotCount) saved", systemImage: "clock.arrow.circlepath")
                    .foregroundStyle(.white)
                Spacer()
                Button(action: onCreate) {
                    Label("Manual snapshot", systemImage: "camera.fill")
                        .fontWeight(.semibold)
                }
                .buttonStyle(.borderedProminent)
                .tint(.white)
                .foregroundStyle(.blue)
                .background(RoundedRectangle(cornerRadius: 16).fill(.white))
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        )
        .overlay(alignment: .bottomTrailing) {
            Image(systemName: "lifepreserver")
                .font(.system(size: 60))
                .foregroundStyle(.white.opacity(0.25))
                .padding(20)
        }
        .shadow(color: .black.opacity(0.2), radius: 20, y: 10)
    }
}

private struct SnapshotCard: View {
    let snapshot: SnapshotRecord
    let onCompare: () -> Void
    let onRestore: () -> Void
    let onDelete: () -> Void
    @Environment(AppState.self) private var appState
    @State private var changed: [SnapshotDiffItem]?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(snapshot.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("\(snapshot.kind.rawValue.capitalized) · \(snapshot.createdAt, style: .relative) ago · \(snapshot.osVersion)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(snapshot.kind.rawValue.capitalized)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(kindColor.opacity(0.18), in: Capsule())
                    .foregroundStyle(kindColor)
            }

            // Inline diff (loaded asynchronously)
            if let changed {
                if changed.isEmpty {
                    Label("Everything matches current state", systemImage: "checkmark.circle")
                        .font(.caption)
                        .foregroundStyle(.green)
                } else {
                    VStack(spacing: 0) {
                        ForEach(changed.prefix(5)) { item in
                            HStack(spacing: 8) {
                                Text(item.displayName)
                                    .font(.caption)
                                    .lineLimit(1)
                                Spacer()
                                Text(item.snapshotValue?.displayString ?? "default")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Image(systemName: "arrow.right")
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                                Text(item.currentValue?.displayString ?? "default")
                                    .font(.caption)
                                    .foregroundStyle(.blue)
                            }
                            .padding(.vertical, 4)
                            if item.id != changed.prefix(5).last?.id {
                                Divider()
                            }
                        }
                        if changed.count > 5 {
                            Text("+ \(changed.count - 5) more change\(changed.count - 5 == 1 ? "" : "s")")
                                .font(.caption2)
                                .foregroundStyle(.tertiary)
                                .padding(.top, 4)
                        }
                    }
                    .padding(12)
                    .background(Color(nsColor: .controlBackgroundColor).opacity(0.5), in: RoundedRectangle(cornerRadius: 10))
                }
            } else {
                ProgressView()
                    .controlSize(.small)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 4)
            }

            HStack(spacing: 14) {
                if let changed, !changed.isEmpty {
                    Button("Full diff", action: onCompare)
                }
                Button("Restore", action: onRestore)
                if snapshot.kind != .automatic {
                    Button("Delete", role: .destructive, action: onDelete)
                }
            }
            .buttonStyle(.bordered)
            .font(.caption)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Color(nsColor: .textBackgroundColor))
        )
        .shadow(color: .black.opacity(0.08), radius: 14, y: 6)
        .task(id: snapshot.id) {
            let diff = appState.snapshotService.diffSnapshotToCurrent(snapshot: snapshot)
            changed = diff.filter { $0.classification == .changed }
        }
    }

    private var kindColor: Color {
        switch snapshot.kind {
        case .automatic: return .blue
        case .manual: return .green
        case .milestone: return .orange
        case .imported: return .purple
        }
    }
}

// MARK: - Manual Snapshot Sheet

private struct ManualSnapshotSheet: View {
    @Binding var name: String
    let onSave: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "camera.fill")
                .font(.largeTitle)
                .foregroundStyle(.blue)
            Text("Create Manual Snapshot")
                .font(.headline)
            Text("Captures every PowerChest-managed setting on this Mac right now.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            TextField("Snapshot name (optional)", text: $name)
                .textFieldStyle(.roundedBorder)
            HStack {
                Button("Cancel") { dismiss() }
                    .buttonStyle(.bordered)
                    .keyboardShortcut(.cancelAction)
                Button("Create") {
                    onSave()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding(30)
        .frame(width: 380)
    }
}

// MARK: - Snapshot Detail Sheet

private struct SnapshotDetailSheet: View {
    let snapshot: SnapshotRecord
    let appState: AppState
    let onDismiss: () -> Void
    @State private var changed: [SnapshotDiffItem]?
    @State private var unchangedCount = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text(snapshot.name)
                        .font(.headline)
                    Text("Created \(snapshot.createdAt, style: .relative) ago · \(snapshot.osVersion)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button("Done") { onDismiss() }
                    .buttonStyle(.borderedProminent)
                    .keyboardShortcut(.defaultAction)
            }

            if let changed {
                if changed.isEmpty {
                    ContentUnavailableView(
                        "Everything Matches",
                        systemImage: "checkmark.circle",
                        description: Text("The current state matches this snapshot exactly.")
                    )
                } else {
                    Text("\(changed.count) difference\(changed.count == 1 ? "" : "s"), \(unchangedCount) unchanged")
                        .font(.callout)
                        .foregroundStyle(.secondary)

                    List(changed) { item in
                        HStack {
                            Text(item.displayName)
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
            } else {
                Spacer()
                ProgressView("Computing diff...")
                    .frame(maxWidth: .infinity)
                Spacer()
            }
        }
        .padding(24)
        .frame(width: 580, height: 450)
        .task {
            let diff = appState.snapshotService.diffSnapshotToCurrent(snapshot: snapshot)
            changed = diff.filter { $0.classification == .changed }
            unchangedCount = diff.filter { $0.classification == .unchanged }.count
        }
    }
}

private struct FloatingEmptyIcon: View {
    let systemImage: String
    let tint: Color

    var body: some View {
        TimelineView(.animation) { context in
            let time = context.date.timeIntervalSinceReferenceDate
            let offset = sin(time * 1.6) * 8
            Image(systemName: systemImage)
                .font(.system(size: 48, weight: .semibold))
                .foregroundStyle(tint)
                .shadow(color: tint.opacity(0.3), radius: 10, y: 6)
                .offset(y: offset)
        }
        .frame(height: 70)
    }
}
