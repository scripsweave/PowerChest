import SwiftUI

struct ChangesView: View {
    @Environment(AppState.self) private var appState
    @State private var records: [ChangeRecord] = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Audit Trail")
                    .font(.largeTitle).bold()
                Text("Every tweak PowerChest makes lands here with the who/what/when. Rollback confidence builder.")
                    .font(.callout)
                    .foregroundStyle(.secondary)

                if records.isEmpty {
                    VStack(spacing: 16) {
                        FloatingEmptyIcon(systemImage: "list.bullet.rectangle", tint: .orange)
                        ContentUnavailableView(
                            "Suspiciously clean record",
                            systemImage: "list.bullet.clipboard",
                            description: Text("You haven't changed anything yet. Every tweak you make gets logged here — who, what, when, and why you can blame us.")
                        )
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 28).fill(.ultraThinMaterial))
                } else {
                    LazyVStack(alignment: .leading, spacing: 18) {
                        ForEach(groupedRecords, id: \.title) { section in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(section.title)
                                    .font(.title3).bold()
                                VStack(spacing: 0) {
                                    ForEach(section.entries) { record in
                                        ChangeTimelineRow(record: record)
                                        if record.id != section.entries.last?.id {
                                            Divider()
                                        }
                                    }
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 22).fill(.ultraThinMaterial))
                                .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 32)
        }
        .background(.clear)
        .onAppear {
            records = appState.changeLogService.allRecords()
        }
        .onChange(of: appState.lastApplyResult?.requestID) {
            records = appState.changeLogService.allRecords()
        }
    }

    private var groupedRecords: [TimelineSection] {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"

        let calendar = Calendar.current
        let grouped = Dictionary(grouping: records) { record in
            calendar.startOfDay(for: record.appliedAt)
        }

        return grouped
            .map { date, entries in
                let title: String
                if calendar.isDateInToday(date) {
                    title = "Today"}
                else if calendar.isDateInYesterday(date) {
                    title = "Yesterday"
                } else {
                    let weekday = formatter.string(from: date)
                    title = "\(weekday) Tinkering"
                }
                return TimelineSection(title: title, entries: entries.sorted(by: { $0.appliedAt > $1.appliedAt }))
            }
            .sorted(by: { lhs, rhs in
                guard let first = lhs.entries.first, let second = rhs.entries.first else { return false }
                return first.appliedAt > second.appliedAt
            })
    }

    private struct TimelineSection {
        let title: String
        let entries: [ChangeRecord]
    }
}

private struct ChangeTimelineRow: View {
    let record: ChangeRecord

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 6) {
                Circle()
                    .fill(sourceColor)
                    .frame(width: 12, height: 12)
                Rectangle()
                    .fill(sourceColor.opacity(0.3))
                    .frame(width: 2)
                    .frame(maxHeight: .infinity)
            }
            .frame(width: 12)

            VStack(alignment: .leading, spacing: 4) {
                Text(record.displayName)
                    .fontWeight(.semibold)
                Text(record.settingID)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .fontDesign(.monospaced)

                ChangeValueChip(old: record.oldValue?.displayString ?? "default",
                                new: record.newValue?.displayString ?? "default")

                HStack(spacing: 10) {
                    Label(record.source.rawValue.capitalized, systemImage: "person.wave.2")
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(sourceColor.opacity(0.15), in: Capsule())
                        .foregroundStyle(sourceColor)
                    Text(record.appliedAt, style: .time)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 10)
    }

    private var sourceColor: Color {
        switch record.source {
        case .preset: return .purple
        case .powerUser: return .blue
        case .propellerhead: return .orange
        case .restore: return .green
        case .profileImport: return .mint
        }
    }
}

private struct ChangeValueChip: View {
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

private struct FloatingEmptyIcon: View {
    let systemImage: String
    let tint: Color

    var body: some View {
        TimelineView(.animation) { context in
            let time = context.date.timeIntervalSinceReferenceDate
            let offset = sin(time * 1.5) * 8
            Image(systemName: systemImage)
                .font(.system(size: 46, weight: .semibold))
                .foregroundStyle(tint)
                .shadow(color: tint.opacity(0.25), radius: 10, y: 6)
                .offset(y: offset)
        }
        .frame(height: 70)
    }
}
