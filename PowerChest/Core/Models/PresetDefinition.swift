import Foundation

struct PresetDefinition: Codable, Identifiable, Sendable {
    let id: String
    let name: String
    let description: String
    let items: [PresetItem]
    let riskSummary: RiskLevel
}

struct PresetItem: Codable, Sendable {
    let settingID: String
    let targetState: TargetState
}
