import SwiftUI

struct ChangesView: View {
    @Environment(AppState.self) private var appState
    @State private var records: [ChangeRecord] = []

    var body: some View {
        Form {
            if records.isEmpty {
                Section {
                    ContentUnavailableView(
                        "No Changes Yet",
                        systemImage: "list.bullet.clipboard",
                        description: Text("Go tweak something. Every change PowerChest makes will show up here.")
                    )
                }
            } else {
                Section("\(records.count) change\(records.count == 1 ? "" : "s")") {
                    ForEach(records) { record in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(record.displayName)
                                    .fontWeight(.medium)
                                Text(record.settingID)
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                                    .fontDesign(.monospaced)
                            }

                            Spacer()

                            HStack(spacing: 4) {
                                Text(record.oldValue?.displayString ?? "default")
                                    .foregroundStyle(.secondary)
                                Image(systemName: "arrow.right")
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                                Text(record.newValue?.displayString ?? "default")
                                    .fontWeight(.medium)
                            }
                            .font(.callout)

                            VStack(alignment: .trailing, spacing: 2) {
                                Text(record.source.rawValue)
                                    .font(.caption2)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 1)
                                    .background(.quaternary, in: Capsule())
                                Text(record.appliedAt, style: .relative)
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                            }
                            .frame(width: 90, alignment: .trailing)
                        }
                    }
                }
            }
        }
        .formStyle(.grouped)
        .onAppear {
            records = appState.changeLogService.allRecords()
        }
    }
}
