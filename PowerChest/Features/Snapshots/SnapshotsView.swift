import SwiftUI

struct SnapshotsView: View {
    @Environment(AppState.self) private var appState
    @State private var snapshots: [SnapshotRecord] = []
    @State private var selectedSnapshot: SnapshotRecord?
    @State private var showingManualCapture = false
    @State private var manualSnapshotName = ""
    @State private var message: String?

    var body: some View {
        Form {
            if let msg = message {
                Section {
                    ApplyResultBanner(message: msg) { message = nil }
                }
            }

            Section {
                Button {
                    showingManualCapture = true
                } label: {
                    Label("Create Manual Snapshot", systemImage: "camera.fill")
                }
            } footer: {
                Text("Snapshots capture every PowerChest-managed setting. Automatic ones are created before every change.")
            }

            if snapshots.isEmpty {
                Section {
                    ContentUnavailableView(
                        "No Snapshots Yet",
                        systemImage: "clock.arrow.circlepath",
                        description: Text("Make a change or create one manually. Snapshots are your safety net.")
                    )
                }
            } else {
                Section("\(snapshots.count) snapshot\(snapshots.count == 1 ? "" : "s")") {
                    ForEach(snapshots) { snapshot in
                        SnapshotRow(snapshot: snapshot) {
                            selectedSnapshot = snapshot
                        } onRestore: {
                            restoreSnapshot(snapshot)
                        } onDelete: {
                            deleteSnapshot(snapshot)
                        }
                    }
                }
            }
        }
        .formStyle(.grouped)
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
        let applied = result.outcomes.filter { if case .applied = $0.result { return true }; return false }.count
        message = "Restored \(applied) setting\(applied == 1 ? "" : "s") from \"\(snapshot.name)\"."
        refresh()
    }

    private func deleteSnapshot(_ snapshot: SnapshotRecord) {
        appState.snapshotService.deleteSnapshot(id: snapshot.id)
        refresh()
    }
}

// MARK: - Snapshot Row

private struct SnapshotRow: View {
    let snapshot: SnapshotRecord
    let onCompare: () -> Void
    let onRestore: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(snapshot.name)
                    .fontWeight(.medium)
                Spacer()
                Text(snapshot.kind.rawValue.capitalized)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(kindColor.opacity(0.15), in: Capsule())
                    .foregroundStyle(kindColor)
            }

            HStack(spacing: 12) {
                Label("\(snapshot.settingRecords.count)", systemImage: "gearshape")
                Label(snapshot.osVersion, systemImage: "desktopcomputer")
                Text(snapshot.createdAt, style: .relative)
                    .foregroundStyle(.tertiary)
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            HStack(spacing: 16) {
                Button("Compare") { onCompare() }
                Button("Restore") { onRestore() }
                if snapshot.kind != .automatic {
                    Button("Delete", role: .destructive) { onDelete() }
                }
            }
            .font(.caption)
            .buttonStyle(.borderless)
        }
        .padding(.vertical, 4)
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
