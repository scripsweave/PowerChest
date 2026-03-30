import SwiftUI

struct SnapshotsView: View {
    @Environment(AppState.self) private var appState
    @State private var snapshots: [SnapshotRecord] = []
    @State private var selectedSnapshot: SnapshotRecord?
    @State private var showingManualCapture = false
    @State private var manualSnapshotName = ""
    @State private var message: String?

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
                        LazyVStack(spacing: 16) {
                            ForEach(snapshots) { snapshot in
                                SnapshotCard(
                                    snapshot: snapshot,
                                    onCompare: { selectedSnapshot = snapshot },
                                    onRestore: { restoreSnapshot(snapshot) },
                                    onDelete: { deleteSnapshot(snapshot) }
                                )
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
        guard let plan = appState.snapshotService.buildRestorePlan(snapshot: snapshot, selectedSettingIDs: nil) else {
            message = "Nothing to restore — everything already matches."
            return
        }
        let result = appState.applyEngine.apply(plan.applyRequest)
        appState.refreshAllStates()
        appState.enqueueRestartRequests(result.pendingRestarts)
        let applied = result.outcomes.filter { if case .applied = $0.result { return true }; return false }.count
        message = "Restored \(applied) setting\(applied == 1 ? "" : "s") from \"\(snapshot.name)\"."
        refresh()
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
            Text("Snapshots are your seatbelt")
                .font(.largeTitle).bold()
                .foregroundStyle(.white)
            Text("Automatic ones happen before every change. Drop extras whenever the experiment feels spicy.")
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

            Label("\(snapshot.settingRecords.count) captured settings", systemImage: "gearshape")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 14) {
                Button("Compare", action: onCompare)
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

    var body: some View {
        let diff = appState.snapshotService.diffSnapshotToCurrent(snapshot: snapshot)
        let changed = diff.filter { $0.classification == .changed }
        let unchanged = diff.filter { $0.classification == .unchanged }

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

            if changed.isEmpty {
                ContentUnavailableView(
                    "Everything Matches",
                    systemImage: "checkmark.circle",
                    description: Text("The current state matches this snapshot exactly.")
                )
            } else {
                Text("\(changed.count) difference\(changed.count == 1 ? "" : "s"), \(unchanged.count) unchanged")
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
        }
        .padding(24)
        .frame(width: 580, height: 450)
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
