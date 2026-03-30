import Foundation

final class SettingsReadService: Sendable {
    let defaultsAdapter: DefaultsAdapter
    let commandAdapter: CommandAdapter
    let privilegedAdapter: PrivilegedAdapter
    private let compatibility: CompatibilityService

    init(defaultsAdapter: DefaultsAdapter = DefaultsAdapter(),
         commandAdapter: CommandAdapter = CommandAdapter(),
         privilegedAdapter: PrivilegedAdapter = PrivilegedAdapter(),
         compatibility: CompatibilityService) {
        self.defaultsAdapter = defaultsAdapter
        self.commandAdapter = commandAdapter
        self.privilegedAdapter = privilegedAdapter
        self.compatibility = compatibility
    }

    func readState(for definition: SettingDefinition) -> SettingState {
        switch definition.mechanism {
        case .defaults:
            return readDefaultsState(for: definition)
        case .command:
            return readCommandState(for: definition)
        case .privilegedDefaults:
            return readPrivilegedDefaultsState(for: definition)
        case .privilegedCommand:
            return readPrivilegedCommandState(for: definition)
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

        // Single read — derive existence from whether we got a value
        let value = defaultsAdapter.readParsed(domain: domain, key: key, valueType: definition.valueType)
        let exists = value != nil || defaultsAdapter.keyExists(domain: domain, key: key)

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

    private func readPrivilegedDefaultsState(for definition: SettingDefinition) -> SettingState {
        guard let domain = definition.domain,
              let key = definition.keyPath else {
            return SettingState(
                definitionID: definition.id, currentValue: nil, keyExists: false,
                isSupported: compatibility.isSupported(definition), lastObserved: Date()
            )
        }

        let value = privilegedAdapter.readParsed(domain: domain, key: key, valueType: definition.valueType)
        let exists = value != nil || privilegedAdapter.keyExists(domain: domain, key: key)

        return SettingState(
            definitionID: definition.id, currentValue: value, keyExists: exists,
            isSupported: compatibility.isSupported(definition), lastObserved: Date()
        )
    }

    private func readPrivilegedCommandState(for definition: SettingDefinition) -> SettingState {
        let value = privilegedAdapter.read(settingID: definition.id)
        let exists = privilegedAdapter.commandKeyExists(settingID: definition.id)

        return SettingState(
            definitionID: definition.id, currentValue: value, keyExists: exists,
            isSupported: compatibility.isSupported(definition), lastObserved: Date()
        )
    }
}
