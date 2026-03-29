import Foundation

struct SettingState: Identifiable, Sendable {
    var id: String { definitionID }

    let definitionID: String
    var currentValue: CodableValue?
    var keyExists: Bool
    var isSupported: Bool
    var lastObserved: Date

    var effectiveDisplayValue: String {
        currentValue?.displayString ?? "System default"
    }
}
