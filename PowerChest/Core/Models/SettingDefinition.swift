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
}
