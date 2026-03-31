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

    /// Whether this setting has been changed from the stock macOS value.
    /// For defaults-based settings, key existence is the signal.
    /// For command-based settings, compares current value against the known macOS default.
    func isCustomized(definition: SettingDefinition) -> Bool {
        if let macDefault = definition.macOSDefaultValue {
            guard let current = currentValue else { return false }
            return current != macDefault
        }
        return keyExists
    }
}
