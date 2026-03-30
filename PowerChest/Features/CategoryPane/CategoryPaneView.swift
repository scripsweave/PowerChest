import SwiftUI
import UniformTypeIdentifiers

struct CategoryPaneView: View {
    let category: SettingCategory
    @Environment(AppState.self) private var appState
    @State private var viewModel: CategoryPaneViewModel?
    @State private var showConfetti = false

    private var sidebarItem: SidebarItem? {
        SidebarItem.allCases.first { $0.settingCategory == category }
    }

    var body: some View {
        ZStack(alignment: .top) {
            paneContent

            if showConfetti {
                ConfettiOverlay()
                    .frame(height: 150)
                    .padding(.top, 10)
                    .transition(.opacity)
            }
        }
    }

    @ViewBuilder
    private var paneContent: some View {
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
            .onChange(of: vm.applyResultMessage) { newValue in
                if newValue != nil {
                    triggerConfetti()
                }
            }
        } else {
            Color.clear.onAppear {
                appState.refreshStates(for: category)
                viewModel = CategoryPaneViewModel(category: category, appState: appState)
            }
        }
    }

    private func triggerConfetti() {
        withAnimation(.easeIn(duration: 0.2)) {
            showConfetti = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            withAnimation(.easeOut(duration: 0.3)) {
                showConfetti = false
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
        ControlCard(
            title: groupedControl.title,
            subtitle: groupedControl.subtitle,
            iconSystemName: iconName,
            accent: accentColor,
            risk: worstRisk,
            restartRequirement: restartRequirement
        ) {
            controlBody
        }
        .scaleEffect(isSpotlighted ? 1.02 : 1)
        .shadow(color: isSpotlighted ? accentColor.opacity(0.35) : .clear, radius: isSpotlighted ? 18 : 0, y: 8)
        .animation(.spring(response: 0.4, dampingFraction: 0.75), value: isSpotlighted)
        .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
        .listRowBackground(Color.clear)
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

    private var worstRisk: RiskLevel {
        let risks = groupedControl.backingSettingIDs.compactMap {
            appState.catalogService.definition(for: $0)?.risk
        }
        return risks.max(by: { riskOrder($0) < riskOrder($1) }) ?? .safe
    }

    private var restartRequirement: RestartRequirement? {
        groupedControl.backingSettingIDs.compactMap {
            appState.catalogService.definition(for: $0)?.restartRequirement
        }.first { $0.isRequired }
    }

    private var accentColor: Color {
        let palette: [Color] = [.pink, .indigo, .mint, .orange, .cyan, .purple]
        if let number = Int(groupedControl.id.filter({ $0.isNumber })) {
            return palette[number % palette.count]
        }
        return palette.randomElement() ?? .accentColor
    }

    private var iconName: String {
        switch groupedControl.kind {
        case .toggle: return "switch.2"
        case .multiToggle: return "slider.horizontal.3"
        case .multiControl: return "dial.low.fill"
        case .discreteChoice: return "rectangle.inset.filled.and.person.filled"
        default: return "wand.and.stars"
        }
    }

    private var isSpotlighted: Bool {
        guard let spotlight = appState.spotlightSettingID else { return false }
        return groupedControl.backingSettingIDs.contains(spotlight)
    }
}

// MARK: - Power User Card Shell

private struct ControlCard<Content: View>: View {
    let title: String
    let subtitle: String?
    let iconSystemName: String
    let accent: Color
    let risk: RiskLevel
    let restartRequirement: RestartRequirement?
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: iconSystemName)
                    .font(.title2)
                    .padding(10)
                    .background(accent.opacity(0.15), in: RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.semibold)
                    if let subtitle {
                        Text(subtitle)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 6) {
                    if risk != .safe {
                        RiskBadgeView(risk: risk)
                    }
                    if let restartRequirement, restartRequirement.isRequired {
                        RestartBadgeView(requirement: restartRequirement)
                    }
                }
            }

            Divider()

            content

        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(nsColor: .textBackgroundColor))
                .shadow(color: .black.opacity(0.08), radius: 10, y: 6)
                .overlay(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(accent.opacity(0.25), lineWidth: 1)
                }
        )
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
        let isSpotlight = appState.spotlightSettingID == definition.id

        let row = Group {
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
        .padding(.horizontal, isSpotlight ? 6 : 0)
        .padding(.vertical, isSpotlight ? 4 : 0)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.accentColor.opacity(isSpotlight ? 0.08 : 0))
        )
        .animation(.easeInOut(duration: 0.3), value: isSpotlight)

        return row
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
        let isSpotlight = appState.spotlightSettingID == definition.id

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
        .padding(.horizontal, isSpotlight ? 6 : 0)
        .padding(.vertical, isSpotlight ? 4 : 0)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.accentColor.opacity(isSpotlight ? 0.07 : 0))
        )
        .shadow(color: isSpotlight ? Color.accentColor.opacity(0.2) : .clear, radius: isSpotlight ? 14 : 0, y: isSpotlight ? 4 : 0)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isSpotlight)
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
        HStack(spacing: 14) {
            AvatarStack(settingIDs: Array(viewModel.stagedChanges.keys.prefix(4)))

            VStack(alignment: .leading, spacing: 2) {
                Text("\(viewModel.pendingCount) pending change\(viewModel.pendingCount == 1 ? "" : "s")")
                    .font(.headline)
                Text("We auto-snapshot and log everything for you.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(role: .destructive) {
                viewModel.discardAll()
            } label: {
                Label("Discard", systemImage: "trash")
            }
            .buttonStyle(.bordered)

            Button {
                viewModel.applyAll()
            } label: {
                Label(viewModel.isApplying ? "Applying…" : "Apply", systemImage: "checkmark.seal")
                    .fontWeight(.semibold)
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isApplying)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(
            Capsule()
                .fill(LinearGradient(colors: [.blue.opacity(0.85), .purple.opacity(0.85)], startPoint: .leading, endPoint: .trailing))
        )
        .foregroundStyle(.white)
        .shadow(color: .black.opacity(0.2), radius: 12, y: 4)
    }

    private struct AvatarStack: View {
        let settingIDs: [String]

        var body: some View {
            HStack(spacing: -8) {
                ForEach(Array(settingIDs.enumerated()), id: \.element) { index, id in
                    Text(shortLabel(for: id))
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(8)
                        .background(circleColors[index % circleColors.count], in: Circle())
                        .overlay(Circle().stroke(Color.white.opacity(0.6), lineWidth: 1))
                }
            }
        }

        private var circleColors: [Color] { [.yellow, .orange, .pink, .mint, .teal] }

        private func shortLabel(for id: String) -> String {
            let parts = id.split(separator: ".")
            if let last = parts.last {
                return last.prefix(2).uppercased()
            }
            return id.prefix(2).uppercased()
        }
    }
}

// MARK: - Apply Result Banner

struct ApplyResultBanner: View {
    let message: String
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.title3)
                .foregroundStyle(.white)
            VStack(alignment: .leading, spacing: 2) {
                Text("Success")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
                Text(message)
                    .font(.headline)
                    .foregroundStyle(.white)
            }
            Spacer()
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.caption)
                    .padding(6)
                    .background(.white.opacity(0.2), in: Circle())
            }
            .buttonStyle(.borderless)
            .foregroundStyle(.white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(LinearGradient(colors: [.green, .mint], startPoint: .leading, endPoint: .trailing))
        )
        .shadow(color: .black.opacity(0.2), radius: 10, y: 4)
    }
}

private func riskOrder(_ risk: RiskLevel) -> Int {
    switch risk {
    case .safe: return 0
    case .advanced: return 1
    case .systemSensitive: return 2
    }
}
