import SwiftUI
import UniformTypeIdentifiers

struct CategoryPaneView: View {
    let category: SettingCategory
    @Environment(AppState.self) private var appState
    @State private var viewModel: CategoryPaneViewModel?

    private var sidebarItem: SidebarItem? {
        SidebarItem.allCases.first { $0.settingCategory == category }
    }

    var body: some View {
        if let vm = viewModel {
            Form {
                // Centered category header (like System Settings)
                if let item = sidebarItem {
                    Section {
                        CategoryHeaderView(item, subtitle: item.categoryDescription)
                    }
                    .listRowBackground(Color.clear)
                }

                // Result banner
                if let msg = vm.applyResultMessage {
                    Section {
                        ApplyResultBanner(message: msg) {
                            vm.applyResultMessage = nil
                        }
                    }
                }

                if appState.userMode == .powerUser {
                    PowerUserContent(viewModel: vm)
                } else {
                    PropellerheadContent(viewModel: vm)
                }
            }
            .formStyle(.grouped)
            .safeAreaInset(edge: .bottom) {
                if vm.hasPendingChanges {
                    ApplyBar(viewModel: vm)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 12)
                }
            }
            .onAppear {
                appState.refreshStates(for: category)
            }
            .onChange(of: category) {
                appState.refreshStates(for: category)
                viewModel = CategoryPaneViewModel(category: category, appState: appState)
            }
        } else {
            Color.clear.onAppear {
                appState.refreshStates(for: category)
                viewModel = CategoryPaneViewModel(category: category, appState: appState)
            }
        }
    }
}

// MARK: - Power User Content

private struct PowerUserContent: View {
    let viewModel: CategoryPaneViewModel
    @Environment(AppState.self) private var appState

    var body: some View {
        let groupedControls = appState.catalogService.groupedControls(for: viewModel.category)

        if groupedControls.isEmpty {
            Section {
                ContentUnavailableView(
                    "No Controls Yet",
                    systemImage: "slider.horizontal.3",
                    description: Text("Power User controls for this category are coming soon.")
                )
            }
        } else {
            ForEach(groupedControls) { gc in
                InteractiveGroupedControl(groupedControl: gc, viewModel: viewModel)
            }
        }
    }
}

// MARK: - Propellerhead Content

private struct PropellerheadContent: View {
    let viewModel: CategoryPaneViewModel
    @Environment(AppState.self) private var appState

    var body: some View {
        let definitions = appState.catalogService.shippingDefinitions(for: viewModel.category)

        if definitions.isEmpty {
            Section {
                ContentUnavailableView(
                    "No Settings",
                    systemImage: "gearshape",
                    description: Text("No settings in this category.")
                )
            }
        } else {
            // One clean section with all settings
            Section {
                ForEach(definitions) { def in
                    PropellerheadSettingRow(definition: def, viewModel: viewModel)
                }
            }
        }
    }
}

// MARK: - Interactive Grouped Control (Power User)

struct InteractiveGroupedControl: View {
    let groupedControl: GroupedControlDefinition
    @Bindable var viewModel: CategoryPaneViewModel
    @Environment(AppState.self) private var appState

    var body: some View {
        Section {
            controlBody
        } header: {
            HStack(spacing: 6) {
                Text(groupedControl.title)
                Spacer()
                badges
            }
        } footer: {
            Text(groupedControl.subtitle)
        }
    }

    @ViewBuilder
    private var controlBody: some View {
        switch groupedControl.kind {
        case .toggle:
            toggleControl

        case .discreteChoice:
            discreteChoiceControl

        case .multiToggle:
            multiToggleControl

        case .multiControl:
            multiControlBody

        default:
            Text("Control: \(groupedControl.kind.rawValue)")
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var toggleControl: some View {
        if let settingID = groupedControl.backingSettingIDs.first,
           let def = appState.catalogService.definition(for: settingID) {
            ToggleRow(
                settingID: settingID,
                definition: def,
                viewModel: viewModel,
                isInverted: isInvertedToggle(def: def)
            )
        }
    }

    @ViewBuilder
    private var discreteChoiceControl: some View {
        if let options = groupedControl.options {
            let currentLabel = derivedOptionLabel(options: options)

            Picker(groupedControl.title, selection: Binding(
                get: { currentLabel },
                set: { newLabel in
                    if let option = options.first(where: { $0.label == newLabel }) {
                        for (settingID, target) in option.settingValues {
                            viewModel.stageChange(settingID: settingID, target: target)
                        }
                    }
                }
            )) {
                ForEach(options) { option in
                    Text(option.label).tag(option.label)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
        }
    }

    @ViewBuilder
    private var multiToggleControl: some View {
        ForEach(groupedControl.backingSettingIDs, id: \.self) { settingID in
            if let def = appState.catalogService.definition(for: settingID) {
                ToggleRow(
                    settingID: settingID,
                    definition: def,
                    viewModel: viewModel,
                    isInverted: isInvertedToggle(def: def)
                )
            }
        }
    }

    @ViewBuilder
    private var multiControlBody: some View {
        ForEach(groupedControl.backingSettingIDs, id: \.self) { settingID in
            if let def = appState.catalogService.definition(for: settingID) {
                SettingValueRow(definition: def, viewModel: viewModel)
            }
        }
    }

    // MARK: - Helpers

    private func effectiveValue(settingID: String, state: SettingState?) -> CodableValue? {
        if let staged = viewModel.stagedChanges[settingID] {
            if case .explicitValue(let v) = staged { return v }
            return nil
        }
        return state?.currentValue
    }

    private func isInvertedToggle(def: SettingDefinition) -> Bool {
        // These settings have raw values that mean the opposite of the Power User label
        [
            "global.pressAndHoldEnabled",   // true = accent popup, PU wants key repeat
            "dock.mruSpaces",               // true = auto rearrange, PU wants fixed order
            "global.saveToLocalDisk",       // true = iCloud, PU wants local disk
            "finder.disableExtensionChangeWarning", // true = warning on, PU wants skip
            "dock.showRecents",             // true = recents shown, PU wants hidden
            "textEdit.plainTextDefault",    // true = rich text, PU wants plain text
            "finder.warnOnEmptyTrash",      // true = warning on, PU wants skip
            "safari.autoOpenSafeDownloads", // true = auto-open, PU wants stop
            "spaces.spansDisplays",         // true = shared spaces, PU wants separate
        ].contains(def.id)
    }

    private func derivedOptionLabel(options: [MappingOption]) -> String {
        for option in options {
            var matches = true
            for (settingID, target) in option.settingValues {
                let currentValue = effectiveValue(settingID: settingID, state: appState.state(for: settingID))
                switch target {
                case .systemDefault:
                    let state = appState.state(for: settingID)
                    if state?.keyExists == true { matches = false }
                case .explicitValue(let expected):
                    if currentValue != expected { matches = false }
                }
            }
            if matches { return option.label }
        }
        return "Custom"
    }

    private var badges: some View {
        HStack(spacing: 4) {
            let risks = groupedControl.backingSettingIDs.compactMap {
                appState.catalogService.definition(for: $0)?.risk
            }
            let worst = risks.max(by: { riskOrder($0) < riskOrder($1) }) ?? .safe
            if worst != .safe {
                RiskBadgeView(risk: worst)
            }

            let reqs = groupedControl.backingSettingIDs.compactMap {
                appState.catalogService.definition(for: $0)?.restartRequirement
            }.filter { $0.isRequired }
            if let first = reqs.first {
                RestartBadgeView(requirement: first)
            }
        }
    }
}

// MARK: - Shared Setting Value Row (used by both modes)

struct SettingValueRow: View {
    let definition: SettingDefinition
    @Bindable var viewModel: CategoryPaneViewModel
    @Environment(AppState.self) private var appState
    @State private var showingFolderPicker = false

    var body: some View {
        let currentValue = effectiveValue

        switch definition.valueType {
        case .bool:
            Toggle(definition.powerUserLabel ?? definition.displayName, isOn: Binding(
                get: { currentValue?.asBool ?? false },
                set: { viewModel.stageChange(settingID: definition.id, target: .explicitValue(.bool($0))) }
            ))

        case .int:
            LabeledContent(definition.powerUserLabel ?? definition.displayName) {
                TextField("", value: Binding(
                    get: { currentValue?.asInt ?? 0 },
                    set: { viewModel.stageChange(settingID: definition.id, target: .explicitValue(.int($0))) }
                ), format: .number)
                .frame(width: 60)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.trailing)
            }

        case .double:
            LabeledContent(definition.powerUserLabel ?? definition.displayName) {
                TextField("", value: Binding(
                    get: { currentValue?.asDouble ?? 0.0 },
                    set: { viewModel.stageChange(settingID: definition.id, target: .explicitValue(.double($0))) }
                ), format: .number.precision(.fractionLength(2)))
                .frame(width: 60)
                .textFieldStyle(.roundedBorder)
                .multilineTextAlignment(.trailing)
            }

        case .path:
            LabeledContent(definition.powerUserLabel ?? definition.displayName) {
                HStack(spacing: 6) {
                    Text(shortPath(currentValue?.asString))
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.head)
                    Button("Choose\u{2026}") {
                        showingFolderPicker = true
                    }
                    .controlSize(.small)
                }
            }
            .fileImporter(
                isPresented: $showingFolderPicker,
                allowedContentTypes: [.folder],
                allowsMultipleSelection: false
            ) { result in
                if case .success(let urls) = result, let url = urls.first {
                    viewModel.stageChange(
                        settingID: definition.id,
                        target: .explicitValue(.path(url.path(percentEncoded: false)))
                    )
                }
            }

        case .string:
            LabeledContent(definition.powerUserLabel ?? definition.displayName) {
                TextField("", text: Binding(
                    get: { currentValue?.asString ?? "" },
                    set: { viewModel.stageChange(settingID: definition.id, target: .explicitValue(.string($0))) }
                ))
                .frame(width: 140)
                .textFieldStyle(.roundedBorder)
            }

        case .enum:
            if let allowed = definition.allowedValues {
                Picker(definition.powerUserLabel ?? definition.displayName, selection: Binding(
                    get: { currentValue ?? .string("") },
                    set: { viewModel.stageChange(settingID: definition.id, target: .explicitValue($0)) }
                )) {
                    ForEach(allowed, id: \.self) { val in
                        Text(val.displayString).tag(val)
                    }
                }
            }
        }
    }

    private var effectiveValue: CodableValue? {
        if let staged = viewModel.stagedChanges[definition.id] {
            if case .explicitValue(let v) = staged { return v }
            return nil
        }
        return appState.state(for: definition.id)?.currentValue
    }

    private func shortPath(_ path: String?) -> String {
        guard let path else { return "System default" }
        return path
            .replacingOccurrences(of: NSHomeDirectory(), with: "~")
    }
}

// MARK: - Toggle Row (handles bool and int-based toggles)

private struct ToggleRow: View {
    let settingID: String
    let definition: SettingDefinition
    @Bindable var viewModel: CategoryPaneViewModel
    let isInverted: Bool
    @Environment(AppState.self) private var appState

    private var displayValue: Bool {
        let currentValue = effectiveValue
        let isIntToggle = definition.valueType == .int
        let rawBool: Bool
        if isIntToggle {
            rawBool = (currentValue?.asInt ?? 0) != 0
        } else {
            rawBool = currentValue?.asBool ?? false
        }
        return isInverted ? !rawBool : rawBool
    }

    var body: some View {
        Toggle(definition.powerUserLabel ?? definition.displayName, isOn: Binding(
            get: { displayValue },
            set: { newVal in
                let effectiveVal = isInverted ? !newVal : newVal
                if definition.valueType == .int {
                    let onValue = definition.allowedValues?.compactMap({ $0.asInt }).max() ?? 3
                    viewModel.stageChange(settingID: settingID, target: .explicitValue(.int(effectiveVal ? onValue : 0)))
                } else {
                    viewModel.stageChange(settingID: settingID, target: .explicitValue(.bool(effectiveVal)))
                }
            }
        ))
    }

    private var effectiveValue: CodableValue? {
        if let staged = viewModel.stagedChanges[settingID] {
            if case .explicitValue(let v) = staged { return v }
            return nil
        }
        return appState.state(for: settingID)?.currentValue
    }
}

// MARK: - Propellerhead Setting Row (clean inline row)

struct PropellerheadSettingRow: View {
    let definition: SettingDefinition
    @Bindable var viewModel: CategoryPaneViewModel
    @Environment(AppState.self) private var appState
    @State private var showingFolderPicker = false
    @State private var isExpanded = false

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            // Expanded: control + meta
            valueControl
                .padding(.top, 4)

            // Technical info
            if let tech = definition.technicalName, let domain = definition.domain {
                LabeledContent("Domain") {
                    Text(domain)
                        .font(.caption)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.tertiary)
                        .textSelection(.enabled)
                }
                LabeledContent("Key") {
                    Text(tech)
                        .font(.caption)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.tertiary)
                        .textSelection(.enabled)
                }
            }

            Button("Reset to System Default", role: .destructive) {
                viewModel.stageChange(settingID: definition.id, target: .systemDefault)
            }
            .font(.callout)
        } label: {
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 1) {
                    Text(definition.displayName)
                    Text(definition.propellerheadDescription)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer()

                // Current value chip
                Text(currentDisplayValue)
                    .font(.callout)
                    .foregroundStyle(.secondary)

                if definition.risk != .safe {
                    RiskBadgeView(risk: definition.risk)
                }
            }
        }
    }

    @ViewBuilder
    private var valueControl: some View {
        let currentValue = effectiveValue

        switch definition.valueType {
        case .bool:
            Toggle(definition.displayName, isOn: Binding(
                get: { currentValue?.asBool ?? false },
                set: { viewModel.stageChange(settingID: definition.id, target: .explicitValue(.bool($0))) }
            ))

        case .int:
            LabeledContent(definition.displayName) {
                HStack(spacing: 8) {
                    Slider(
                        value: Binding(
                            get: { Double(currentValue?.asInt ?? 0) },
                            set: { viewModel.stageChange(settingID: definition.id, target: .explicitValue(.int(Int($0)))) }
                        ),
                        in: 0...120,
                        step: 1
                    )
                    Text("\(currentValue?.asInt ?? 0)")
                        .frame(width: 32, alignment: .trailing)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.secondary)
                }
            }

        case .double:
            LabeledContent(definition.displayName) {
                HStack(spacing: 8) {
                    Slider(
                        value: Binding(
                            get: { currentValue?.asDouble ?? 0.0 },
                            set: { viewModel.stageChange(settingID: definition.id, target: .explicitValue(.double($0))) }
                        ),
                        in: 0...1.0,
                        step: 0.01
                    )
                    Text(String(format: "%.2f", currentValue?.asDouble ?? 0.0))
                        .frame(width: 36, alignment: .trailing)
                        .fontDesign(.monospaced)
                        .foregroundStyle(.secondary)
                }
            }

        case .path:
            LabeledContent(definition.displayName) {
                HStack(spacing: 6) {
                    Text(shortPath(currentValue?.asString))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.head)
                    Button("Choose\u{2026}") {
                        showingFolderPicker = true
                    }
                    .controlSize(.small)
                }
            }
            .fileImporter(
                isPresented: $showingFolderPicker,
                allowedContentTypes: [.folder],
                allowsMultipleSelection: false
            ) { result in
                if case .success(let urls) = result, let url = urls.first {
                    viewModel.stageChange(
                        settingID: definition.id,
                        target: .explicitValue(.path(url.path(percentEncoded: false)))
                    )
                }
            }

        case .string:
            LabeledContent(definition.displayName) {
                TextField("", text: Binding(
                    get: { currentValue?.asString ?? "" },
                    set: { viewModel.stageChange(settingID: definition.id, target: .explicitValue(.string($0))) }
                ))
                .frame(width: 180)
                .textFieldStyle(.roundedBorder)
            }

        case .enum:
            if let allowed = definition.allowedValues {
                Picker(definition.displayName, selection: Binding(
                    get: { currentValue ?? .string("") },
                    set: { viewModel.stageChange(settingID: definition.id, target: .explicitValue($0)) }
                )) {
                    ForEach(allowed, id: \.self) { val in
                        Text(val.displayString).tag(val)
                    }
                }
            }
        }
    }

    private var effectiveValue: CodableValue? {
        if let staged = viewModel.stagedChanges[definition.id] {
            if case .explicitValue(let v) = staged { return v }
            return nil
        }
        return appState.state(for: definition.id)?.currentValue
    }

    private var currentDisplayValue: String {
        effectiveValue?.displayString ?? "default"
    }

    private func shortPath(_ path: String?) -> String {
        guard let path else { return "System default" }
        return path.replacingOccurrences(of: NSHomeDirectory(), with: "~")
    }
}

// MARK: - Apply Bar

private struct ApplyBar: View {
    @Bindable var viewModel: CategoryPaneViewModel

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "pencil.circle.fill")
                .foregroundStyle(.blue)
                .font(.title3)

            Text("\(viewModel.pendingCount) pending change\(viewModel.pendingCount == 1 ? "" : "s")")
                .font(.callout)

            Spacer()

            Button("Discard") {
                viewModel.discardAll()
            }
            .buttonStyle(.bordered)

            Button("Apply Changes") {
                viewModel.applyAll()
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isApplying)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.15), radius: 10, y: -3)
    }
}

// MARK: - Apply Result Banner

struct ApplyResultBanner: View {
    let message: String
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
            Text(message)
                .font(.callout)
            Spacer()
            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.borderless)
        }
    }
}

private func riskOrder(_ risk: RiskLevel) -> Int {
    switch risk {
    case .safe: return 0
    case .advanced: return 1
    case .systemSensitive: return 2
    }
}
