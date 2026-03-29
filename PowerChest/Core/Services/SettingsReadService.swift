import Foundation

final class SettingsReadService: Sendable {
    private let defaultsAdapter = DefaultsAdapter()
    private let commandAdapter = CommandAdapter()
    private let compatibility: CompatibilityService

    init(compatibility: CompatibilityService) {
        self.compatibility = compatibility
    }

    func readState(for definition: SettingDefinition) -> SettingState {
        switch definition.mechanism {
        case .defaults:
            return readDefaultsState(for: definition)
        case .command:
            return readCommandState(for: definition)
        }
    }

    func readAllStates(for definitions: [SettingDefinition]) -> [String: SettingState] {
        var result: [String: SettingState] = [:]
        for def in definitions {
            result[def.id] = readState(for: def)
        }
        return result
    }

    private func readDefaultsState(for definition: SettingDefinition) -> SettingState {
        guard let domain = definition.domain,
              let key = definition.keyPath else {
            return SettingState(
                definitionID: definition.id,
                currentValue: nil,
                keyExists: false,
                isSupported: compatibility.isSupported(definition),
                lastObserved: Date()
            )
        }

        let exists = defaultsAdapter.keyExists(domain: domain, key: key)
        let value = defaultsAdapter.readParsed(domain: domain, key: key, valueType: definition.valueType)

        return SettingState(
            definitionID: definition.id,
            currentValue: value,
            keyExists: exists,
            isSupported: compatibility.isSupported(definition),
            lastObserved: Date()
        )
    }

    private func readCommandState(for definition: SettingDefinition) -> SettingState {
        let value = commandAdapter.read(settingID: definition.id)
        let exists = commandAdapter.keyExists(settingID: definition.id)

        return SettingState(
            definitionID: definition.id,
            currentValue: value,
            keyExists: exists,
            isSupported: compatibility.isSupported(definition),
            lastObserved: Date()
        )
    }
}
