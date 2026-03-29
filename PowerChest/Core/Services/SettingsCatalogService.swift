import Foundation

final class SettingsCatalogService: Sendable {
    let definitions: [SettingDefinition]
    let groupedControls: [GroupedControlDefinition]
    let presets: [PresetDefinition]

    private let definitionsByID: [String: SettingDefinition]
    private let definitionsByCategory: [SettingCategory: [SettingDefinition]]
    private let groupedControlsByCategory: [SettingCategory: [GroupedControlDefinition]]

    init() {
        let defs = SettingsCatalogData.allSettings
        self.definitions = defs
        self.groupedControls = SettingsCatalogData.allGroupedControls
        self.presets = SettingsCatalogData.allPresets

        var byID: [String: SettingDefinition] = [:]
        var byCat: [SettingCategory: [SettingDefinition]] = [:]
        for d in defs {
            byID[d.id] = d
            byCat[d.category, default: []].append(d)
        }
        self.definitionsByID = byID
        self.definitionsByCategory = byCat

        var gcByCat: [SettingCategory: [GroupedControlDefinition]] = [:]
        for gc in SettingsCatalogData.allGroupedControls {
            gcByCat[gc.category, default: []].append(gc)
        }
        self.groupedControlsByCategory = gcByCat
    }

    func definition(for id: String) -> SettingDefinition? {
        definitionsByID[id]
    }

    func definitions(for category: SettingCategory) -> [SettingDefinition] {
        definitionsByCategory[category] ?? []
    }

    func shippingDefinitions(for category: SettingCategory) -> [SettingDefinition] {
        definitions(for: category).filter { $0.supportLevel == .shipping }
    }

    func groupedControls(for category: SettingCategory) -> [GroupedControlDefinition] {
        groupedControlsByCategory[category] ?? []
    }

    func settingsForGroupedControl(_ gc: GroupedControlDefinition) -> [SettingDefinition] {
        gc.backingSettingIDs.compactMap { definitionsByID[$0] }
    }

    func shippingDefinitions() -> [SettingDefinition] {
        definitions.filter { $0.supportLevel == .shipping }
    }
}
