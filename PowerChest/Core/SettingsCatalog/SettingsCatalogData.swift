import Foundation

// swiftlint:disable file_length type_body_length

/// Static catalog data for PowerChest Settings Catalog v1.
/// Generated from specification 02 — powerchest_settings_catalog_v_1.md
///
/// Contains 81 settings (S001-S083, minus S067/S068 duplicates), 50 grouped controls,
/// and 5 presets (P001-P005).
enum SettingsCatalogData {

    static let catalogVersion = 1

    // MARK: - All Settings

    static let allSettings: [SettingDefinition] = [

        // ---------------------------------------------------------------
        // MARK: 5.1 Finder
        // Ordered by popularity: hidden files → extensions → Finder details
        // → new window target → full path → ~/Library → trash warning
        // → extension warning → save locally → quit Finder → .DS_Store
        // → spring-loading → search scope → view style
        // ---------------------------------------------------------------

        // S001
        SettingDefinition(
            id: "finder.showHiddenFiles",
            displayName: "Show hidden files",
            technicalName: "AppleShowAllFiles",
            powerUserLabel: "Show hidden files",
            powerUserDescription: "Makes normally hidden files and folders visible in Finder.",
            propellerheadDescription: "Controls whether Finder displays hidden files and folders.",
            category: .finder,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.finder",
            keyPath: "AppleShowAllFiles",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: "G001",
            searchAliases: ["hidden files", "dotfiles", "invisible files"],
            notes: "One of the highest-value settings in the product."
        ),

        // S002
        SettingDefinition(
            id: "global.showAllExtensions",
            displayName: "Show all filename extensions",
            technicalName: "AppleShowAllExtensions",
            powerUserLabel: "Always show file extensions",
            powerUserDescription: "Shows file endings like .jpg and .txt in Finder.",
            propellerheadDescription: "Controls whether filename extensions are always shown.",
            category: .finder,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "AppleShowAllExtensions",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: "G002",
            searchAliases: ["extensions", "suffix", "file ending"],
            notes: "Plain, high-value setting."
        ),

        // S004
        SettingDefinition(
            id: "finder.showPathBar",
            displayName: "Show Finder path bar",
            technicalName: "ShowPathbar",
            powerUserLabel: "Show the path bar in Finder",
            powerUserDescription: "Adds the bar at the bottom that shows where you are.",
            propellerheadDescription: "Controls visibility of Finder's path bar.",
            category: .finder,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.finder",
            keyPath: "ShowPathbar",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: "G004",
            searchAliases: ["path bar", "finder footer path"],
            notes: "Often paired with status bar."
        ),

        // S005
        SettingDefinition(
            id: "finder.showStatusBar",
            displayName: "Show Finder status bar",
            technicalName: "ShowStatusBar",
            powerUserLabel: "Show the Finder status bar",
            powerUserDescription: "Adds extra file and folder information at the bottom of Finder windows.",
            propellerheadDescription: "Controls visibility of Finder's status bar.",
            category: .finder,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.finder",
            keyPath: "ShowStatusBar",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: "G004",
            searchAliases: ["status bar", "finder info bar"],
            notes: "Good beginner-friendly value."
        ),

        // S006
        SettingDefinition(
            id: "finder.keepFoldersOnTopInWindow",
            displayName: "Keep folders on top in Finder windows",
            technicalName: "_FXSortFoldersFirst",
            powerUserLabel: "Keep folders at the top in Finder",
            powerUserDescription: "Makes folders easier to spot when sorting by name.",
            propellerheadDescription: "Controls whether Finder sorts folders before files in windows.",
            category: .finder,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.finder",
            keyPath: "_FXSortFoldersFirst",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: "G004",
            searchAliases: ["folders first", "sort folders first"],
            notes: "Verify exact behavior in all view types."
        ),

        // S007
        SettingDefinition(
            id: "finder.keepFoldersOnTopOnDesktop",
            displayName: "Keep folders on top on desktop",
            technicalName: "_FXSortFoldersFirstOnDesktop",
            powerUserLabel: "Keep folders at the top on the desktop",
            powerUserDescription: "Keeps desktop folders grouped ahead of loose files.",
            propellerheadDescription: "Controls whether Finder sorts folders before files on the desktop.",
            category: .finder,
            risk: .safe,
            interest: .obscure,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.finder",
            keyPath: "_FXSortFoldersFirstOnDesktop",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: "G004",
            searchAliases: ["desktop folders first"],
            notes: "Good add-on in bundled Finder extras."
        ),

        // S053
        SettingDefinition(
            id: "finder.newWindowTarget",
            displayName: "New Finder window default location",
            technicalName: "NewWindowTarget",
            powerUserLabel: "Where new Finder windows open",
            powerUserDescription: "Choose what folder appears when you open a new Finder window. Most people want Home or Desktop, not Recents.",
            propellerheadDescription: "Controls the default target directory for new Finder windows.",
            category: .finder,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.finder",
            keyPath: "NewWindowTarget",
            valueType: .enum,
            allowedValues: [.string("PfCm"), .string("PfHm"), .string("PfDe"), .string("PfDo"), .string("PfLo")],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: "G029",
            searchAliases: ["new finder window", "default folder", "finder opens to", "recents"],
            notes: "PfCm = Computer, PfHm = Home, PfDe = Desktop, PfDo = Documents, PfLo = Other (uses NewWindowTargetPath)."
        ),

        // S003
        SettingDefinition(
            id: "finder.showPosixPathInTitle",
            displayName: "Show POSIX path in Finder title",
            technicalName: "_FXShowPosixPathInTitle",
            powerUserLabel: "Show the full path in Finder windows",
            powerUserDescription: "Adds the full folder path to Finder window titles.",
            propellerheadDescription: "Controls whether Finder window titles include the full POSIX path.",
            category: .finder,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.finder",
            keyPath: "_FXShowPosixPathInTitle",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: "G003",
            searchAliases: ["path in title", "finder path", "full path"],
            notes: "Good power-user affordance."
        ),

        // S041
        SettingDefinition(
            id: "finder.showLibraryFolder",
            displayName: "Show ~/Library folder",
            technicalName: nil,
            powerUserLabel: "Show the Library folder in your home",
            powerUserDescription: "Makes the hidden ~/Library folder visible in Finder. Useful for accessing app preferences, caches, and support files.",
            propellerheadDescription: "Removes the hidden flag from ~/Library so it appears in Finder like any other folder.",
            category: .finder,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .command,
            domain: nil,
            keyPath: nil,
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: nil,
            searchAliases: ["library folder", "~/Library", "user library", "app support"],
            notes: "Uses chflags nohidden ~/Library to show and chflags hidden ~/Library to hide. First command-mechanism setting.",
            macOSDefaultValue: .bool(false)
        ),

        // S052
        SettingDefinition(
            id: "finder.warnOnEmptyTrash",
            displayName: "Warn before emptying Trash",
            technicalName: "WarnOnEmptyTrash",
            powerUserLabel: "Skip the empty Trash confirmation",
            powerUserDescription: "Stops Finder from asking \"Are you sure?\" every time you empty the Trash.",
            propellerheadDescription: "Controls whether Finder shows a confirmation dialog when emptying the Trash.",
            category: .finder,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.finder",
            keyPath: "WarnOnEmptyTrash",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: "G028",
            searchAliases: ["trash warning", "empty trash", "trash confirmation"],
            notes: "Raw value true = warning on. Power User toggle is inverted: ON = skip warning = write false.",
            isInvertedInPowerUserMode: true
        ),

        // S043
        SettingDefinition(
            id: "finder.disableExtensionChangeWarning",
            displayName: "Disable file extension change warning",
            technicalName: "FXEnableExtensionChangeWarning",
            powerUserLabel: "Skip the warning when changing file extensions",
            powerUserDescription: "Stops Finder from asking \"Are you sure?\" every time you rename a file and change its extension.",
            propellerheadDescription: "Controls whether Finder shows a confirmation dialog when a filename extension is changed.",
            category: .finder,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.finder",
            keyPath: "FXEnableExtensionChangeWarning",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: nil,
            searchAliases: ["extension warning", "rename warning", "file extension dialog"],
            notes: "Raw value true = warning enabled. Power User toggle is inverted: ON = skip warning = write false.",
            isInvertedInPowerUserMode: true
        ),

        // S042
        SettingDefinition(
            id: "global.saveToLocalDisk",
            displayName: "Save new documents to disk by default",
            technicalName: "NSDocumentSaveNewDocumentsToCloud",
            powerUserLabel: "Save new files to this Mac, not iCloud",
            powerUserDescription: "When you hit Save in an app, it starts in a folder on this Mac instead of iCloud Drive.",
            propellerheadDescription: "Controls whether new document save dialogs default to iCloud Drive or a local folder.",
            category: .finder,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "NSDocumentSaveNewDocumentsToCloud",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: nil,
            searchAliases: ["save to disk", "icloud save", "local save", "save dialog icloud"],
            notes: "Raw value true = save to iCloud. Power User toggle is inverted: ON = save locally = write false.",
            isInvertedInPowerUserMode: true
        ),

        // S051
        SettingDefinition(
            id: "finder.quitMenuItem",
            displayName: "Quit Finder menu item",
            technicalName: "QuitMenuItem",
            powerUserLabel: "Allow quitting Finder",
            powerUserDescription: "Adds a Quit option to the Finder menu. Useful when Finder is misbehaving or you want to free up resources.",
            propellerheadDescription: "Controls whether Finder shows a Quit menu item.",
            category: .finder,
            risk: .advanced,
            interest: .obscure,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.finder",
            keyPath: "QuitMenuItem",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: "G027",
            searchAliases: ["quit finder", "close finder", "exit finder"],
            notes: nil
        ),

        // S046
        SettingDefinition(
            id: "desktopservices.dontWriteNetworkDS",
            displayName: "Disable .DS_Store on network volumes",
            technicalName: "DSDontWriteNetworkStores",
            powerUserLabel: "Stop creating .DS_Store files on network drives",
            powerUserDescription: "Prevents Finder from leaving .DS_Store files on shared network folders. Other people on the network will thank you.",
            propellerheadDescription: "Controls whether Finder writes .DS_Store files to network-mounted volumes.",
            category: .finder,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.desktopservices",
            keyPath: "DSDontWriteNetworkStores",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: nil,
            searchAliases: [".DS_Store", "ds_store network", "network shares cleanup"],
            notes: "true = don't write. No inversion needed — Power User ON = write true."
        ),

        // S047
        SettingDefinition(
            id: "desktopservices.dontWriteUSBDS",
            displayName: "Disable .DS_Store on USB volumes",
            technicalName: "DSDontWriteUSBStores",
            powerUserLabel: "Stop creating .DS_Store files on USB drives",
            powerUserDescription: "Prevents Finder from leaving .DS_Store files on USB sticks and external drives. Keeps them clean when shared with Windows or Linux.",
            propellerheadDescription: "Controls whether Finder writes .DS_Store files to USB-mounted volumes.",
            category: .finder,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.desktopservices",
            keyPath: "DSDontWriteUSBStores",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: nil,
            searchAliases: [".DS_Store usb", "ds_store external", "usb cleanup"],
            notes: "true = don't write. No inversion needed."
        ),

        // S049
        SettingDefinition(
            id: "finder.springLoadingDelay",
            displayName: "Folder spring-loading delay",
            technicalName: "com.apple.springing.delay",
            powerUserLabel: "How long before dragged-over folders pop open",
            powerUserDescription: "When you drag a file and hover over a folder, the folder eventually springs open. This controls how long you have to wait. Lower is faster.",
            propellerheadDescription: "Sets the delay in seconds before a folder opens when you hover a dragged item over it in Finder.",
            category: .finder,
            risk: .safe,
            interest: .obscure,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "com.apple.springing.delay",
            valueType: .double,
            allowedValues: nil,
            defaultValueStrategy: .absentIsSystemDefault,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: nil,
            searchAliases: ["spring loading", "folder hover", "drag and drop delay", "folder pop open"],
            notes: "Default is about 0.5 seconds. Lower values make folders open faster when hovering."
        ),

        // S008
        SettingDefinition(
            id: "finder.defaultSearchScope",
            displayName: "Finder search scope",
            technicalName: "FXDefaultSearchScope",
            powerUserLabel: "Choose where Finder searches by default",
            powerUserDescription: "Sets whether Finder searches the current folder or the whole Mac by default.",
            propellerheadDescription: "Controls Finder's default search scope.",
            category: .finder,
            risk: .safe,
            interest: .obscure,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.finder",
            keyPath: "FXDefaultSearchScope",
            valueType: .enum,
            allowedValues: [.string("currentFolder"), .string("thisMac"), .string("previousScope")],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: nil,
            searchAliases: ["finder search", "search scope"],
            notes: "Good Propellerhead-only item at first."
        ),

        // S009
        SettingDefinition(
            id: "finder.preferredViewStyle",
            displayName: "Finder preferred view style",
            technicalName: "FXPreferredViewStyle",
            powerUserLabel: "Default Finder view",
            powerUserDescription: "Choose how Finder prefers to show folders by default.",
            propellerheadDescription: "Controls Finder's default preferred view style.",
            category: .finder,
            risk: .safe,
            interest: .obscure,
            supportLevel: .verify,
            mechanism: .defaults,
            domain: "com.apple.finder",
            keyPath: "FXPreferredViewStyle",
            valueType: .enum,
            allowedValues: [.string("icnv"), .string("Nlsv"), .string("clmv"), .string("glyv")],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: nil,
            searchAliases: ["finder view", "list view", "column view"],
            notes: "icnv=Icon, Nlsv=List, clmv=Column, glyv=Gallery. Include only after QA confirms consistency."
        ),

        // ---------------------------------------------------------------
        // MARK: 5.2 Dock and interface
        // Ordered by popularity: Dock size → position → Dock speed
        // → hide recents → minimize animation → minimize-to-app
        // → scroll bars → title bar double-click → expanded dialogs
        // → static dock → TextEdit → Help viewer → window animations
        // ---------------------------------------------------------------

        // S054
        SettingDefinition(
            id: "dock.tileSize",
            displayName: "Dock icon size",
            technicalName: "tilesize",
            powerUserLabel: "Dock icon size",
            powerUserDescription: "Controls how large the icons in the Dock are, in pixels.",
            propellerheadDescription: "Sets the Dock tile size in pixels.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dock",
            keyPath: "tilesize",
            valueType: .int,
            allowedValues: nil,
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: "G030",
            searchAliases: ["dock size", "icon size", "dock icons", "dock tile"],
            notes: "Typical range is 16–128. System default is around 48–64.",
            macOSDefaultValue: .int(48)
        ),

        // S055
        SettingDefinition(
            id: "dock.orientation",
            displayName: "Dock position",
            technicalName: "orientation",
            powerUserLabel: "Dock position on screen",
            powerUserDescription: "Move the Dock to the bottom, left, or right edge of your screen.",
            propellerheadDescription: "Controls the screen edge where the Dock is displayed.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dock",
            keyPath: "orientation",
            valueType: .enum,
            allowedValues: [.string("bottom"), .string("left"), .string("right")],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: "G031",
            searchAliases: ["dock position", "dock left", "dock right", "dock bottom", "move dock"],
            notes: nil,
            macOSDefaultValue: .string("bottom")
        ),

        // S010
        SettingDefinition(
            id: "dock.autohideDelay",
            displayName: "Dock auto-hide delay",
            technicalName: "autohide-delay",
            powerUserLabel: "Dock appearance delay",
            powerUserDescription: "Controls how long the Dock waits before appearing.",
            propellerheadDescription: "Sets the delay before the Dock appears when auto-hide is enabled.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dock",
            keyPath: "autohide-delay",
            valueType: .double,
            allowedValues: nil,
            defaultValueStrategy: .absentIsSystemDefault,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: "G005",
            searchAliases: ["dock delay", "autohide delay", "faster dock"],
            notes: "One of the marquee settings."
        ),

        // S011
        SettingDefinition(
            id: "dock.autohideAnimationSpeed",
            displayName: "Dock auto-hide animation speed",
            technicalName: "autohide-time-modifier",
            powerUserLabel: "Dock slide speed",
            powerUserDescription: "Controls how quickly the Dock slides in and out.",
            propellerheadDescription: "Adjusts Dock auto-hide animation duration.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dock",
            keyPath: "autohide-time-modifier",
            valueType: .double,
            allowedValues: nil,
            defaultValueStrategy: .absentIsSystemDefault,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: "G005",
            searchAliases: ["dock animation", "dock speed"],
            notes: "Combined with autohide delay for user-facing responsiveness."
        ),

        // S044
        SettingDefinition(
            id: "dock.showRecents",
            displayName: "Show recent applications in Dock",
            technicalName: "show-recents",
            powerUserLabel: "Hide recent apps from the Dock",
            powerUserDescription: "Removes that section at the end of the Dock that shows apps you opened recently. Keeps the Dock focused on what you put there.",
            propellerheadDescription: "Controls whether the Dock shows a section for recently opened applications.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dock",
            keyPath: "show-recents",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: nil,
            searchAliases: ["recent apps", "dock recents", "dock suggestions"],
            notes: "Raw value true = recents shown. Power User toggle is inverted: ON = hide recents = write false.",
            isInvertedInPowerUserMode: true
        ),

        // S056
        SettingDefinition(
            id: "dock.mineffect",
            displayName: "Minimize animation",
            technicalName: "mineffect",
            powerUserLabel: "Window minimize animation",
            powerUserDescription: "Choose between the swoopy Genie effect or the quicker Scale effect when minimizing windows.",
            propellerheadDescription: "Controls the animation used when minimizing windows to the Dock.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dock",
            keyPath: "mineffect",
            valueType: .enum,
            allowedValues: [.string("genie"), .string("scale")],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: "G032",
            searchAliases: ["minimize effect", "genie", "scale", "minimize animation"],
            notes: nil,
            macOSDefaultValue: .string("genie")
        ),

        // S012
        SettingDefinition(
            id: "dock.minimizeToApplication",
            displayName: "Minimize windows into app icon",
            technicalName: "minimize-to-application",
            powerUserLabel: "Tuck windows into the app icon",
            powerUserDescription: "Minimizes windows into the app's Dock icon.",
            propellerheadDescription: "Controls whether minimized windows collect into the application icon.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dock",
            keyPath: "minimize-to-application",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: "G006",
            searchAliases: ["minimize to icon", "dock minimize behavior"],
            notes: "High mainstream appeal."
        ),

        // S045
        SettingDefinition(
            id: "global.showScrollBars",
            displayName: "Scroll bar visibility",
            technicalName: "AppleShowScrollBars",
            powerUserLabel: "Always show scroll bars",
            powerUserDescription: "Makes scroll bars visible all the time instead of hiding them until you scroll. Handy if you lose your place in long documents.",
            propellerheadDescription: "Controls when scroll bars are shown. Options: based on input device, always, or only when scrolling.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "AppleShowScrollBars",
            valueType: .enum,
            allowedValues: [.string("Automatic"), .string("Always"), .string("WhenScrolling")],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: nil,
            searchAliases: ["scroll bars", "scrollbar", "always show scrollbar"],
            notes: nil
        ),

        // S057
        SettingDefinition(
            id: "global.titleBarDoubleClick",
            displayName: "Title bar double-click action",
            technicalName: "AppleActionOnDoubleClick",
            powerUserLabel: "What happens when you double-click a title bar",
            powerUserDescription: "Choose whether double-clicking a window's title bar zooms it, minimizes it, or does nothing.",
            propellerheadDescription: "Controls the action performed when double-clicking a window title bar.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "AppleActionOnDoubleClick",
            valueType: .enum,
            allowedValues: [.string("Maximize"), .string("Minimize"), .string("None")],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G033",
            searchAliases: ["double click title", "title bar action", "maximize", "zoom window"],
            notes: nil
        ),

        // S015
        SettingDefinition(
            id: "global.savePanelExpanded",
            displayName: "Save panel expanded by default",
            technicalName: "NSNavPanelExpandedStateForSaveMode",
            powerUserLabel: "Open Save dialogs fully expanded",
            powerUserDescription: "Starts Save dialogs in the larger, detailed version.",
            propellerheadDescription: "Controls whether Save panels open in expanded form by default.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "NSNavPanelExpandedStateForSaveMode",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G008",
            searchAliases: ["expanded save panel", "save dialog"],
            notes: "Pair with print panel equivalent."
        ),

        // S016
        SettingDefinition(
            id: "global.printPanelExpanded",
            displayName: "Print panel expanded by default",
            technicalName: "PMPrintingExpandedStateForPrint",
            powerUserLabel: "Open Print dialogs fully expanded",
            powerUserDescription: "Starts Print dialogs in their detailed version.",
            propellerheadDescription: "Controls whether Print panels open in expanded form by default.",
            category: .interface,
            risk: .safe,
            interest: .obscure,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "PMPrintingExpandedStateForPrint",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G008",
            searchAliases: ["expanded print panel", "print dialog"],
            notes: "Nice pair with save panel setting."
        ),

        // S013
        SettingDefinition(
            id: "dock.staticOnly",
            displayName: "Show only open applications in Dock",
            technicalName: "static-only",
            powerUserLabel: "Show only open apps in the Dock",
            powerUserDescription: "Keeps the Dock focused on apps that are currently running.",
            propellerheadDescription: "Controls whether the Dock shows only running apps.",
            category: .interface,
            risk: .advanced,
            interest: .obscure,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dock",
            keyPath: "static-only",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: "G007",
            searchAliases: ["running apps only", "static dock"],
            notes: "Nice niche setting; default surface in Power User is optional."
        ),

        // S048
        SettingDefinition(
            id: "textEdit.plainTextDefault",
            displayName: "Use plain text by default in TextEdit",
            technicalName: "RichText",
            powerUserLabel: "Open TextEdit in plain text mode",
            powerUserDescription: "When you open a new TextEdit document, it starts in plain text instead of rich text. Better for quick notes and code snippets.",
            propellerheadDescription: "Controls whether TextEdit creates new documents in rich text or plain text format.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.TextEdit",
            keyPath: "RichText",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: nil,
            searchAliases: ["textedit plain text", "textedit default format", "plain text editor"],
            notes: "Raw value true/1 = rich text. Power User toggle is inverted: ON = plain text = write false/0.",
            isInvertedInPowerUserMode: true
        ),

        // S066
        SettingDefinition(
            id: "helpViewer.devMode",
            displayName: "Help viewer non-floating",
            technicalName: "DevMode",
            powerUserLabel: "Stop Help windows from floating over everything",
            powerUserDescription: "The Help viewer normally floats above all other windows and refuses to go behind them. This makes it behave like a normal window.",
            propellerheadDescription: "Controls whether the Help viewer window floats above other windows.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.helpviewer",
            keyPath: "DevMode",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G041",
            searchAliases: ["help viewer", "help floating", "help window", "help on top"],
            notes: nil
        ),

        // S014
        SettingDefinition(
            id: "global.windowAnimationsEnabled",
            displayName: "Automatic window animations",
            technicalName: "NSAutomaticWindowAnimationsEnabled",
            powerUserLabel: "Use window animations",
            powerUserDescription: "Controls whether some interface windows animate open and closed.",
            propellerheadDescription: "Toggles certain automatic window animations.",
            category: .interface,
            risk: .advanced,
            interest: .obscure,
            supportLevel: .verify,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "NSAutomaticWindowAnimationsEnabled",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .absentIsSystemDefault,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: nil,
            searchAliases: ["window animations"],
            notes: "Do not ship until confirmed to still matter."
        ),

        // S083
        SettingDefinition(
            id: "global.appNap",
            displayName: "App Nap",
            technicalName: "NSAppSleepDisabled",
            powerUserLabel: "Disable App Nap",
            powerUserDescription: "macOS silently pauses apps it thinks you're not using to save energy. Sounds great until a background task mysteriously stops working. Disabling this keeps all apps running at full speed all the time.",
            propellerheadDescription: "App Nap suspends background apps to conserve energy. Disabling (NSAppSleepDisabled = true) prevents macOS from throttling or suspending any application. Not exposed in System Settings.",
            category: .interface,
            risk: .advanced,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "NSAppSleepDisabled",
            valueType: .bool,
            allowedValues: nil,
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G053",
            searchAliases: ["app nap", "background apps", "throttle", "energy", "suspend", "performance"],
            notes: "Disabling may increase energy usage. Apps will no longer be paused when in the background."
        ),

        // ---------------------------------------------------------------
        // MARK: 5.3 Keyboard and input
        // Ordered by popularity: accent popup → key repeat speed
        // → typing helpers → full keyboard access
        // ---------------------------------------------------------------

        // S019
        SettingDefinition(
            id: "global.pressAndHoldEnabled",
            displayName: "Press-and-hold accent popup enabled",
            technicalName: "ApplePressAndHoldEnabled",
            powerUserLabel: "Use key repeat instead of the accent popup",
            powerUserDescription: "Holding a key repeats it instead of showing accent choices.",
            propellerheadDescription: "Controls whether holding a key opens the accent selection popup instead of repeating the key.",
            category: .keyboardInput,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "ApplePressAndHoldEnabled",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G010",
            searchAliases: ["accent popup", "press and hold", "key repeat vs accents"],
            notes: "In Power User UI, present the inverse of the raw key.",
            isInvertedInPowerUserMode: true
        ),

        // S017
        SettingDefinition(
            id: "global.keyRepeat",
            displayName: "Key repeat rate",
            technicalName: "KeyRepeat",
            powerUserLabel: "Key repeat speed",
            powerUserDescription: "Controls how quickly a held key repeats.",
            propellerheadDescription: "Sets the repeat rate used when holding a key.",
            category: .keyboardInput,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "KeyRepeat",
            valueType: .int,
            allowedValues: nil,
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G009",
            searchAliases: ["key repeat", "typing speed"],
            notes: "High-value setting for devs and writers."
        ),

        // S018
        SettingDefinition(
            id: "global.initialKeyRepeat",
            displayName: "Initial key repeat delay",
            technicalName: "InitialKeyRepeat",
            powerUserLabel: "Delay before keys start repeating",
            powerUserDescription: "Controls how long you hold a key before repeating begins.",
            propellerheadDescription: "Sets the delay before key repetition starts.",
            category: .keyboardInput,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "InitialKeyRepeat",
            valueType: .int,
            allowedValues: nil,
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G009",
            searchAliases: ["repeat delay", "initial key delay"],
            notes: "Always treat as paired with KeyRepeat in Power User."
        ),

        // S020
        SettingDefinition(
            id: "global.smartQuotes",
            displayName: "Smart quotes",
            technicalName: "NSAutomaticQuoteSubstitutionEnabled",
            powerUserLabel: "Replace straight quotes automatically",
            powerUserDescription: "Turns automatic quote styling on or off.",
            propellerheadDescription: "Controls automatic quote substitution in supported apps.",
            category: .keyboardInput,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "NSAutomaticQuoteSubstitutionEnabled",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G011",
            searchAliases: ["smart quotes", "curly quotes"],
            notes: "Popular with technical users."
        ),

        // S021
        SettingDefinition(
            id: "global.smartDashes",
            displayName: "Smart dashes",
            technicalName: "NSAutomaticDashSubstitutionEnabled",
            powerUserLabel: "Replace hyphens with dashes automatically",
            powerUserDescription: "Turns automatic dash substitution on or off.",
            propellerheadDescription: "Controls automatic dash substitution in supported apps.",
            category: .keyboardInput,
            risk: .safe,
            interest: .obscure,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "NSAutomaticDashSubstitutionEnabled",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G011",
            searchAliases: ["smart dashes"],
            notes: "Good to bundle with smart quotes."
        ),

        // S022
        SettingDefinition(
            id: "global.autoCapitalization",
            displayName: "Automatic capitalization",
            technicalName: "NSAutomaticCapitalizationEnabled",
            powerUserLabel: "Capitalize sentences automatically",
            powerUserDescription: "Turns automatic capitalization on or off.",
            propellerheadDescription: "Controls automatic capitalization in supported apps.",
            category: .keyboardInput,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "NSAutomaticCapitalizationEnabled",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G011",
            searchAliases: ["auto caps", "capitalization"],
            notes: "Useful for coding-centric users."
        ),

        // S023
        SettingDefinition(
            id: "global.autoSpellingCorrection",
            displayName: "Automatic spelling correction",
            technicalName: "NSAutomaticSpellingCorrectionEnabled",
            powerUserLabel: "Correct spelling automatically",
            powerUserDescription: "Turns automatic spelling correction on or off.",
            propellerheadDescription: "Controls automatic spelling correction in supported apps.",
            category: .keyboardInput,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "NSAutomaticSpellingCorrectionEnabled",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G011",
            searchAliases: ["autocorrect", "spell correction"],
            notes: "Important mainstream toggle."
        ),

        // S024
        SettingDefinition(
            id: "global.periodSubstitution",
            displayName: "Double-space period shortcut",
            technicalName: "NSAutomaticPeriodSubstitutionEnabled",
            powerUserLabel: "Add a period when you double-tap space",
            powerUserDescription: "Turns the double-space period shortcut on or off.",
            propellerheadDescription: "Controls automatic period substitution when space is pressed twice.",
            category: .keyboardInput,
            risk: .safe,
            interest: .obscure,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "NSAutomaticPeriodSubstitutionEnabled",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G011",
            searchAliases: ["double space period"],
            notes: "Nice supporting toggle."
        ),

        // S058
        SettingDefinition(
            id: "global.fullKeyboardAccess",
            displayName: "Full keyboard access",
            technicalName: "AppleKeyboardUIMode",
            powerUserLabel: "Tab through all controls in dialogs",
            powerUserDescription: "Lets you use Tab to move between all buttons and fields in dialogs, not just text boxes. Essential for keyboard-first workflows.",
            propellerheadDescription: "Controls whether keyboard focus can move to all controls (value 3) or only text fields and lists (value 0).",
            category: .keyboardInput,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "AppleKeyboardUIMode",
            valueType: .int,
            allowedValues: [.int(0), .int(3)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G034",
            searchAliases: ["tab key", "keyboard navigation", "full keyboard", "tab through buttons", "keyboard access"],
            notes: "Value 0 = text fields only. Value 3 = all controls. Power User toggle: ON = 3, OFF = 0."
        ),

        // S081
        SettingDefinition(
            id: "mouse.acceleration",
            displayName: "Mouse acceleration",
            technicalName: "com.apple.mouse.scaling",
            powerUserLabel: "Disable mouse acceleration",
            powerUserDescription: "macOS adds acceleration to mouse movement — move the mouse fast and the cursor travels further than you'd expect. Gamers and designers hate this. Set to -1 for raw, unaccelerated input. Set to 0 for very slow linear movement, or 1-3 for increasing acceleration.",
            propellerheadDescription: "Controls the mouse acceleration curve. -1 disables acceleration entirely (raw input). 0 is linear with no amplification. 1-3 adds increasing acceleration. System Settings only offers a limited speed slider, not this level of control.",
            category: .keyboardInput,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "com.apple.mouse.scaling",
            valueType: .double,
            allowedValues: [.double(-1), .double(3)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G051",
            searchAliases: ["mouse acceleration", "raw input", "mouse speed", "gaming", "linear mouse", "no acceleration"],
            notes: "-1 = raw/no acceleration. 0 = linear. 1-3 = increasing acceleration. Changes take effect immediately."
        ),

        // ---------------------------------------------------------------
        // MARK: 5.4 Windows and Spaces
        // Ordered by popularity: fixed Spaces → group by app
        // → Mission Control speed → separate Spaces per display
        // ---------------------------------------------------------------

        // S025
        SettingDefinition(
            id: "dock.mruSpaces",
            displayName: "Automatically rearrange Spaces",
            technicalName: "mru-spaces",
            powerUserLabel: "Keep Spaces in a fixed order",
            powerUserDescription: "Stops macOS from reordering Spaces based on recent use.",
            propellerheadDescription: "Controls whether Spaces are automatically rearranged by recent use.",
            category: .windowsSpaces,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dock",
            keyPath: "mru-spaces",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: "G012",
            searchAliases: ["spaces order", "mru spaces", "desktops order"],
            notes: "In Power User UI present this as the inverse behavior.",
            isInvertedInPowerUserMode: true,
            macOSDefaultValue: .bool(true)
        ),

        // S059
        SettingDefinition(
            id: "dock.exposeGroupApps",
            displayName: "Group windows by app in Mission Control",
            technicalName: "expose-group-apps",
            powerUserLabel: "Group windows by app in Mission Control",
            powerUserDescription: "When you open Mission Control, windows from the same app are stacked together instead of scattered around.",
            propellerheadDescription: "Controls whether Mission Control groups windows by their parent application.",
            category: .windowsSpaces,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dock",
            keyPath: "expose-group-apps",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: "G035",
            searchAliases: ["group windows", "mission control grouping", "expose group"],
            notes: nil,
            macOSDefaultValue: .bool(false)
        ),

        // S026
        SettingDefinition(
            id: "dock.exposeAnimationDuration",
            displayName: "Mission Control animation duration",
            technicalName: "expose-animation-duration",
            powerUserLabel: "Mission Control animation speed",
            powerUserDescription: "Changes how fast Mission Control animates.",
            propellerheadDescription: "Sets the animation duration used by Mission Control.",
            category: .windowsSpaces,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dock",
            keyPath: "expose-animation-duration",
            valueType: .double,
            allowedValues: nil,
            defaultValueStrategy: .absentIsSystemDefault,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: "G013",
            searchAliases: ["mission control speed", "expose animation"],
            notes: "Good UI responsiveness knob."
        ),

        // S060
        SettingDefinition(
            id: "spaces.spansDisplays",
            displayName: "Displays have separate Spaces",
            technicalName: "spans-displays",
            powerUserLabel: "Give each display its own set of Spaces",
            powerUserDescription: "With multiple monitors, each screen gets its own independent desktop spaces. Switching spaces on one screen does not affect the other.",
            propellerheadDescription: "Controls whether Spaces are independent per display or span all displays together.",
            category: .windowsSpaces,
            risk: .safe,
            interest: .common,
            supportLevel: .hold,
            mechanism: .defaults,
            domain: "com.apple.spaces",
            keyPath: "spans-displays",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .signOut,
            powerUserGrouping: nil,
            searchAliases: ["separate spaces", "multi monitor spaces", "display spaces", "spans displays"],
            notes: "Hold: spans-displays key no longer exists in any defaults domain on macOS 26. Spaces config uses SpacesDisplayConfiguration structure now.",
            isInvertedInPowerUserMode: true
        ),

        // ---------------------------------------------------------------
        // MARK: 5.5 Screenshots
        // ---------------------------------------------------------------

        // S027
        SettingDefinition(
            id: "screencapture.location",
            displayName: "Screenshot save location",
            technicalName: "location",
            powerUserLabel: "Save screenshots here",
            powerUserDescription: "Chooses the folder where screenshots are saved.",
            propellerheadDescription: "Sets the save location used by the screenshot system.",
            category: .screenshots,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.screencapture",
            keyPath: "location",
            valueType: .path,
            allowedValues: nil,
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .systemUIServer,
            powerUserGrouping: "G014",
            searchAliases: ["screenshot folder", "save screenshots"],
            notes: "Needs strong path validation UX."
        ),

        // S028
        SettingDefinition(
            id: "screencapture.format",
            displayName: "Screenshot image format",
            technicalName: "type",
            powerUserLabel: "Screenshot format",
            powerUserDescription: "Chooses the image format used for screenshots.",
            propellerheadDescription: "Sets the image type used by the screenshot system.",
            category: .screenshots,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.screencapture",
            keyPath: "type",
            valueType: .enum,
            allowedValues: [.string("png"), .string("jpg"), .string("pdf"), .string("tiff"), .string("gif")],
            defaultValueStrategy: .absentIsSystemDefault,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .systemUIServer,
            powerUserGrouping: "G014",
            searchAliases: ["screenshot type", "png", "jpg"],
            notes: "Consider limiting Power User UI to the most sane formats."
        ),

        // S029
        SettingDefinition(
            id: "screencapture.disableShadow",
            displayName: "Disable screenshot window shadow",
            technicalName: "disable-shadow",
            powerUserLabel: "Remove window shadows from screenshots",
            powerUserDescription: "Keeps window screenshots clean by removing the drop shadow.",
            propellerheadDescription: "Controls whether screenshot window captures include a shadow.",
            category: .screenshots,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.screencapture",
            keyPath: "disable-shadow",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .systemUIServer,
            powerUserGrouping: "G014",
            searchAliases: ["screenshot shadow"],
            notes: "Strong utility setting."
        ),

        // S030
        SettingDefinition(
            id: "screencapture.showThumbnail",
            displayName: "Show floating screenshot thumbnail",
            technicalName: "show-thumbnail",
            powerUserLabel: "Show the screenshot thumbnail preview",
            powerUserDescription: "Controls whether a small preview appears after taking a screenshot.",
            propellerheadDescription: "Controls the floating thumbnail preview shown after screenshots are captured.",
            category: .screenshots,
            risk: .safe,
            interest: .obscure,
            supportLevel: .verify,
            mechanism: .defaults,
            domain: "com.apple.screencapture",
            keyPath: "show-thumbnail",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .systemUIServer,
            powerUserGrouping: "G014",
            searchAliases: ["screenshot thumbnail", "preview bubble"],
            notes: "Keep in verify queue until confirmed."
        ),

        // S050
        SettingDefinition(
            id: "screencapture.name",
            displayName: "Screenshot filename prefix",
            technicalName: "name",
            powerUserLabel: "Screenshot file name prefix",
            powerUserDescription: "Changes what screenshots are called. The default is \"Screenshot\" but you can use anything you like.",
            propellerheadDescription: "Sets the filename prefix used for screenshot files.",
            category: .screenshots,
            risk: .safe,
            interest: .obscure,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.screencapture",
            keyPath: "name",
            valueType: .string,
            allowedValues: nil,
            defaultValueStrategy: .absentIsSystemDefault,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .systemUIServer,
            powerUserGrouping: "G014",
            searchAliases: ["screenshot name", "screenshot prefix", "screenshot filename"],
            notes: "Default is \"Screenshot\". Pairs with the existing screenshot group."
        ),

        // ---------------------------------------------------------------
        // MARK: 5.6 Safari and developer basics
        // Ordered by popularity: full URL & dev tools → stop auto-open
        // → show link URLs → WebKit extras
        // ---------------------------------------------------------------

        // S031
        SettingDefinition(
            id: "safari.showFullURL",
            displayName: "Show full URL in Safari smart search field",
            technicalName: "ShowFullURLInSmartSearchField",
            powerUserLabel: "Show full web addresses in Safari",
            powerUserDescription: "Shows the complete address instead of a shortened one.",
            propellerheadDescription: "Controls whether Safari shows the full URL in the smart search field.",
            category: .safariDeveloper,
            risk: .safe,
            interest: .common,
            supportLevel: .hold,
            mechanism: .defaults,
            domain: "com.apple.Safari",
            keyPath: "ShowFullURLInSmartSearchField",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .safari,
            powerUserGrouping: "G015",
            searchAliases: ["safari full url", "full address"],
            notes: "Safari's preferences are sandboxed — defaults write com.apple.Safari is blocked by macOS."
        ),

        // S032
        SettingDefinition(
            id: "safari.includeDevelopMenu",
            displayName: "Include Safari Develop menu",
            technicalName: "IncludeDevelopMenu",
            powerUserLabel: "Turn on Safari's developer menu",
            powerUserDescription: "Adds Safari's developer tools menu.",
            propellerheadDescription: "Controls visibility of Safari's Develop menu.",
            category: .safariDeveloper,
            risk: .safe,
            interest: .common,
            supportLevel: .hold,
            mechanism: .defaults,
            domain: "com.apple.Safari",
            keyPath: "IncludeDevelopMenu",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .safari,
            powerUserGrouping: "G015",
            searchAliases: ["safari develop menu", "web inspector"],
            notes: "Safari's preferences are sandboxed — defaults write com.apple.Safari is blocked by macOS."
        ),

        // S061
        SettingDefinition(
            id: "safari.autoOpenSafeDownloads",
            displayName: "Auto-open safe downloads",
            technicalName: "AutoOpenSafeDownloads",
            powerUserLabel: "Stop Safari from auto-opening downloads",
            powerUserDescription: "Prevents Safari from automatically opening files it considers \"safe\" after downloading — like DMGs, PDFs, and zip files.",
            propellerheadDescription: "Controls whether Safari automatically opens downloaded files it classifies as safe.",
            category: .safariDeveloper,
            risk: .safe,
            interest: .common,
            supportLevel: .hold,
            mechanism: .defaults,
            domain: "com.apple.Safari",
            keyPath: "AutoOpenSafeDownloads",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .safari,
            powerUserGrouping: "G037",
            searchAliases: ["auto open downloads", "safe downloads", "safari downloads", "open after download"],
            notes: "Safari's preferences are sandboxed — defaults write com.apple.Safari is blocked by macOS.",
            isInvertedInPowerUserMode: true
        ),

        // S062
        SettingDefinition(
            id: "safari.showStatusBar",
            displayName: "Show Safari status bar",
            technicalName: "ShowOverlayStatusBar",
            powerUserLabel: "Show link URLs when hovering in Safari",
            powerUserDescription: "Shows a status bar at the bottom of Safari that displays the URL of any link you hover over. Good for spotting where a link actually goes.",
            propellerheadDescription: "Controls whether Safari displays the overlay status bar showing link destinations.",
            category: .safariDeveloper,
            risk: .safe,
            interest: .common,
            supportLevel: .hold,
            mechanism: .defaults,
            domain: "com.apple.Safari",
            keyPath: "ShowOverlayStatusBar",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .safari,
            powerUserGrouping: "G038",
            searchAliases: ["status bar safari", "link preview", "hover url", "safari status"],
            notes: "Safari's preferences are sandboxed — defaults write com.apple.Safari is blocked by macOS."
        ),

        // S033
        SettingDefinition(
            id: "safari.webKitDeveloperExtras",
            displayName: "WebKit developer extras in web views",
            technicalName: "WebKitDeveloperExtrasEnabledPreferenceKey",
            powerUserLabel: nil,
            powerUserDescription: "Enables WebKit developer extras in supported embedded web views.",
            propellerheadDescription: "Enables WebKit developer extras in supported embedded web views.",
            category: .safariDeveloper,
            risk: .advanced,
            interest: .obscure,
            supportLevel: .hold,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "WebKitDeveloperExtras",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: nil,
            searchAliases: ["webkit extras", "inspect element in web view"],
            notes: "Keep out of v1 unless validated and clearly useful."
        ),

        // ---------------------------------------------------------------
        // MARK: 5.7 Accessibility and visual behavior
        // ---------------------------------------------------------------

        // S034
        SettingDefinition(
            id: "accessibility.reduceTransparency",
            displayName: "Reduce transparency",
            technicalName: "reduceTransparency",
            powerUserLabel: "Use more solid backgrounds",
            powerUserDescription: "Replaces some translucent, frosted effects with more solid backgrounds.",
            propellerheadDescription: "Controls the system accessibility setting for reduced transparency.",
            category: .accessibilityVisual,
            risk: .safe,
            interest: .common,
            supportLevel: .hold,
            mechanism: .defaults,
            domain: "com.apple.universalaccess",
            keyPath: "reduceTransparency",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G016",
            searchAliases: ["transparency", "blur", "frosted glass", "glass look"],
            notes: "Hold: com.apple.universalaccess is read-only on macOS 26 and reduceTransparency key no longer exists in any defaults domain."
        ),

        // S035
        SettingDefinition(
            id: "accessibility.increaseContrast",
            displayName: "Increase contrast",
            technicalName: "EnhancedBackgroundContrastEnabled",
            powerUserLabel: "Make outlines and separation stronger",
            powerUserDescription: "Makes interface elements stand out more clearly.",
            propellerheadDescription: "Controls the system accessibility setting for increased contrast.",
            category: .accessibilityVisual,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.Accessibility",
            keyPath: "EnhancedBackgroundContrastEnabled",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G016",
            searchAliases: ["contrast", "crisper interface"],
            notes: "Pair with reduce transparency for solid UI preset."
        ),

        // S036
        SettingDefinition(
            id: "accessibility.reduceMotion",
            displayName: "Reduce motion",
            technicalName: "ReduceMotionEnabled",
            powerUserLabel: "Use less motion in the interface",
            powerUserDescription: "Cuts certain movement-heavy animations.",
            propellerheadDescription: "Controls the system accessibility setting for reduced motion.",
            category: .accessibilityVisual,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.Accessibility",
            keyPath: "ReduceMotionEnabled",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: nil,
            searchAliases: ["motion", "animations", "movement"],
            notes: "Strong candidate for v1.1 or MVP if UI space allows."
        ),

        // S037
        SettingDefinition(
            id: "accessibility.mouseDriverCursorSize",
            displayName: "Cursor size",
            technicalName: "mouseDriverCursorSize",
            powerUserLabel: "Pointer size",
            powerUserDescription: "Makes the pointer easier to spot.",
            propellerheadDescription: "Controls the mouse pointer size through accessibility settings.",
            category: .accessibilityVisual,
            risk: .safe,
            interest: .obscure,
            supportLevel: .hold,
            mechanism: .defaults,
            domain: "com.apple.universalaccess",
            keyPath: "mouseDriverCursorSize",
            valueType: .double,
            allowedValues: nil,
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: nil,
            searchAliases: ["cursor size", "pointer size"],
            notes: "Hold: mouseDriverCursorSize no longer exists in any defaults domain on macOS 26. Cursor size is now managed through accessibility APIs."
        ),

        // S082
        SettingDefinition(
            id: "display.fontSmoothing",
            displayName: "Font smoothing",
            technicalName: "CGFontRenderingFontSmoothingDisabled",
            powerUserLabel: "Font smoothing on non-Retina displays",
            powerUserDescription: "Apple removed the font smoothing checkbox in Mojave, but the setting still works. If you use an external non-Retina monitor and text looks thin or spidery, turning this on re-enables subpixel antialiasing for crisper text.",
            propellerheadDescription: "Re-enables subpixel font antialiasing that Apple disabled by default in macOS Mojave. Only visible on non-Retina displays. The CGFontRenderingFontSmoothingDisabled default was removed from System Settings but still functions.",
            category: .accessibilityVisual,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "CGFontRenderingFontSmoothingDisabled",
            valueType: .bool,
            allowedValues: nil,
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .signOut,
            powerUserGrouping: "G052",
            searchAliases: ["font smoothing", "subpixel", "antialiasing", "blurry text", "thin text", "non-retina", "external monitor"],
            notes: "Only matters on non-Retina displays. Requires sign-out to take effect.",
            isInvertedInPowerUserMode: true
        ),

        // ---------------------------------------------------------------
        // MARK: 5.8 Menu bar and status
        // Ordered by popularity: 24-hour clock → battery/flash → date
        // ---------------------------------------------------------------

        // S063
        SettingDefinition(
            id: "menu.clock24Hour",
            displayName: "24-hour clock",
            technicalName: "Show24Hour",
            powerUserLabel: "Use 24-hour time in the menu bar",
            powerUserDescription: "Switches the menu bar clock to 24-hour format instead of 12-hour with AM/PM.",
            propellerheadDescription: "Controls whether the menu bar clock uses 24-hour or 12-hour format.",
            category: .menuBarStatus,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.menuextra.clock",
            keyPath: "Show24Hour",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .controlCenter,
            powerUserGrouping: "G039",
            searchAliases: ["24 hour", "military time", "clock format", "time format"],
            notes: nil
        ),

        // S038
        SettingDefinition(
            id: "menu.batteryShowPercent",
            displayName: "Show battery percentage",
            technicalName: "ShowPercent",
            powerUserLabel: "Show battery percentage",
            powerUserDescription: "Shows the battery level as a percentage.",
            propellerheadDescription: "Controls percentage visibility for the battery status item where supported.",
            category: .menuBarStatus,
            risk: .safe,
            interest: .common,
            supportLevel: .hold,
            mechanism: .defaults,
            domain: "com.apple.menuextra.battery",
            keyPath: "ShowPercent",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .controlCenter,
            powerUserGrouping: "G017",
            searchAliases: ["battery percent"],
            notes: "Valuable, but keep behind compatibility adapter."
        ),

        // S039
        SettingDefinition(
            id: "menu.clockFlashDateSeparators",
            displayName: "Flashing time separators in menu bar clock",
            technicalName: "FlashDateSeparators",
            powerUserLabel: "Make the clock separators blink",
            powerUserDescription: "Lets the clock's separators blink once per second.",
            propellerheadDescription: "Controls whether the menu bar clock flashes its separators.",
            category: .menuBarStatus,
            risk: .safe,
            interest: .obscure,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.menuextra.clock",
            keyPath: "FlashDateSeparators",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .controlCenter,
            powerUserGrouping: "G017",
            searchAliases: ["blinking clock", "flashing colon"],
            notes: "Geeky but harmless."
        ),

        // S064
        SettingDefinition(
            id: "menu.clockShowDate",
            displayName: "Show date in menu bar clock",
            technicalName: "ShowDate",
            powerUserLabel: "Show the date next to the time",
            powerUserDescription: "Adds the date to the menu bar clock so you always know what day it is.",
            propellerheadDescription: "Controls whether the menu bar clock includes the date.",
            category: .menuBarStatus,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.menuextra.clock",
            keyPath: "ShowDate",
            valueType: .int,
            allowedValues: [.int(0), .int(1), .int(2)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .controlCenter,
            powerUserGrouping: "G042",
            searchAliases: ["show date", "menu bar date", "clock date"],
            notes: "0 = when space allows, 1 = always, 2 = never. Group with 24-hour clock in G039."
        ),

        // ---------------------------------------------------------------
        // MARK: 5.9 Security and privacy
        // Ordered by popularity: quarantine → crash reporter
        // ---------------------------------------------------------------

        // S040
        SettingDefinition(
            id: "launchServices.quarantine",
            displayName: "Launch Services quarantine",
            technicalName: "LSQuarantine",
            powerUserLabel: "Skip app quarantine prompts",
            powerUserDescription: "Disables the quarantine flag used for some \"downloaded from the internet\" warnings.",
            propellerheadDescription: "Controls whether Launch Services applies quarantine metadata to newly downloaded apps and files.",
            category: .securityPrivacy,
            risk: .systemSensitive,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.LaunchServices",
            keyPath: "LSQuarantine",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G018",
            searchAliases: ["quarantine", "downloaded from internet prompt", "gatekeeper warning"],
            notes: "Must be clearly explained as a security-reducing change."
        ),

        // S065
        SettingDefinition(
            id: "crashReporter.dialogType",
            displayName: "Crash reporter detail level",
            technicalName: "DialogType",
            powerUserLabel: "Show detailed crash reports",
            powerUserDescription: "When an app crashes, shows the technical details instead of just \"unexpectedly quit\". Useful if you want to know why something broke.",
            propellerheadDescription: "Controls whether the crash reporter dialog shows developer-level detail or the basic user dialog.",
            category: .securityPrivacy,
            risk: .safe,
            interest: .obscure,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.CrashReporter",
            keyPath: "DialogType",
            valueType: .enum,
            allowedValues: [.string("crashreport"), .string("developer"), .string("server"), .string("none")],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G040",
            searchAliases: ["crash reporter", "crash dialog", "crash details", "app crashed"],
            notes: "crashreport = basic dialog, developer = shows full report, server = silent, none = no dialog."
        ),

        // ---------------------------------------------------------------
        // MARK: 5.10 Network & Connectivity
        // Ordered by popularity: Firewall → .DS_Store → Safari privacy
        // → Captive portal → AirDrop → Bluetooth → Remote access → MAC spoof
        // ---------------------------------------------------------------

        // S075
        SettingDefinition(
            id: "network.firewallEnabled",
            displayName: "Application firewall",
            technicalName: "socketfilterfw",
            powerUserLabel: "Application firewall",
            powerUserDescription: "Turns on the built-in macOS firewall that controls which apps can accept incoming network connections. Off by default — turning it on is a good baseline security step.",
            propellerheadDescription: "Enables the macOS application-level firewall (socketfilterfw). Controls incoming connections per application. Requires admin password.",
            category: .networkConnectivity,
            risk: .systemSensitive,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .privilegedCommand,
            domain: nil,
            keyPath: nil,
            valueType: .bool,
            allowedValues: nil,
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G048",
            searchAliases: ["firewall", "security", "incoming connections", "block"],
            notes: "Requires admin.",
            macOSDefaultValue: .bool(false)
        ),

        // S076
        SettingDefinition(
            id: "network.firewallStealth",
            displayName: "Firewall stealth mode",
            technicalName: "stealthenabled",
            powerUserLabel: "Stealth mode",
            powerUserDescription: "Makes your Mac invisible on the network. It won't respond to pings or port scans — like it's not even there. Great on public Wi-Fi.",
            propellerheadDescription: "Enables stealth mode in the macOS firewall. Your Mac will not respond to ICMP ping requests or TCP/UDP port scans. Requires admin password.",
            category: .networkConnectivity,
            risk: .systemSensitive,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .privilegedCommand,
            domain: nil,
            keyPath: nil,
            valueType: .bool,
            allowedValues: nil,
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G048",
            searchAliases: ["stealth", "ping", "port scan", "invisible", "firewall stealth"],
            notes: "Requires admin. Firewall must be enabled for this to take effect.",
            macOSDefaultValue: .bool(false)
        ),

        // S077
        SettingDefinition(
            id: "network.firewallBlockAll",
            displayName: "Block all incoming connections",
            technicalName: "blockall",
            powerUserLabel: "Block all incoming",
            powerUserDescription: "Nuclear option: blocks ALL incoming connections except the absolute basics needed for internet to work. Will break file sharing, screen sharing, AirDrop, and anything that listens for connections.",
            propellerheadDescription: "Blocks all incoming connections except those required for basic internet (DHCP, DNS, IPSec). Very restrictive. Requires admin password.",
            category: .networkConnectivity,
            risk: .systemSensitive,
            interest: .obscure,
            supportLevel: .shipping,
            mechanism: .privilegedCommand,
            domain: nil,
            keyPath: nil,
            valueType: .bool,
            allowedValues: nil,
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G048",
            searchAliases: ["block all", "incoming connections", "lockdown", "firewall block"],
            notes: "Requires admin. Very restrictive — may break file sharing, AirDrop, etc.",
            macOSDefaultValue: .bool(false)
        ),

        // S067/S068 removed — duplicates of S046/S047 (same domain/key in Finder category)

        // S070
        SettingDefinition(
            id: "safari.dnsPrefetching",
            displayName: "DNS prefetching",
            technicalName: "WebKitDNSPrefetchingEnabled",
            powerUserLabel: "Safari DNS prefetching",
            powerUserDescription: "Safari quietly looks up domain names for links on the page before you click them. Faster browsing, but it tells your DNS server about every link on every page you visit.",
            propellerheadDescription: "When enabled, Safari pre-resolves DNS for links on the current page to speed up navigation. Disabling improves privacy at a small speed cost.",
            category: .networkConnectivity,
            risk: .safe,
            interest: .obscure,
            supportLevel: .hold,
            mechanism: .defaults,
            domain: "com.apple.Safari",
            keyPath: "WebKitDNSPrefetchingEnabled",
            valueType: .bool,
            allowedValues: nil,
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .safari,
            powerUserGrouping: "G045",
            searchAliases: ["dns", "prefetch", "safari speed", "privacy"],
            notes: "Safari's preferences are sandboxed — defaults write com.apple.Safari is blocked by macOS."
        ),

        // S071
        SettingDefinition(
            id: "safari.preloadTopHit",
            displayName: "Preload top hit in background",
            technicalName: "PreloadTopHit",
            powerUserLabel: "Safari preload top hit",
            powerUserDescription: "Safari starts loading its best guess for your search before you even press Enter. Fast, but sends requests to sites you might not intend to visit.",
            propellerheadDescription: "Safari preloads the most likely search/URL suggestion in the background. Disabling prevents speculative network requests.",
            category: .networkConnectivity,
            risk: .safe,
            interest: .common,
            supportLevel: .hold,
            mechanism: .defaults,
            domain: "com.apple.Safari",
            keyPath: "PreloadTopHit",
            valueType: .bool,
            allowedValues: nil,
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .safari,
            powerUserGrouping: "G045",
            searchAliases: ["preload", "top hit", "safari background", "privacy"],
            notes: "Safari's preferences are sandboxed — defaults write com.apple.Safari is blocked by macOS.",
            isInvertedInPowerUserMode: true
        ),

        // S072
        SettingDefinition(
            id: "safari.doNotTrack",
            displayName: "Send Do Not Track header",
            technicalName: "SendDoNotTrackHTTPHeader",
            powerUserLabel: "Do Not Track header",
            powerUserDescription: "Adds a 'please don't track me' header to every web request. Most sites ignore it, but some privacy-respecting ones honor it.",
            propellerheadDescription: "Sends the DNT (Do Not Track) HTTP header with all web requests. Compliance is voluntary — not all websites honor it.",
            category: .networkConnectivity,
            risk: .safe,
            interest: .common,
            supportLevel: .hold,
            mechanism: .defaults,
            domain: "com.apple.Safari",
            keyPath: "SendDoNotTrackHTTPHeader",
            valueType: .bool,
            allowedValues: nil,
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .safari,
            powerUserGrouping: "G045",
            searchAliases: ["do not track", "dnt", "privacy", "tracking"],
            notes: "Safari's preferences are sandboxed — defaults write com.apple.Safari is blocked by macOS."
        ),

        // S074
        SettingDefinition(
            id: "network.captivePortal",
            displayName: "Captive portal detection",
            technicalName: "CaptiveNetworkSupport",
            powerUserLabel: "Captive portal popup",
            powerUserDescription: "When you join hotel or coffee shop Wi-Fi, macOS pops up a login window automatically. Handy for travelers, but it phones home to Apple to check. Disabling stops the popup and the connectivity check.",
            propellerheadDescription: "Controls macOS captive network detection. When enabled, macOS contacts an Apple server to detect captive portals and shows a login sheet. Requires admin password.",
            category: .networkConnectivity,
            risk: .advanced,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .privilegedCommand,
            domain: nil,
            keyPath: nil,
            valueType: .bool,
            allowedValues: nil,
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G047",
            searchAliases: ["captive portal", "hotel wifi", "airport wifi", "login popup", "captive"],
            notes: "Requires admin. Disabling stops the automatic popup on captive networks.",
            isInvertedInPowerUserMode: true,
            macOSDefaultValue: .bool(true)
        ),

        // S069
        SettingDefinition(
            id: "network.disableAirDrop",
            displayName: "Disable AirDrop",
            technicalName: "DisableAirDrop",
            powerUserLabel: "Disable AirDrop",
            powerUserDescription: "Completely disables AirDrop so nobody can send you files wirelessly. Useful on managed machines or if you never use it.",
            propellerheadDescription: "Disables the AirDrop service entirely. No files can be sent or received via AirDrop.",
            category: .networkConnectivity,
            risk: .advanced,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.NetworkBrowser",
            keyPath: "DisableAirDrop",
            valueType: .bool,
            allowedValues: nil,
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G044",
            searchAliases: ["airdrop", "file sharing", "wireless transfer"],
            notes: nil,
            isInvertedInPowerUserMode: true
        ),

        // S073
        SettingDefinition(
            id: "bluetooth.audioQuality",
            displayName: "Bluetooth audio bitpool minimum",
            technicalName: "Apple Bitpool Min (editable)",
            powerUserLabel: "Bluetooth audio quality boost",
            powerUserDescription: "The default Bluetooth audio bitpool is very low, which means compressed, tinny sound. Raising it to 40-80 dramatically improves audio quality for AirPods and other Bluetooth headphones. Restart Bluetooth after changing.",
            propellerheadDescription: "Sets the minimum AAC bitpool for Bluetooth audio encoding. Higher values (40-80) produce better audio quality. Default is around 2. Requires Bluetooth restart to take effect.",
            category: .networkConnectivity,
            risk: .advanced,
            interest: .common,
            supportLevel: .hold,
            mechanism: .defaults,
            domain: "com.apple.BluetoothAudioAgent",
            keyPath: "Apple Bitpool Min (editable)",
            valueType: .int,
            allowedValues: [.int(2), .int(80)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: nil,
            searchAliases: ["bluetooth", "airpods", "audio quality", "aac", "bitpool", "headphones"],
            notes: "Hold: com.apple.BluetoothAudioAgent domain does not exist on macOS 26. Bluetooth audio quality is likely managed differently."
        ),

        // S078
        SettingDefinition(
            id: "network.remoteLogin",
            displayName: "Remote Login (SSH)",
            technicalName: "RemoteLogin",
            powerUserLabel: "SSH access",
            powerUserDescription: "Lets you SSH into this Mac from another computer. Essential for developers and sysadmins, but a potential entry point if left on unnecessarily.",
            propellerheadDescription: "Enables or disables the SSH daemon (Remote Login). When on, other machines can connect via ssh user@this-mac. Requires admin password.",
            category: .networkConnectivity,
            risk: .systemSensitive,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .privilegedCommand,
            domain: nil,
            keyPath: nil,
            valueType: .bool,
            allowedValues: nil,
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G049",
            searchAliases: ["ssh", "remote login", "terminal access", "remote access"],
            notes: "Requires admin.",
            macOSDefaultValue: .bool(false)
        ),

        // S079
        SettingDefinition(
            id: "network.ipv6Wi-Fi",
            displayName: "IPv6 on Wi-Fi",
            technicalName: "IPv6",
            powerUserLabel: "Wi-Fi IPv6",
            powerUserDescription: "Disables IPv6 on your Wi-Fi connection. Some privacy-conscious users prefer this since IPv6 addresses can be used for tracking. Most things still work fine on IPv4 only.",
            propellerheadDescription: "Controls IPv6 on the Wi-Fi interface. Disabling forces IPv4-only operation. May improve privacy on some networks. Requires admin password.",
            category: .networkConnectivity,
            risk: .advanced,
            interest: .obscure,
            supportLevel: .shipping,
            mechanism: .privilegedCommand,
            domain: nil,
            keyPath: nil,
            valueType: .bool,
            allowedValues: nil,
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G049",
            searchAliases: ["ipv6", "wifi", "ip version 6", "network protocol"],
            notes: "Requires admin. Only affects Wi-Fi interface.",
            macOSDefaultValue: .bool(true)
        ),

        // S080
        SettingDefinition(
            id: "network.macAddressEthernet",
            displayName: "Ethernet MAC address",
            technicalName: "ifconfig ether",
            powerUserLabel: "Spoof Ethernet MAC address",
            powerUserDescription: "Changes your Ethernet adapter's hardware address to a random one. Useful for privacy on untrusted networks or bypassing MAC-based access controls. Resets automatically on reboot.",
            propellerheadDescription: "Spoofs the MAC address on the primary Ethernet interface (en0) using ifconfig. The change is temporary and reverts on reboot. Requires admin password.",
            category: .networkConnectivity,
            risk: .advanced,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .privilegedCommand,
            domain: nil,
            keyPath: nil,
            valueType: .string,
            allowedValues: nil,
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G050",
            searchAliases: ["mac address", "spoof", "hardware address", "ethernet", "privacy", "mac spoof"],
            notes: "Requires admin. Temporary — reverts on reboot. Format: XX:XX:XX:XX:XX:XX"
        ),
    ]

    // MARK: - All Grouped Controls

    static let allGroupedControls: [GroupedControlDefinition] = [

        // ---------------------------------------------------------------
        // MARK: Finder (most popular first)
        // ---------------------------------------------------------------

        // G001 — Show hidden files (simple toggle)
        GroupedControlDefinition(
            id: "G001",
            title: "Show hidden files",
            subtitle: "Makes normally hidden files and folders visible in Finder.",
            category: .finder,
            kind: .toggle,
            backingSettingIDs: ["finder.showHiddenFiles"],
            options: nil
        ),

        // G002 — Always show file extensions (simple toggle)
        GroupedControlDefinition(
            id: "G002",
            title: "Always show file extensions",
            subtitle: "Shows .png, .txt, and other file endings in Finder.",
            category: .finder,
            kind: .toggle,
            backingSettingIDs: ["global.showAllExtensions"],
            options: nil
        ),

        // G004 — Finder extras (multi-toggle card)
        GroupedControlDefinition(
            id: "G004",
            title: "Show more Finder details",
            subtitle: "Turns on helpful bars and keeps folders easier to spot.",
            category: .finder,
            kind: .multiToggle,
            backingSettingIDs: [
                "finder.showPathBar",
                "finder.showStatusBar",
                "finder.keepFoldersOnTopInWindow",
                "finder.keepFoldersOnTopOnDesktop",
            ],
            options: nil
        ),

        // G029 — New Finder window opens to (discrete choice)
        GroupedControlDefinition(
            id: "G029",
            title: "Where new Finder windows open",
            subtitle: "Choose the default folder when you open a new Finder window. Recents is the macOS default, but Home or Desktop is usually more useful.",
            category: .finder,
            kind: .discreteChoice,
            backingSettingIDs: ["finder.newWindowTarget"],
            options: [
                MappingOption(
                    label: "Computer",
                    settingValues: [
                        "finder.newWindowTarget": .explicitValue(.string("PfCm")),
                    ]
                ),
                MappingOption(
                    label: "Home",
                    settingValues: [
                        "finder.newWindowTarget": .explicitValue(.string("PfHm")),
                    ]
                ),
                MappingOption(
                    label: "Desktop",
                    settingValues: [
                        "finder.newWindowTarget": .explicitValue(.string("PfDe")),
                    ]
                ),
                MappingOption(
                    label: "Documents",
                    settingValues: [
                        "finder.newWindowTarget": .explicitValue(.string("PfDo")),
                    ]
                ),
                MappingOption(
                    label: "Recents",
                    settingValues: [
                        "finder.newWindowTarget": .explicitValue(.string("PfLo")),
                    ]
                ),
            ]
        ),

        // G003 — Show the full path in Finder windows (simple toggle)
        GroupedControlDefinition(
            id: "G003",
            title: "Show the full path in Finder windows",
            subtitle: "Adds the full folder path to the window title.",
            category: .finder,
            kind: .toggle,
            backingSettingIDs: ["finder.showPosixPathInTitle"],
            options: nil
        ),

        // G019 — Show ~/Library folder (simple toggle)
        GroupedControlDefinition(
            id: "G019",
            title: "Show ~/Library folder",
            subtitle: "Makes the hidden Library folder visible in your home folder. Handy for accessing app data, caches, and preferences.",
            category: .finder,
            kind: .toggle,
            backingSettingIDs: ["finder.showLibraryFolder"],
            options: nil
        ),

        // G028 — Skip empty Trash warning (simple toggle)
        GroupedControlDefinition(
            id: "G028",
            title: "Skip the empty Trash confirmation",
            subtitle: "No more \"Are you sure?\" when emptying the Trash.",
            category: .finder,
            kind: .toggle,
            backingSettingIDs: ["finder.warnOnEmptyTrash"],
            options: nil
        ),

        // G021 — Skip extension warning (simple toggle)
        GroupedControlDefinition(
            id: "G021",
            title: "Skip the extension change warning",
            subtitle: "No more \"Are you sure?\" when you rename a file and change its extension.",
            category: .finder,
            kind: .toggle,
            backingSettingIDs: ["finder.disableExtensionChangeWarning"],
            options: nil
        ),

        // G020 — Save to this Mac (simple toggle)
        GroupedControlDefinition(
            id: "G020",
            title: "Save to this Mac by default",
            subtitle: "New documents start on your Mac instead of iCloud Drive when you hit Save.",
            category: .finder,
            kind: .toggle,
            backingSettingIDs: ["global.saveToLocalDisk"],
            options: nil
        ),

        // G027 — Allow quitting Finder (simple toggle)
        GroupedControlDefinition(
            id: "G027",
            title: "Allow quitting Finder",
            subtitle: "Adds a Quit option to the Finder menu. Handy when Finder is stuck or hogging resources.",
            category: .finder,
            kind: .toggle,
            backingSettingIDs: ["finder.quitMenuItem"],
            options: nil
        ),

        // G024 — Stop .DS_Store clutter (multi-toggle)
        GroupedControlDefinition(
            id: "G024",
            title: "Stop .DS_Store clutter",
            subtitle: "Prevents Finder from leaving invisible .DS_Store files on network shares and USB drives. Everyone else on the network will thank you.",
            category: .finder,
            kind: .multiToggle,
            backingSettingIDs: [
                "desktopservices.dontWriteNetworkDS",
                "desktopservices.dontWriteUSBDS",
            ],
            options: nil
        ),

        // G026 — Folder spring-loading speed (discrete choice)
        GroupedControlDefinition(
            id: "G026",
            title: "How fast folders pop open when dragging",
            subtitle: "When you drag a file over a folder in Finder, the folder springs open after a short delay. This controls how short.",
            category: .finder,
            kind: .discreteChoice,
            backingSettingIDs: ["finder.springLoadingDelay"],
            options: [
                MappingOption(
                    label: "Default",
                    settingValues: [
                        "finder.springLoadingDelay": .systemDefault,
                    ]
                ),
                MappingOption(
                    label: "Faster",
                    settingValues: [
                        "finder.springLoadingDelay": .explicitValue(.double(0.25)),
                    ]
                ),
                MappingOption(
                    label: "Instant",
                    settingValues: [
                        "finder.springLoadingDelay": .explicitValue(.double(0.0)),
                    ]
                ),
            ]
        ),

        // ---------------------------------------------------------------
        // MARK: Interface (most popular first)
        // ---------------------------------------------------------------

        // G030 — Dock icon size (discrete choice)
        GroupedControlDefinition(
            id: "G030",
            title: "Dock icon size",
            subtitle: "How large the icons in your Dock are. Smaller gives you more room; larger is easier to see.",
            category: .interface,
            kind: .discreteChoice,
            backingSettingIDs: ["dock.tileSize"],
            options: [
                MappingOption(
                    label: "Small",
                    settingValues: [
                        "dock.tileSize": .explicitValue(.int(36)),
                    ]
                ),
                MappingOption(
                    label: "Medium",
                    settingValues: [
                        "dock.tileSize": .explicitValue(.int(48)),
                    ]
                ),
                MappingOption(
                    label: "Large",
                    settingValues: [
                        "dock.tileSize": .explicitValue(.int(64)),
                    ]
                ),
                MappingOption(
                    label: "Default",
                    settingValues: [
                        "dock.tileSize": .systemDefault,
                    ]
                ),
            ]
        ),

        // G031 — Dock position (discrete choice)
        GroupedControlDefinition(
            id: "G031",
            title: "Dock position",
            subtitle: "Move the Dock to the bottom, left, or right edge of your screen.",
            category: .interface,
            kind: .discreteChoice,
            backingSettingIDs: ["dock.orientation"],
            options: [
                MappingOption(
                    label: "Bottom",
                    settingValues: [
                        "dock.orientation": .explicitValue(.string("bottom")),
                    ]
                ),
                MappingOption(
                    label: "Left",
                    settingValues: [
                        "dock.orientation": .explicitValue(.string("left")),
                    ]
                ),
                MappingOption(
                    label: "Right",
                    settingValues: [
                        "dock.orientation": .explicitValue(.string("right")),
                    ]
                ),
            ]
        ),

        // G005 — Dock responsiveness (enum with mapping)
        GroupedControlDefinition(
            id: "G005",
            title: "Make the Dock feel faster",
            subtitle: "Cuts the delay and speeds up Dock animation.",
            category: .interface,
            kind: .discreteChoice,
            backingSettingIDs: [
                "dock.autohideDelay",
                "dock.autohideAnimationSpeed",
            ],
            options: [
                MappingOption(
                    label: "Default",
                    settingValues: [
                        "dock.autohideDelay": .systemDefault,
                        "dock.autohideAnimationSpeed": .systemDefault,
                    ]
                ),
                MappingOption(
                    label: "Faster",
                    settingValues: [
                        "dock.autohideDelay": .explicitValue(.double(0.1)),
                        "dock.autohideAnimationSpeed": .explicitValue(.double(0.25)),
                    ]
                ),
                MappingOption(
                    label: "Instant",
                    settingValues: [
                        "dock.autohideDelay": .explicitValue(.double(0.0)),
                        "dock.autohideAnimationSpeed": .explicitValue(.double(0.12)),
                    ]
                ),
            ]
        ),

        // G022 — Hide recent apps from Dock (simple toggle)
        GroupedControlDefinition(
            id: "G022",
            title: "Hide recent apps from the Dock",
            subtitle: "Removes the recent applications section from the right end of the Dock.",
            category: .interface,
            kind: .toggle,
            backingSettingIDs: ["dock.showRecents"],
            options: nil
        ),

        // G032 — Minimize animation (discrete choice)
        GroupedControlDefinition(
            id: "G032",
            title: "Window minimize animation",
            subtitle: "The Genie effect is the classic swoopy animation. Scale is faster and more subtle.",
            category: .interface,
            kind: .discreteChoice,
            backingSettingIDs: ["dock.mineffect"],
            options: [
                MappingOption(
                    label: "Genie",
                    settingValues: [
                        "dock.mineffect": .explicitValue(.string("genie")),
                    ]
                ),
                MappingOption(
                    label: "Scale",
                    settingValues: [
                        "dock.mineffect": .explicitValue(.string("scale")),
                    ]
                ),
            ]
        ),

        // G006 — Minimize into app icon (simple toggle)
        GroupedControlDefinition(
            id: "G006",
            title: "Tuck windows into the app icon",
            subtitle: "Minimizes windows into the app's Dock icon instead of scattering thumbnails.",
            category: .interface,
            kind: .toggle,
            backingSettingIDs: ["dock.minimizeToApplication"],
            options: nil
        ),

        // G023 — Scroll bars (discrete choice)
        GroupedControlDefinition(
            id: "G023",
            title: "Scroll bar visibility",
            subtitle: "Choose whether scroll bars are always visible, or only appear when you scroll.",
            category: .interface,
            kind: .discreteChoice,
            backingSettingIDs: ["global.showScrollBars"],
            options: [
                MappingOption(
                    label: "Automatic",
                    settingValues: [
                        "global.showScrollBars": .explicitValue(.string("Automatic")),
                    ]
                ),
                MappingOption(
                    label: "Always",
                    settingValues: [
                        "global.showScrollBars": .explicitValue(.string("Always")),
                    ]
                ),
                MappingOption(
                    label: "When Scrolling",
                    settingValues: [
                        "global.showScrollBars": .explicitValue(.string("WhenScrolling")),
                    ]
                ),
            ]
        ),

        // G033 — Title bar double-click (discrete choice)
        GroupedControlDefinition(
            id: "G033",
            title: "Title bar double-click",
            subtitle: "What happens when you double-click a window's title bar.",
            category: .interface,
            kind: .discreteChoice,
            backingSettingIDs: ["global.titleBarDoubleClick"],
            options: [
                MappingOption(
                    label: "Maximize",
                    settingValues: [
                        "global.titleBarDoubleClick": .explicitValue(.string("Maximize")),
                    ]
                ),
                MappingOption(
                    label: "Minimize",
                    settingValues: [
                        "global.titleBarDoubleClick": .explicitValue(.string("Minimize")),
                    ]
                ),
                MappingOption(
                    label: "Nothing",
                    settingValues: [
                        "global.titleBarDoubleClick": .explicitValue(.string("None")),
                    ]
                ),
            ]
        ),

        // G008 — Save dialogs: expanded by default (multi-toggle card)
        GroupedControlDefinition(
            id: "G008",
            title: "Open Save dialogs fully expanded",
            subtitle: "Starts Save windows in their full version.",
            category: .interface,
            kind: .multiToggle,
            backingSettingIDs: [
                "global.savePanelExpanded",
                "global.printPanelExpanded",
            ],
            options: nil
        ),

        // G007 — Show only open apps in Dock (simple toggle)
        GroupedControlDefinition(
            id: "G007",
            title: "Show only open apps in the Dock",
            subtitle: "Keeps the Dock focused on what is currently running.",
            category: .interface,
            kind: .toggle,
            backingSettingIDs: ["dock.staticOnly"],
            options: nil
        ),

        // G025 — Plain text TextEdit (simple toggle)
        GroupedControlDefinition(
            id: "G025",
            title: "Open TextEdit in plain text mode",
            subtitle: "New TextEdit documents start as plain text instead of rich text. Better for quick notes and code.",
            category: .interface,
            kind: .toggle,
            backingSettingIDs: ["textEdit.plainTextDefault"],
            options: nil
        ),

        // G041 — Help viewer non-floating (simple toggle)
        GroupedControlDefinition(
            id: "G041",
            title: "Stop Help windows from floating",
            subtitle: "The Help viewer normally stays on top of everything. This makes it behave like a regular window.",
            category: .interface,
            kind: .toggle,
            backingSettingIDs: ["helpViewer.devMode"],
            options: nil
        ),

        // G053 — Disable App Nap (simple toggle)
        GroupedControlDefinition(
            id: "G053",
            title: "Disable App Nap",
            subtitle: "macOS secretly pauses background apps to save energy. Disable this if background tasks keep stalling or you want full performance at all times.",
            category: .interface,
            kind: .toggle,
            backingSettingIDs: ["global.appNap"],
            options: nil
        ),

        // ---------------------------------------------------------------
        // MARK: Keyboard & Input (most popular first)
        // ---------------------------------------------------------------

        // G010 — Use key repeat instead of accent popup (simple toggle)
        GroupedControlDefinition(
            id: "G010",
            title: "Use key repeat instead of the accent popup",
            subtitle: "Holding a key repeats it instead of opening the accent picker.",
            category: .keyboardInput,
            kind: .toggle,
            backingSettingIDs: ["global.pressAndHoldEnabled"],
            options: nil
        ),

        // G009 — Typing feel (enum with mapping)
        GroupedControlDefinition(
            id: "G009",
            title: "Make held keys repeat faster",
            subtitle: "Changes how fast a key starts repeating and how quickly it repeats.",
            category: .keyboardInput,
            kind: .discreteChoice,
            backingSettingIDs: [
                "global.keyRepeat",
                "global.initialKeyRepeat",
            ],
            options: [
                MappingOption(
                    label: "Default",
                    settingValues: [
                        "global.keyRepeat": .systemDefault,
                        "global.initialKeyRepeat": .systemDefault,
                    ]
                ),
                MappingOption(
                    label: "Fast",
                    settingValues: [
                        "global.keyRepeat": .explicitValue(.int(2)),
                        "global.initialKeyRepeat": .explicitValue(.int(15)),
                    ]
                ),
                MappingOption(
                    label: "Ridiculous",
                    settingValues: [
                        "global.keyRepeat": .explicitValue(.int(1)),
                        "global.initialKeyRepeat": .explicitValue(.int(10)),
                    ]
                ),
            ]
        ),

        // G011 — Cleaner automatic typing (multi-toggle card)
        GroupedControlDefinition(
            id: "G011",
            title: "Turn off typing helpers you do not want",
            subtitle: "Disables automatic quote changes, dash changes, capitalization, spelling correction, and period shortcuts.",
            category: .keyboardInput,
            kind: .multiToggle,
            backingSettingIDs: [
                "global.smartQuotes",
                "global.smartDashes",
                "global.autoCapitalization",
                "global.autoSpellingCorrection",
                "global.periodSubstitution",
            ],
            options: nil
        ),

        // G034 — Full keyboard access (simple toggle)
        GroupedControlDefinition(
            id: "G034",
            title: "Tab through all controls",
            subtitle: "Use the Tab key to move between all buttons and fields in dialogs, not just text boxes.",
            category: .keyboardInput,
            kind: .toggle,
            backingSettingIDs: ["global.fullKeyboardAccess"],
            options: nil
        ),

        // G051 — Mouse acceleration (slider)
        GroupedControlDefinition(
            id: "G051",
            title: "Mouse Acceleration",
            subtitle: "macOS adds acceleration to mouse movement by default. Set to -1 for raw, unaccelerated input — essential for gaming and precision design work. Not available in System Settings.",
            category: .keyboardInput,
            kind: .multiControl,
            backingSettingIDs: ["mouse.acceleration"],
            options: nil
        ),

        // ---------------------------------------------------------------
        // MARK: Windows & Spaces (most popular first)
        // ---------------------------------------------------------------

        // G012 — Keep Spaces in a fixed order (simple toggle)
        GroupedControlDefinition(
            id: "G012",
            title: "Keep Spaces in a fixed order",
            subtitle: "Stops macOS from reordering desktop spaces based on recent use.",
            category: .windowsSpaces,
            kind: .toggle,
            backingSettingIDs: ["dock.mruSpaces"],
            options: nil
        ),

        // G035 — Group windows by app (simple toggle)
        GroupedControlDefinition(
            id: "G035",
            title: "Group windows by app in Mission Control",
            subtitle: "Stack windows from the same app together in Mission Control instead of scattering them.",
            category: .windowsSpaces,
            kind: .toggle,
            backingSettingIDs: ["dock.exposeGroupApps"],
            options: nil
        ),

        // G013 — Mission Control speed (enum with mapping)
        GroupedControlDefinition(
            id: "G013",
            title: "Speed up Mission Control",
            subtitle: "Makes Mission Control feel more immediate.",
            category: .windowsSpaces,
            kind: .discreteChoice,
            backingSettingIDs: ["dock.exposeAnimationDuration"],
            options: [
                MappingOption(
                    label: "Default",
                    settingValues: [
                        "dock.exposeAnimationDuration": .systemDefault,
                    ]
                ),
                MappingOption(
                    label: "Faster",
                    settingValues: [
                        "dock.exposeAnimationDuration": .explicitValue(.double(0.15)),
                    ]
                ),
                MappingOption(
                    label: "Instant",
                    settingValues: [
                        "dock.exposeAnimationDuration": .explicitValue(.double(0.10)),
                    ]
                ),
            ]
        ),

        // G036 removed — spans-displays no longer works on macOS 26

        // ---------------------------------------------------------------
        // MARK: Screenshots
        // ---------------------------------------------------------------

        // G014 — Screenshots: defaults (multi-control card)
        GroupedControlDefinition(
            id: "G014",
            title: "Tidy up screenshots",
            subtitle: "Change where screenshots go, what format they use, and whether window shadows are included.",
            category: .screenshots,
            kind: .multiControl,
            backingSettingIDs: [
                "screencapture.location",
                "screencapture.format",
                "screencapture.disableShadow",
                "screencapture.showThumbnail",
                "screencapture.name",
            ],
            options: nil
        ),

        // ---------------------------------------------------------------
        // MARK: Safari & Developer (most popular first)
        // ---------------------------------------------------------------

        // G015 — Safari dev basics (multi-toggle card)
        GroupedControlDefinition(
            id: "G015",
            title: "Show the full web address and turn on developer tools",
            subtitle: "Makes Safari more explicit and more useful for web work.",
            category: .safariDeveloper,
            kind: .multiToggle,
            backingSettingIDs: [
                "safari.showFullURL",
                "safari.includeDevelopMenu",
            ],
            options: nil
        ),

        // G037 — Stop auto-opening downloads (simple toggle)
        GroupedControlDefinition(
            id: "G037",
            title: "Stop Safari from auto-opening downloads",
            subtitle: "Prevents Safari from automatically opening DMGs, PDFs, and zip files after downloading them.",
            category: .safariDeveloper,
            kind: .toggle,
            backingSettingIDs: ["safari.autoOpenSafeDownloads"],
            options: nil
        ),

        // G038 — Show link URLs in Safari (simple toggle)
        GroupedControlDefinition(
            id: "G038",
            title: "Show link URLs when hovering in Safari",
            subtitle: "Adds a status bar at the bottom of Safari showing where links actually go before you click them.",
            category: .safariDeveloper,
            kind: .toggle,
            backingSettingIDs: ["safari.showStatusBar"],
            options: nil
        ),

        // ---------------------------------------------------------------
        // MARK: Accessibility & Visual
        // ---------------------------------------------------------------

        // G016 — Increase contrast (simple toggle, was discrete choice before reduceTransparency was removed)
        GroupedControlDefinition(
            id: "G016",
            title: "Increase contrast",
            subtitle: "Makes interface outlines and separators stronger for a crisper, clearer look.",
            category: .accessibilityVisual,
            kind: .toggle,
            backingSettingIDs: [
                "accessibility.increaseContrast",
            ],
            options: nil
        ),

        // G052 — Font smoothing (simple toggle)
        GroupedControlDefinition(
            id: "G052",
            title: "Font Smoothing (non-Retina)",
            subtitle: "Apple removed the font smoothing option in Mojave. If text looks thin or spidery on an external non-Retina monitor, enable this to bring back subpixel antialiasing. No effect on Retina screens.",
            category: .accessibilityVisual,
            kind: .toggle,
            backingSettingIDs: ["display.fontSmoothing"],
            options: nil
        ),

        // ---------------------------------------------------------------
        // MARK: Menu Bar (most popular first)
        // ---------------------------------------------------------------

        // G039 — 24-hour clock (simple toggle)
        GroupedControlDefinition(
            id: "G039",
            title: "24-hour clock",
            subtitle: "Use 24-hour time in the menu bar instead of 12-hour with AM/PM.",
            category: .menuBarStatus,
            kind: .toggle,
            backingSettingIDs: ["menu.clock24Hour"],
            options: nil
        ),

        // G017 — Menu bar basics (multi-toggle card)
        GroupedControlDefinition(
            id: "G017",
            title: "Show useful status details in the menu bar",
            subtitle: "Adds helpful always-visible status information where supported.",
            category: .menuBarStatus,
            kind: .multiToggle,
            backingSettingIDs: [
                "menu.clockFlashDateSeparators",
            ],
            options: nil
        ),

        // G042 — Show date in menu bar (discrete choice)
        GroupedControlDefinition(
            id: "G042",
            title: "Date in the menu bar",
            subtitle: "Choose when the date appears next to the clock.",
            category: .menuBarStatus,
            kind: .discreteChoice,
            backingSettingIDs: ["menu.clockShowDate"],
            options: [
                MappingOption(
                    label: "Always",
                    settingValues: [
                        "menu.clockShowDate": .explicitValue(.int(1)),
                    ]
                ),
                MappingOption(
                    label: "When Space Allows",
                    settingValues: [
                        "menu.clockShowDate": .explicitValue(.int(0)),
                    ]
                ),
                MappingOption(
                    label: "Never",
                    settingValues: [
                        "menu.clockShowDate": .explicitValue(.int(2)),
                    ]
                ),
            ]
        ),

        // ---------------------------------------------------------------
        // MARK: Security & Privacy (most popular first)
        // ---------------------------------------------------------------

        // G018 — Security prompt behavior (simple toggle)
        GroupedControlDefinition(
            id: "G018",
            title: "Skip app quarantine prompts",
            subtitle: "Turns off the quarantine flag used for \"this app was downloaded from the internet\" warnings.",
            category: .securityPrivacy,
            kind: .toggle,
            backingSettingIDs: ["launchServices.quarantine"],
            options: nil
        ),

        // G040 — Crash reporter detail (discrete choice)
        GroupedControlDefinition(
            id: "G040",
            title: "Detailed crash reports",
            subtitle: "When an app crashes, see the full technical report instead of just \"unexpectedly quit\".",
            category: .securityPrivacy,
            kind: .discreteChoice,
            backingSettingIDs: ["crashReporter.dialogType"],
            options: [
                MappingOption(
                    label: "Basic",
                    settingValues: [
                        "crashReporter.dialogType": .explicitValue(.string("crashreport")),
                    ]
                ),
                MappingOption(
                    label: "Developer",
                    settingValues: [
                        "crashReporter.dialogType": .explicitValue(.string("developer")),
                    ]
                ),
                MappingOption(
                    label: "Silent",
                    settingValues: [
                        "crashReporter.dialogType": .explicitValue(.string("none")),
                    ]
                ),
            ]
        ),

        // ---------------------------------------------------------------
        // MARK: Network & Connectivity (most popular first)
        // ---------------------------------------------------------------

        // G048 — Firewall (multi-toggle)
        GroupedControlDefinition(
            id: "G048",
            title: "Firewall",
            subtitle: "The built-in macOS firewall controls which apps can accept incoming connections. Stealth mode makes your Mac invisible to pings and port scans. Block-all is the nuclear option. Admin required.",
            category: .networkConnectivity,
            kind: .multiToggle,
            backingSettingIDs: ["network.firewallEnabled", "network.firewallStealth", "network.firewallBlockAll"],
            options: nil
        ),

        // G043 removed — backed S067/S068 which were duplicates of S046/S047

        // G045 — Safari Network Privacy (multi-toggle)
        GroupedControlDefinition(
            id: "G045",
            title: "Safari Network Privacy",
            subtitle: "Control what Safari does in the background — DNS prefetching, preloading, and tracking headers.",
            category: .networkConnectivity,
            kind: .multiToggle,
            backingSettingIDs: ["safari.dnsPrefetching", "safari.preloadTopHit", "safari.doNotTrack"],
            options: nil
        ),

        // G047 — Captive Portal Detection (simple toggle)
        GroupedControlDefinition(
            id: "G047",
            title: "Captive Portal Detection",
            subtitle: "When you join Wi-Fi at a hotel or coffee shop, macOS pops up a login window by checking in with Apple. Disabling stops both the popup and the connectivity check. Admin required.",
            category: .networkConnectivity,
            kind: .toggle,
            backingSettingIDs: ["network.captivePortal"],
            options: nil
        ),

        // G044 — AirDrop (simple toggle)
        GroupedControlDefinition(
            id: "G044",
            title: "AirDrop",
            subtitle: "Turn off AirDrop entirely. No one can send you files, and you won't see nearby Macs. Good for managed or security-sensitive machines.",
            category: .networkConnectivity,
            kind: .toggle,
            backingSettingIDs: ["network.disableAirDrop"],
            options: nil
        ),

        // G046 removed — BluetoothAudioAgent domain doesn't exist on macOS 26

        // G049 — Remote Access & Protocols (multi-toggle)
        GroupedControlDefinition(
            id: "G049",
            title: "Remote Access & Protocols",
            subtitle: "Enable SSH to access your Mac remotely from Terminal. Disable IPv6 on Wi-Fi for privacy — most things work fine on IPv4 alone. Admin required.",
            category: .networkConnectivity,
            kind: .multiToggle,
            backingSettingIDs: ["network.remoteLogin", "network.ipv6Wi-Fi"],
            options: nil
        ),

        // G050 — MAC Address Spoofing
        GroupedControlDefinition(
            id: "G050",
            title: "MAC Address Spoofing",
            subtitle: "Spoof your Ethernet adapter's hardware address for privacy or to bypass MAC-based access controls. Changes are temporary and revert on reboot. Click Randomize for a valid random address. Admin required.",
            category: .networkConnectivity,
            kind: .multiControl,
            backingSettingIDs: ["network.macAddressEthernet"],
            options: nil
        ),
    ]

    // MARK: - All Presets

    static let allPresets: [PresetDefinition] = [

        // P001 — Snappy Mac
        PresetDefinition(
            id: "P001",
            name: "Snappy Mac",
            description: "Make the system feel more responsive.",
            items: [
                PresetItem(settingID: "dock.autohideDelay", targetState: .explicitValue(.double(0.0))),
                PresetItem(settingID: "dock.autohideAnimationSpeed", targetState: .explicitValue(.double(0.12))),
                PresetItem(settingID: "dock.exposeAnimationDuration", targetState: .explicitValue(.double(0.10))),
                PresetItem(settingID: "global.savePanelExpanded", targetState: .explicitValue(.bool(true))),
                PresetItem(settingID: "global.printPanelExpanded", targetState: .explicitValue(.bool(true))),
                PresetItem(settingID: "global.keyRepeat", targetState: .explicitValue(.int(2))),
                PresetItem(settingID: "global.initialKeyRepeat", targetState: .explicitValue(.int(15))),
            ],
            riskSummary: .safe
        ),

        // P002 — Developer Desk
        PresetDefinition(
            id: "P002",
            name: "Developer Desk",
            description: "Turn on the practical stuff technical users usually want.",
            items: [
                PresetItem(settingID: "finder.showHiddenFiles", targetState: .explicitValue(.bool(true))),
                PresetItem(settingID: "global.showAllExtensions", targetState: .explicitValue(.bool(true))),
                PresetItem(settingID: "finder.showPosixPathInTitle", targetState: .explicitValue(.bool(true))),
                PresetItem(settingID: "finder.showPathBar", targetState: .explicitValue(.bool(true))),
                PresetItem(settingID: "finder.showStatusBar", targetState: .explicitValue(.bool(true))),
                PresetItem(settingID: "finder.keepFoldersOnTopInWindow", targetState: .explicitValue(.bool(true))),
                PresetItem(settingID: "global.pressAndHoldEnabled", targetState: .explicitValue(.bool(false))),
                PresetItem(settingID: "global.smartQuotes", targetState: .explicitValue(.bool(false))),
                PresetItem(settingID: "global.smartDashes", targetState: .explicitValue(.bool(false))),
                PresetItem(settingID: "global.autoCapitalization", targetState: .explicitValue(.bool(false))),
                PresetItem(settingID: "global.autoSpellingCorrection", targetState: .explicitValue(.bool(false))),
                PresetItem(settingID: "finder.showLibraryFolder", targetState: .explicitValue(.bool(true))),
                PresetItem(settingID: "global.saveToLocalDisk", targetState: .explicitValue(.bool(false))),
                PresetItem(settingID: "finder.disableExtensionChangeWarning", targetState: .explicitValue(.bool(false))),
                PresetItem(settingID: "desktopservices.dontWriteNetworkDS", targetState: .explicitValue(.bool(true))),
                PresetItem(settingID: "desktopservices.dontWriteUSBDS", targetState: .explicitValue(.bool(true))),
                PresetItem(settingID: "textEdit.plainTextDefault", targetState: .explicitValue(.bool(false))),
            ],
            riskSummary: .safe
        ),

        // P003 — Clean Screenshots
        PresetDefinition(
            id: "P003",
            name: "Clean Screenshots",
            description: "Make screenshots cleaner and easier to manage.",
            items: [
                PresetItem(settingID: "screencapture.format", targetState: .explicitValue(.string("png"))),
                PresetItem(settingID: "screencapture.disableShadow", targetState: .explicitValue(.bool(true))),
            ],
            riskSummary: .safe
        ),

        // P004 — Solid UI
        PresetDefinition(
            id: "P004",
            name: "Solid UI",
            description: "Sharpen interface outlines and increase contrast for a crisper look.",
            items: [
                PresetItem(settingID: "accessibility.increaseContrast", targetState: .explicitValue(.bool(true))),
            ],
            riskSummary: .safe
        ),

        // P005 — Minimal Fuss
        PresetDefinition(
            id: "P005",
            name: "Minimal Fuss",
            description: "Cut the interface clutter and automatic behavior.",
            items: [
                PresetItem(settingID: "dock.minimizeToApplication", targetState: .explicitValue(.bool(true))),
                PresetItem(settingID: "dock.mruSpaces", targetState: .explicitValue(.bool(false))),
                PresetItem(settingID: "global.smartQuotes", targetState: .explicitValue(.bool(false))),
                PresetItem(settingID: "global.smartDashes", targetState: .explicitValue(.bool(false))),
                PresetItem(settingID: "global.periodSubstitution", targetState: .explicitValue(.bool(false))),
                PresetItem(settingID: "dock.showRecents", targetState: .explicitValue(.bool(false))),
                PresetItem(settingID: "finder.disableExtensionChangeWarning", targetState: .explicitValue(.bool(false))),
            ],
            riskSummary: .safe
        ),
    ]
}

// swiftlint:enable file_length type_body_length
