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
            .onChange(of: vm.applyResultMessage) {
                if vm.applyResultMessage != nil {
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
    @State private var visibleCards: Set<String> = []

    var body: some View {
        let groupedControls = appState.catalogService.groupedControls(for: viewModel.category)

        if groupedControls.isEmpty {
            Section {
                ContentUnavailableView(
                    "Still under construction",
                    systemImage: "wrench.and.screwdriver",
                    description: Text("Power User controls for this category are on the way. Check back soon.")
                )
            }
        } else {
            ForEach(Array(groupedControls.enumerated()), id: \.element.id) { index, gc in
                InteractiveGroupedControl(groupedControl: gc, viewModel: viewModel)
                    .opacity(visibleCards.contains(gc.id) ? 1 : 0)
                    .offset(y: visibleCards.contains(gc.id) ? 0 : 12)
                    .animation(.spring(response: 0.35, dampingFraction: 0.8).delay(Double(index) * 0.05), value: visibleCards.contains(gc.id))
                    .onAppear {
                        visibleCards.insert(gc.id)
                    }
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
                    "Nothing here yet",
                    systemImage: "gearshape",
                    description: Text("This category is empty for now. More settings are always being added.")
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
            restartRequirement: restartRequirement,
            requiresAdmin: hasAdminSettings
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
        def.isInvertedInPowerUserMode
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

    private var hasAdminSettings: Bool {
        groupedControl.backingSettingIDs.contains {
            appState.catalogService.definition(for: $0)?.requiresAdmin == true
        }
    }

    private var accentColor: Color {
        let palette: [Color] = [.pink, .indigo, .mint, .orange, .cyan, .purple]
        if let number = Int(groupedControl.id.filter({ $0.isNumber })) {
            return palette[number % palette.count]
        }
        return palette.randomElement() ?? .accentColor
    }

    private var iconName: String {
        switch groupedControl.id {
        // ── Finder ──
        case "G001": return "eye.fill"                         // Show hidden files
        case "G002": return "doc.text"                         // Always show file extensions
        case "G003": return "character.cursor.ibeam"           // Show full path in title
        case "G004": return "rectangle.bottomhalf.inset.filled" // Show more Finder details
        case "G019": return "folder.badge.gearshape"           // Show ~/Library
        case "G020": return "internaldrive.fill"               // Save to this Mac
        case "G021": return "pencil"                           // Skip extension warning
        case "G024": return "trash.slash"                      // Stop .DS_Store clutter
        case "G026": return "cursorarrow.rays"                 // Spring-loading speed
        case "G027": return "power"                            // Allow quitting Finder
        case "G028": return "trash.fill"                       // Skip empty Trash warning
        case "G029": return "macwindow.badge.plus"             // New Finder window target
        case "G054": return "rectangle.split.3x1"              // Column auto-sizing
        case "G055": return "desktopcomputer"                  // Hide desktop icons (Finder)
        case "G072": return "trash.fill"                       // Auto-empty Trash
        case "G073": return "externaldrive.fill"               // Desktop drive icons

        // ── Dock & Interface ──
        case "G005": return "hare.fill"                        // Make Dock feel faster
        case "G006": return "arrow.down.to.line"               // Minimize into app icon
        case "G007": return "circle.dotted"                    // Show only open apps
        case "G008": return "rectangle.expand.vertical"        // Expanded Save/Print dialogs
        case "G022": return "clock.arrow.circlepath"           // Show recent apps in Dock
        case "G023": return "scroll.fill"                      // Scroll bar visibility
        case "G025": return "doc.plaintext"                    // TextEdit plain text
        case "G030": return "slider.horizontal.below.rectangle" // Dock icon size
        case "G031": return "dock.rectangle"                   // Dock position
        case "G032": return "arrow.down.right.and.arrow.up.left" // Minimize animation
        case "G033": return "cursorarrow.click.2"              // Title bar double-click
        case "G041": return "questionmark.circle.fill"         // Help viewer non-floating
        case "G053": return "moon.fill"                        // Disable App Nap
        case "G065": return "rectangle.inset.topleft.filled"   // Hot corners
        case "G066": return "plus.magnifyingglass"             // Dock extras (magnification etc.)
        case "G067": return "display.2"                        // Dock multi-monitor & scroll
        case "G070": return "macwindow"                        // Window behavior
        case "G075": return "gauge.with.needle.fill"           // Activity Monitor
        case "G076": return "macwindow.on.rectangle"           // Window persistence

        // ── Keyboard & Input ──
        case "G009": return "repeat"                           // Key repeat speed
        case "G010": return "character.textbox"                // Key repeat vs accent popup
        case "G011": return "textformat.abc.dottedunderline"   // Typing helpers
        case "G034": return "rectangle.and.hand.point.up.left.fill" // Full keyboard access
        case "G051": return "cursorarrow.motionlines"          // Mouse acceleration
        case "G057": return "rectangle.and.pencil.and.ellipsis" // Autofill heuristic
        case "G060": return "hand.tap.fill"                    // Trackpad gestures
        case "G061": return "hand.point.up.fill"               // Trackpad click & tracking
        case "G077": return "fn"                               // Fn/Globe key

        // ── Windows & Spaces ──
        case "G012": return "square.grid.3x3.square"           // Spaces behavior
        case "G013": return "hare.fill"                        // Mission Control speed
        case "G035": return "rectangle.3.group"                // Group windows by app
        case "G056": return "hare.fill"                        // Stage Manager speed
        case "G062": return "mosaic.fill"                      // Stage Manager
        case "G063": return "rectangle.split.2x1.fill"         // Window tiling
        case "G064": return "eye.slash"                        // Hide desktop icons (standard)

        // ── Screenshots ──
        case "G014": return "camera.viewfinder"                // Tidy up screenshots
        case "G015": return "wrench.and.screwdriver.fill"      // Safari dev basics
        case "G037": return "arrow.down.circle.fill"           // Stop auto-opening downloads
        case "G038": return "link"                             // Show link URLs

        // ── Developer ──
        case "G078": return "terminal.fill"                    // Developer tools

        // ── Accessibility & Visual ──
        case "G016": return "circle.lefthalf.filled"           // Increase contrast
        case "G052": return "figure.walk"                      // Reduce motion
        case "G058": return "cube.transparent"                 // Disable Liquid Glass
        case "G059": return "filemenu.and.selection"           // Hide menu dropdown icons

        // ── Menu Bar ──
        case "G017": return "sparkle"                          // Clock flash separators
        case "G039": return "clock.fill"                       // 24-hour clock
        case "G042": return "calendar"                         // Date in menu bar
        case "G068": return "clock.badge"                      // Clock display extras
        case "G069": return "switch.2"                         // Control Center items
        case "G071": return "menubar.arrow.up.rectangle"       // Menu bar density

        // ── Security & Privacy ──
        case "G018": return "shield.fill"                      // Skip quarantine
        case "G040": return "exclamationmark.triangle.fill"    // Crash reporter
        case "G074": return "lock.fill"                        // Screen lock

        // ── Network & Connectivity ──
        case "G044": return "wifi.slash"                       // AirDrop
        case "G045": return "hand.raised.fill"                 // Safari Network Privacy
        case "G047": return "wifi"                             // Captive Portal
        case "G048": return "flame.fill"                       // Firewall
        case "G049": return "terminal.fill"                    // Remote Access & Protocols
        case "G050": return "network"                          // MAC Address Spoofing

        // ── Windows (new) ──
        case "G079": return "macwindow"                        // Window tabbing & drag

        default: return "gearshape.fill"
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
    var requiresAdmin: Bool = false
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
                    if requiresAdmin {
                        AdminBadgeView()
                    }
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
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.06), radius: 12, y: 6)
                .overlay(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(accent.opacity(0.2), lineWidth: 0.5)
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
            Toggle(isOn: Binding(
                get: { currentValue?.asBool ?? false },
                set: { viewModel.stageChange(settingID: definition.id, target: .explicitValue(.bool($0))) }
            )) {
                Label(definition.powerUserLabel ?? definition.displayName,
                      systemImage: settingIcon(for: definition))
            }

        case .int:
            if let labels = intValueLabels(for: definition) {
                // Discrete labeled picker for enum-like ints
                Picker(definition.powerUserLabel ?? definition.displayName, selection: Binding(
                    get: { currentValue?.asInt ?? 0 },
                    set: { viewModel.stageChange(settingID: definition.id, target: .explicitValue(.int($0))) }
                )) {
                    ForEach(labels, id: \.value) { item in
                        Text(item.label).tag(item.value)
                    }
                }
            } else if let range = intSliderRange(for: definition) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(definition.powerUserLabel ?? definition.displayName)
                    HStack(spacing: 8) {
                        Text("\(range.lowerBound)")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                        Slider(
                            value: Binding(
                                get: { Double(currentValue?.asInt ?? range.lowerBound) },
                                set: { viewModel.stageChange(settingID: definition.id, target: .explicitValue(.int(Int($0)))) }
                            ),
                            in: Double(range.lowerBound)...Double(range.upperBound),
                            step: 1
                        )
                        Text("\(range.upperBound)")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                        Text("\(currentValue?.asInt ?? range.lowerBound)")
                            .font(.caption)
                            .fontDesign(.monospaced)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(.tint.opacity(0.1), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                    }
                }
            } else {
                LabeledContent(definition.powerUserLabel ?? definition.displayName) {
                    TextField("", value: Binding(
                        get: { currentValue?.asInt ?? 0 },
                        set: { viewModel.stageChange(settingID: definition.id, target: .explicitValue(.int($0))) }
                    ), format: .number)
                    .frame(width: 60)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.trailing)
                }
            }

        case .double:
            if let range = doubleSliderRange(for: definition) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(definition.powerUserLabel ?? definition.displayName)
                    HStack(spacing: 8) {
                        Slider(
                            value: Binding(
                                get: { currentValue?.asDouble ?? range.lowerBound },
                                set: { viewModel.stageChange(settingID: definition.id, target: .explicitValue(.double($0))) }
                            ),
                            in: range,
                            step: (range.upperBound - range.lowerBound) > 10 ? 0.1 : 0.01
                        )
                        Text(String(format: "%.2f", currentValue?.asDouble ?? range.lowerBound))
                            .font(.caption)
                            .fontDesign(.monospaced)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(.tint.opacity(0.1), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                    }
                }
            } else {
                LabeledContent(definition.powerUserLabel ?? definition.displayName) {
                    TextField("", value: Binding(
                        get: { currentValue?.asDouble ?? 0.0 },
                        set: { viewModel.stageChange(settingID: definition.id, target: .explicitValue(.double($0))) }
                    ), format: .number.precision(.fractionLength(2)))
                    .frame(width: 60)
                    .textFieldStyle(.roundedBorder)
                    .multilineTextAlignment(.trailing)
                }
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
            if definition.id.contains("macAddress") {
                MACAddressRow(definition: definition, viewModel: viewModel, currentValue: currentValue)
            } else {
                LabeledContent(definition.powerUserLabel ?? definition.displayName) {
                    TextField("", text: Binding(
                        get: { currentValue?.asString ?? "" },
                        set: { viewModel.stageChange(settingID: definition.id, target: .explicitValue(.string($0))) }
                    ))
                    .frame(width: 140)
                    .textFieldStyle(.roundedBorder)
                }
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

    private func intSliderRange(for def: SettingDefinition) -> ClosedRange<Int>? {
        guard let allowed = def.allowedValues else { return nil }
        let ints = allowed.compactMap(\.asInt)
        guard let lo = ints.min(), let hi = ints.max(), lo < hi else { return nil }
        return lo...hi
    }

    private func doubleSliderRange(for def: SettingDefinition) -> ClosedRange<Double>? {
        guard let allowed = def.allowedValues else { return nil }
        let doubles = allowed.compactMap(\.asDouble)
        guard let lo = doubles.min(), let hi = doubles.max(), lo < hi else { return nil }
        return lo...hi
    }

    private func shortPath(_ path: String?) -> String {
        guard let path else { return "System default" }
        return path
            .replacingOccurrences(of: NSHomeDirectory(), with: "~")
    }
}

// MARK: - MAC Address Row

private struct MACAddressRow: View {
    let definition: SettingDefinition
    @Bindable var viewModel: CategoryPaneViewModel
    let currentValue: CodableValue?
    @Environment(AppState.self) private var appState

    @State private var interfaces: [InterfaceState] = []

    struct InterfaceState: Identifiable {
        let id: String       // e.g. "en0"
        let name: String     // e.g. "Wi-Fi"
        var currentMAC: String
        var editText: String = ""
        var statusMessage: String?
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if interfaces.isEmpty {
                Text("No network interfaces detected")
                    .foregroundStyle(.secondary)
            } else {
                ForEach($interfaces) { $iface in
                    InterfaceRow(iface: $iface, adapter: appState.readService.privilegedAdapter)
                    if iface.id != interfaces.last?.id {
                        Divider()
                    }
                }
            }

            Text("Changes revert on reboot.")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .onAppear {
            let detected = appState.readService.privilegedAdapter.listInterfaces()
            interfaces = detected.map { iface in
                InterfaceState(id: iface.id, name: iface.name, currentMAC: iface.mac)
            }
        }
    }
}

private struct InterfaceRow: View {
    @Binding var iface: MACAddressRow.InterfaceState
    let adapter: PrivilegedAdapter

    private var isValid: Bool {
        iface.editText.isEmpty || validateMAC(iface.editText)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Label(iface.name, systemImage: iface.name.contains("Wi-Fi") ? "wifi" : "cable.connector.horizontal")
                    .font(.callout)
                    .fontWeight(.medium)
                Text(iface.id)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .fontDesign(.monospaced)
            }

            HStack(spacing: 8) {
                TextField("", text: $iface.editText)
                    .frame(minWidth: 180, idealWidth: 200)
                    .textFieldStyle(.roundedBorder)
                    .fontDesign(.monospaced)
                    .font(.callout)
                    .foregroundColor(isValid ? .primary : .red)
                    .onAppear {
                        if iface.editText.isEmpty {
                            iface.editText = iface.currentMAC
                        }
                    }
                    .onChange(of: iface.editText) {
                        let filtered = iface.editText.filter { $0.isHexDigit || $0 == ":" }
                        if filtered != iface.editText {
                            iface.editText = filtered
                        }
                    }

                Button {
                    iface.editText = PrivilegedAdapter.generateRandomMAC()
                } label: {
                    Label("Random", systemImage: "dice")
                }
                .controlSize(.small)
                .buttonStyle(.bordered)

                Button {
                    applyMAC()
                } label: {
                    Label("Apply", systemImage: "checkmark.circle")
                }
                .controlSize(.small)
                .buttonStyle(.borderedProminent)
                .disabled(!isValid || iface.editText.isEmpty)
            }

            if !isValid {
                Text("Enter a valid MAC: XX:XX:XX:XX:XX:XX (hex only)")
                    .font(.caption2)
                    .foregroundStyle(.red)
            }

            if let msg = iface.statusMessage {
                Text(msg)
                    .font(.caption)
                    .foregroundStyle(msg.hasPrefix("Changed") ? .green : .red)
            }
        }
    }

    private func applyMAC() {
        let mac = iface.editText.lowercased()
        do {
            try adapter.spoofMAC(interface: iface.id, mac: mac)
            if let updated = adapter.readMAC(interface: iface.id) {
                iface.currentMAC = updated
            }
            iface.statusMessage = "Changed to \(mac)"
            iface.editText = ""
        } catch {
            let msg = error.localizedDescription
            if msg.contains("SIOCAIFADDR") || msg.contains("Can't assign") {
                iface.statusMessage = "This interface doesn't support MAC spoofing"
            } else {
                iface.statusMessage = "Failed: \(msg)"
            }
        }
    }

    private func validateMAC(_ mac: String) -> Bool {
        let pattern = /^([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}$/
        return mac.wholeMatch(of: pattern) != nil
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
        Toggle(isOn: Binding(
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
        )) {
            Label(definition.powerUserLabel ?? definition.displayName,
                  systemImage: settingIcon(for: definition))
        }
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
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.quaternary, in: RoundedRectangle(cornerRadius: 4, style: .continuous))
                }
                LabeledContent("Key") {
                    Text(tech)
                        .font(.caption)
                        .fontDesign(.monospaced)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.quaternary, in: RoundedRectangle(cornerRadius: 4, style: .continuous))
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
                    .font(.caption)
                    .fontDesign(.monospaced)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 6, style: .continuous))

                if definition.requiresAdmin {
                    AdminBadgeView()
                }
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
            if let labels = intValueLabels(for: definition) {
                Picker(definition.displayName, selection: Binding(
                    get: { currentValue?.asInt ?? 0 },
                    set: { viewModel.stageChange(settingID: definition.id, target: .explicitValue(.int($0))) }
                )) {
                    ForEach(labels, id: \.value) { item in
                        Text(item.label).tag(item.value)
                    }
                }
            } else {
            let intRange = intSliderRange(for: definition)
            LabeledContent(definition.displayName) {
                HStack(spacing: 8) {
                    Slider(
                        value: Binding(
                            get: { Double(currentValue?.asInt ?? intRange.lowerBound) },
                            set: { viewModel.stageChange(settingID: definition.id, target: .explicitValue(.int(Int($0)))) }
                        ),
                        in: Double(intRange.lowerBound)...Double(intRange.upperBound),
                        step: 1
                    )
                    Text("\(currentValue?.asInt ?? intRange.lowerBound)")
                        .font(.caption)
                        .fontDesign(.monospaced)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(.tint.opacity(0.1), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                }
            }
            }

        case .double:
            let dblRange = doubleSliderRange(for: definition)
            LabeledContent(definition.displayName) {
                HStack(spacing: 8) {
                    Slider(
                        value: Binding(
                            get: { currentValue?.asDouble ?? dblRange.lowerBound },
                            set: { viewModel.stageChange(settingID: definition.id, target: .explicitValue(.double($0))) }
                        ),
                        in: dblRange,
                        step: (dblRange.upperBound - dblRange.lowerBound) > 10 ? 0.1 : 0.01
                    )
                    Text(String(format: "%.2f", currentValue?.asDouble ?? dblRange.lowerBound))
                        .font(.caption)
                        .fontDesign(.monospaced)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(.tint.opacity(0.1), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
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

    private func intSliderRange(for def: SettingDefinition) -> ClosedRange<Int> {
        if let allowed = def.allowedValues {
            let ints = allowed.compactMap(\.asInt)
            if let lo = ints.min(), let hi = ints.max(), lo < hi {
                return lo...hi
            }
        }
        return 0...128
    }

    private func doubleSliderRange(for def: SettingDefinition) -> ClosedRange<Double> {
        if let allowed = def.allowedValues {
            let doubles = allowed.compactMap(\.asDouble)
            if let lo = doubles.min(), let hi = doubles.max(), lo < hi {
                return lo...hi
            }
        }
        return 0...5.0
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
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .fill(LinearGradient(colors: [.blue.opacity(0.25), .purple.opacity(0.25)], startPoint: .leading, endPoint: .trailing))
                )
                .overlay(
                    Capsule()
                        .strokeBorder(.white.opacity(0.2), lineWidth: 0.5)
                )
        )
        .shadow(color: .black.opacity(0.15), radius: 16, y: 6)
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
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(LinearGradient(colors: [.green.opacity(0.3), .mint.opacity(0.3)], startPoint: .leading, endPoint: .trailing))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(.white.opacity(0.2), lineWidth: 0.5)
                )
        )
        .shadow(color: .black.opacity(0.12), radius: 12, y: 4)
    }
}

// MARK: - Int Value Label Mapping

struct IntValueLabel {
    let value: Int
    let label: String
}

private let hotCornerLabels: [IntValueLabel] = [
    IntValueLabel(value: 0, label: "Off"),
    IntValueLabel(value: 2, label: "Mission Control"),
    IntValueLabel(value: 3, label: "Application Windows"),
    IntValueLabel(value: 4, label: "Desktop"),
    IntValueLabel(value: 5, label: "Start Screen Saver"),
    IntValueLabel(value: 6, label: "Disable Screen Saver"),
    IntValueLabel(value: 10, label: "Put Display to Sleep"),
    IntValueLabel(value: 11, label: "Launchpad"),
    IntValueLabel(value: 12, label: "Notification Center"),
    IntValueLabel(value: 13, label: "Lock Screen"),
    IntValueLabel(value: 14, label: "Quick Note"),
]

// swiftlint:disable cyclomatic_complexity
func intValueLabels(for def: SettingDefinition) -> [IntValueLabel]? {
    switch def.id {
    case "dock.hotCornerTopLeft",
         "dock.hotCornerTopRight",
         "dock.hotCornerBottomLeft",
         "dock.hotCornerBottomRight":
        return hotCornerLabels

    case "keyboard.fnKeyAction":
        return [
            IntValueLabel(value: 0, label: "Do Nothing"),
            IntValueLabel(value: 1, label: "Change Input Source"),
            IntValueLabel(value: 2, label: "Show Emoji & Symbols"),
            IntValueLabel(value: 3, label: "Start Dictation"),
        ]

    case "trackpad.clickPressure", "trackpad.forceClickPressure":
        return [
            IntValueLabel(value: 0, label: "Light"),
            IntValueLabel(value: 1, label: "Medium"),
            IntValueLabel(value: 2, label: "Firm"),
        ]

    case "global.sidebarIconSize":
        return [
            IntValueLabel(value: 1, label: "Small"),
            IntValueLabel(value: 2, label: "Medium"),
            IntValueLabel(value: 3, label: "Large"),
        ]

    case "activityMonitor.iconType":
        return [
            IntValueLabel(value: 0, label: "App Icon"),
            IntValueLabel(value: 2, label: "Network Usage"),
            IntValueLabel(value: 3, label: "Disk Activity"),
            IntValueLabel(value: 5, label: "CPU Usage"),
            IntValueLabel(value: 6, label: "CPU History"),
        ]

    case "activityMonitor.showCategory":
        return [
            IntValueLabel(value: 100, label: "All Processes"),
            IntValueLabel(value: 101, label: "All Processes (Hierarchical)"),
            IntValueLabel(value: 102, label: "My Processes"),
        ]

    case "activityMonitor.updatePeriod":
        return [
            IntValueLabel(value: 1, label: "Very Often (1s)"),
            IntValueLabel(value: 2, label: "Often (2s)"),
            IntValueLabel(value: 5, label: "Normal (5s)"),
        ]

    case "menu.clockShowDate":
        return [
            IntValueLabel(value: 0, label: "When Space Allows"),
            IntValueLabel(value: 1, label: "Always"),
            IntValueLabel(value: 2, label: "Never"),
        ]

    default:
        return nil
    }
}
// swiftlint:enable cyclomatic_complexity

// swiftlint:disable cyclomatic_complexity function_body_length
private func settingIcon(for def: SettingDefinition) -> String {
    switch def.id {
    // ── Finder ──
    case "finder.showHiddenFiles":              return "eye.fill"
    case "global.showAllExtensions":            return "doc.text"
    case "finder.showPathBar":                  return "rectangle.bottomhalf.inset.filled"
    case "finder.showStatusBar":                return "rectangle.bottomthird.inset.filled"
    case "finder.keepFoldersOnTopInWindow":     return "folder.fill"
    case "finder.keepFoldersOnTopOnDesktop":    return "folder.fill"
    case "finder.newWindowTarget":              return "macwindow.badge.plus"
    case "finder.showPosixPathInTitle":         return "character.cursor.ibeam"
    case "finder.showLibraryFolder":            return "folder.badge.gearshape"
    case "finder.warnOnEmptyTrash":             return "trash.slash"
    case "finder.disableExtensionChangeWarning": return "pencil"
    case "global.saveToLocalDisk":              return "internaldrive.fill"
    case "finder.quitMenuItem":                 return "power"
    case "desktopservices.dontWriteNetworkDS":  return "network"
    case "desktopservices.dontWriteUSBDS":      return "externaldrive.fill"
    case "finder.springLoadingDelay":           return "cursorarrow.rays"
    case "finder.defaultSearchScope":           return "magnifyingglass"
    case "finder.preferredViewStyle":           return "rectangle.grid.1x2.fill"
    case "finder.columnAutoSizing":             return "rectangle.split.3x1"
    case "finder.createDesktop":                return "desktopcomputer"
    case "finder.autoRemoveOldTrash":           return "trash.fill"
    case "finder.showExternalDrives":           return "externaldrive.fill"
    case "finder.showInternalDrives":           return "internaldrive.fill"
    case "finder.showServers":                  return "server.rack"
    case "finder.showRemovableMedia":           return "sdcard.fill"
    case "finder.openFoldersInTabs":            return "rectangle.split.3x1.fill"
    case "global.toolbarTitleRolloverDelay":    return "cursorarrow.click"

    // ── Dock & Interface ──
    case "dock.tileSize":                       return "slider.horizontal.below.rectangle"
    case "dock.orientation":                    return "dock.rectangle"
    case "dock.autohideDelay":                  return "clock.fill"
    case "dock.autohideAnimationSpeed":         return "hare.fill"
    case "dock.showRecents":                    return "clock.arrow.circlepath"
    case "dock.mineffect":                      return "arrow.down.right.and.arrow.up.left"
    case "dock.minimizeToApplication":          return "arrow.down.to.line"
    case "global.showScrollBars":               return "scroll.fill"
    case "global.titleBarDoubleClick":          return "cursorarrow.click.2"
    case "global.savePanelExpanded":            return "rectangle.expand.vertical"
    case "global.printPanelExpanded":           return "printer.fill"
    case "dock.staticOnly":                     return "circle.dotted"
    case "dock.magnification":                  return "plus.magnifyingglass"
    case "dock.largeSize":                      return "arrow.up.left.and.arrow.down.right"
    case "dock.launchAnimation":                return "arrow.up.and.down.and.sparkles"
    case "dock.showProcessIndicators":          return "smallcircle.filled.circle.fill"
    case "dock.showHidden":                     return "eye.slash"
    case "dock.springLoadAll":                  return "cursorarrow.rays"
    case "dock.appSwitcherAllDisplays":         return "display.2"
    case "dock.scrollToOpen":                   return "scroll"
    case "dock.hotCornerTopLeft":               return "rectangle.inset.topleft.filled"
    case "dock.hotCornerTopRight":              return "rectangle.inset.topright.filled"
    case "dock.hotCornerBottomLeft":            return "rectangle.inset.bottomleft.filled"
    case "dock.hotCornerBottomRight":           return "rectangle.inset.bottomright.filled"
    case "global.windowTabbingMode":            return "rectangle.split.3x1"
    case "global.dragWindowFromAnywhere":       return "arrow.up.and.down.and.arrow.left.and.right"
    case "global.sidebarIconSize":              return "sidebar.left"
    case "global.scrollbarClickBehavior":       return "scroll"
    case "global.preventAutoTermination":       return "bolt.slash.fill"
    case "global.keepWindowsOnQuit":            return "macwindow.on.rectangle"
    case "global.closeConfirmsChanges":         return "doc.badge.ellipsis"
    case "global.windowAnimationsEnabled":      return "sparkles"
    case "global.appNap":                       return "moon.fill"

    // ── TextEdit / HelpViewer / Activity Monitor ──
    case "textEdit.plainTextDefault":           return "doc.plaintext"
    case "helpViewer.devMode":                  return "questionmark.circle.fill"
    case "activityMonitor.iconType":            return "gauge.with.needle.fill"
    case "activityMonitor.showCategory":        return "list.bullet.below.rectangle"
    case "activityMonitor.updatePeriod":        return "clock.fill"
    case "music.songNotifications":             return "music.note"
    case "timeMachine.dontOfferNewDisks":       return "externaldrive.fill.badge.timemachine"

    // ── Keyboard & Input ──
    case "global.pressAndHoldEnabled":          return "character.textbox"
    case "global.keyRepeat":                    return "repeat"
    case "global.initialKeyRepeat":             return "clock.fill"
    case "global.smartQuotes":                  return "textformat.abc"
    case "global.smartDashes":                  return "minus"
    case "global.autoCapitalization":           return "textformat.size.larger"
    case "global.autoSpellingCorrection":       return "textformat.abc.dottedunderline"
    case "global.periodSubstitution":           return "ellipsis"
    case "global.fullKeyboardAccess":           return "rectangle.and.hand.point.up.left.fill"
    case "mouse.acceleration":                  return "cursorarrow.motionlines"
    case "global.autoFillHeuristic":            return "rectangle.and.pencil.and.ellipsis"
    case "global.inlinePrediction":             return "text.cursor"
    case "keyboard.fnKeyAction":                return "fn"
    case "keyboard.fnKeysStandard":             return "fn"
    case "keyboard.languageIndicator":          return "globe"

    // ── Trackpad ──
    case "trackpad.tapToClick":                 return "hand.tap.fill"
    case "trackpad.threeFingerDrag":            return "hand.draw.fill"
    case "trackpad.forceClick":                 return "hand.point.up.fill"
    case "trackpad.silentClicking":             return "speaker.slash.fill"
    case "trackpad.clickPressure":              return "hand.point.up.fill"
    case "trackpad.forceClickPressure":         return "hand.point.up.fill"
    case "trackpad.trackingSpeed":              return "cursorarrow.motionlines"

    // ── Windows & Spaces ──
    case "dock.mruSpaces":                      return "square.grid.3x3.square"
    case "dock.exposeGroupApps":                return "rectangle.3.group"
    case "dock.exposeAnimationDuration":        return "hare.fill"
    case "spaces.spansDisplays":                return "display.2"
    case "windowManager.animationSpeed":        return "hare.fill"
    case "windowManager.stageManager":          return "mosaic.fill"
    case "windowManager.autoHideStrip":         return "sidebar.left"
    case "windowManager.clickToShowDesktop":    return "cursorarrow.click"
    case "windowManager.tilingByEdgeDrag":      return "rectangle.split.2x1.fill"
    case "windowManager.tilingOptionKey":       return "option"
    case "windowManager.topEdgeTiling":         return "rectangle.topthird.inset.filled"
    case "windowManager.tiledWindowMargins":    return "square.resize"
    case "windowManager.hideDesktopItems":      return "eye.slash"
    case "windowManager.hideDesktopIcons":      return "eye.slash"
    case "global.switchSpaceOnActivate":        return "arrow.left.arrow.right"

    // ── Screenshots ──
    case "screencapture.location":              return "folder.fill"
    case "screencapture.format":                return "photo"
    case "screencapture.disableShadow":         return "shadow"
    case "screencapture.showThumbnail":         return "photo.on.rectangle"
    case "screencapture.name":                  return "character.cursor.ibeam"
    case "screencapture.includeDate":           return "calendar"
    case "screencapture.rememberSelection":     return "rectangle.dashed"

    // ── Safari & Developer ──
    case "safari.showFullURL":                  return "link"
    case "safari.includeDevelopMenu":           return "wrench.and.screwdriver.fill"
    case "safari.autoOpenSafeDownloads":        return "arrow.down.circle.fill"
    case "safari.showStatusBar":                return "rectangle.bottomthird.inset.filled"
    case "safari.webKitDeveloperExtras":        return "hammer.fill"
    case "safari.dnsPrefetching":               return "network"
    case "safari.preloadTopHit":                return "bolt.fill"
    case "safari.doNotTrack":                   return "hand.raised.fill"
    case "xcode.showBuildDuration":             return "clock.badge"
    case "terminal.focusFollowsMouse":          return "cursorarrow.rays"

    // ── Accessibility & Visual ──
    case "accessibility.reduceTransparency":    return "rectangle.fill"
    case "accessibility.increaseContrast":      return "circle.lefthalf.filled"
    case "accessibility.reduceMotion":          return "figure.walk"
    case "accessibility.mouseDriverCursorSize": return "cursorarrow"
    case "display.fontSmoothing":               return "textformat.size"
    case "global.disableSolarium":              return "cube.transparent"
    case "global.menuActionImages":             return "filemenu.and.selection"

    // ── Menu Bar ──
    case "menu.clock24Hour":                    return "clock.fill"
    case "menu.batteryShowPercent":             return "battery.75percent"
    case "menu.clockFlashDateSeparators":       return "sparkle"
    case "menu.clockShowDate":                  return "calendar"
    case "menu.clockShowAMPM":                  return "clock.fill"
    case "menu.clockShowSeconds":               return "clock.badge"
    case "menu.clockShowDayOfWeek":             return "calendar.day.timeline.left"
    case "menu.clockAnalog":                    return "clock"
    case "menu.autoHideMenuBar":                return "menubar.arrow.up.rectangle"
    case "menu.statusItemSpacing":              return "arrow.left.and.right"
    case "menu.statusItemPadding":              return "arrow.left.and.right"
    case "menu.ccBluetooth":                    return "wave.3.right"
    case "menu.ccSound":                        return "speaker.wave.2.fill"
    case "menu.ccNowPlaying":                   return "music.note"
    case "menu.ccFocusModes":                   return "moon.fill"
    case "menu.ccDisplay":                      return "sun.max.fill"

    // ── Security & Privacy ──
    case "launchServices.quarantine":           return "shield.fill"
    case "crashReporter.dialogType":            return "exclamationmark.triangle.fill"
    case "screensaver.askForPassword":          return "lock.fill"
    case "screensaver.askForPasswordDelay":     return "clock.fill"
    case "loginwindow.text":                    return "text.bubble.fill"
    case "appleIntelligence.enabled":           return "brain.head.profile"

    // ── Network & Connectivity ──
    case "network.firewallEnabled":             return "flame.fill"
    case "network.firewallStealth":             return "eye.slash"
    case "network.firewallBlockAll":            return "nosign"
    case "network.captivePortal":               return "wifi"
    case "network.disableAirDrop":              return "wifi.slash"
    case "bluetooth.audioQuality":              return "wave.3.right"
    case "network.remoteLogin":                 return "terminal.fill"
    case "network.ipv6Wi-Fi":                   return "wifi"
    case "network.macAddressEthernet":          return "network"

    default:
        // Category-based fallback
        switch def.category {
        case .finder:               return "folder.fill"
        case .interface:            return "macwindow"
        case .keyboardInput:        return "keyboard.fill"
        case .windowsSpaces:        return "rectangle.on.rectangle"
        case .screenshots:          return "camera.viewfinder"
        case .safariDeveloper:      return "globe"
        case .menuBarStatus:        return "menubar.rectangle"
        case .accessibilityVisual:  return "eye.fill"
        case .securityPrivacy:      return "lock.fill"
        case .networkConnectivity:  return "network"
        case .internals:            return "gearshape.2.fill"
        }
    }
}
// swiftlint:enable cyclomatic_complexity function_body_length

private func riskOrder(_ risk: RiskLevel) -> Int {
    switch risk {
    case .safe: return 0
    case .advanced: return 1
    case .systemSensitive: return 2
    }
}
