import Foundation

struct SettingDefinition: Codable, Identifiable, Sendable {
    let id: String
    let displayName: String
    let technicalName: String?
    let powerUserLabel: String?
    let powerUserDescription: String
    let propellerheadDescription: String
    let category: SettingCategory
    let risk: RiskLevel
    let interest: InterestLevel
    let supportLevel: SupportLevel
    let mechanism: SettingMechanism
    let domain: String?
    let keyPath: String?
    let valueType: SettingValueType
    let allowedValues: [CodableValue]?
    let defaultValueStrategy: DefaultValueStrategy
    let supportedOS: OSRange
    let restartRequirement: RestartRequirement
    let powerUserGrouping: String?
    let searchAliases: [String]
    let notes: String?
    let isInvertedInPowerUserMode: Bool

    init(id: String, displayName: String, technicalName: String?, powerUserLabel: String?,
         powerUserDescription: String, propellerheadDescription: String, category: SettingCategory,
         risk: RiskLevel, interest: InterestLevel, supportLevel: SupportLevel,
         mechanism: SettingMechanism, domain: String?, keyPath: String?,
         valueType: SettingValueType, allowedValues: [CodableValue]?,
         defaultValueStrategy: DefaultValueStrategy, supportedOS: OSRange,
         restartRequirement: RestartRequirement, powerUserGrouping: String?,
         searchAliases: [String], notes: String?, isInvertedInPowerUserMode: Bool = false) {
        self.id = id
        self.displayName = displayName
        self.technicalName = technicalName
        self.powerUserLabel = powerUserLabel
        self.powerUserDescription = powerUserDescription
        self.propellerheadDescription = propellerheadDescription
        self.category = category
        self.risk = risk
        self.interest = interest
        self.supportLevel = supportLevel
        self.mechanism = mechanism
        self.domain = domain
        self.keyPath = keyPath
        self.valueType = valueType
        self.allowedValues = allowedValues
        self.defaultValueStrategy = defaultValueStrategy
        self.supportedOS = supportedOS
        self.restartRequirement = restartRequirement
        self.powerUserGrouping = powerUserGrouping
        self.searchAliases = searchAliases
        self.notes = notes
        self.isInvertedInPowerUserMode = isInvertedInPowerUserMode
    }

    var requiresAdmin: Bool {
        mechanism == .privilegedDefaults || mechanism == .privilegedCommand
    }
}
