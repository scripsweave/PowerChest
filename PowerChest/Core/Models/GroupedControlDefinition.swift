import Foundation

enum GroupedControlKind: String, Codable, Sendable {
    case toggle
    case multiToggle
    case discreteChoice
    case slider
    case action
    case multiControl
}

struct MappingOption: Codable, Identifiable, Sendable {
    var id: String { label }
    let label: String
    let settingValues: [String: TargetState]
}

struct GroupedControlDefinition: Codable, Identifiable, Sendable {
    let id: String
    let title: String
    let subtitle: String
    let category: SettingCategory
    let kind: GroupedControlKind
    let backingSettingIDs: [String]
    let options: [MappingOption]?
}
