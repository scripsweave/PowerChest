import Foundation

// swiftlint:disable file_length type_body_length

/// Static catalog data for PowerChest Settings Catalog v1.
/// Generated from specification 02 — powerchest_settings_catalog_v_1.md
///
/// Contains 159 settings, 75 grouped controls, and 5 presets (P001-P005).
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

        // S084
        SettingDefinition(
            id: "finder.columnAutoSizing",
            displayName: "Finder column auto-sizing",
            technicalName: "_FXEnableColumnAutoSizing",
            powerUserLabel: "Auto-resize Finder columns to fit filenames",
            powerUserDescription: "Finder's column view automatically widens columns so long filenames aren't cut off. Fixes the Tahoe bug where the horizontal scrollbar covers the column resize handles.",
            propellerheadDescription: "Forces Finder to dynamically resize columns in Column View to fit the longest filename. Workaround for the Liquid Glass scrollbar occlusion bug.",
            category: .finder,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.finder",
            keyPath: "_FXEnableColumnAutoSizing",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 26, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: "G054",
            searchAliases: ["column view", "auto size", "column width", "truncated filenames", "liquid glass bug"],
            notes: "Tahoe-specific. Works around the scrollbar-over-resize-handle bug in Column View."
        ),

        // S085
        SettingDefinition(
            id: "finder.createDesktop",
            displayName: "Show desktop icons",
            technicalName: "CreateDesktop",
            powerUserLabel: "Hide all desktop icons",
            powerUserDescription: "Stops Finder from drawing anything on the desktop. No more accidentally dismissing all your windows when you click an empty spot. Your files are still in ~/Desktop — they just won't clutter the screen.",
            propellerheadDescription: "Prevents Finder from rendering desktop icons. Files remain in ~/Desktop but are not displayed. Also prevents the click-to-reveal-desktop behavior.",
            category: .finder,
            risk: .advanced,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.finder",
            keyPath: "CreateDesktop",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: "G055",
            searchAliases: ["desktop icons", "hide desktop", "clean desktop", "click wallpaper", "reveal desktop"],
            notes: "Raw value false = desktop hidden. Power User toggle is inverted: ON = hide desktop = write false.",
            isInvertedInPowerUserMode: true
        ),

        // S136
        SettingDefinition(
            id: "finder.autoRemoveOldTrash",
            displayName: "Auto-remove old Trash items",
            technicalName: "FXRemoveOldTrashItems",
            powerUserLabel: "Auto-empty Trash after 30 days",
            powerUserDescription: "Automatically deletes items that have been in the Trash for more than 30 days.",
            propellerheadDescription: "Enables automatic removal of Trash items older than 30 days.",
            category: .finder,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.finder",
            keyPath: "FXRemoveOldTrashItems",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: "G072",
            searchAliases: ["auto empty trash", "old trash", "30 day trash", "auto delete"],
            notes: "Absent = false."
        ),

        // S137
        SettingDefinition(
            id: "finder.showExternalDrives",
            displayName: "Show external drives on desktop",
            technicalName: "ShowExternalHardDrivesOnDesktop",
            powerUserLabel: "External drives on desktop",
            powerUserDescription: "Shows icons for external hard drives on the desktop.",
            propellerheadDescription: "Controls whether external hard drive icons appear on the desktop.",
            category: .finder,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.finder",
            keyPath: "ShowExternalHardDrivesOnDesktop",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: "G073",
            searchAliases: ["external drives", "desktop drives", "hard drives desktop"],
            notes: nil
        ),

        // S138
        SettingDefinition(
            id: "finder.showInternalDrives",
            displayName: "Show hard drives on desktop",
            technicalName: "ShowHardDrivesOnDesktop",
            powerUserLabel: "Internal drives on desktop",
            powerUserDescription: "Shows icons for internal hard drives (Macintosh HD) on the desktop.",
            propellerheadDescription: "Controls whether internal hard drive icons appear on the desktop.",
            category: .finder,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.finder",
            keyPath: "ShowHardDrivesOnDesktop",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: "G073",
            searchAliases: ["hard drives", "internal drives", "macintosh hd desktop"],
            notes: nil
        ),

        // S139
        SettingDefinition(
            id: "finder.showServers",
            displayName: "Show servers on desktop",
            technicalName: "ShowMountedServersOnDesktop",
            powerUserLabel: "Network servers on desktop",
            powerUserDescription: "Shows icons for mounted network servers on the desktop.",
            propellerheadDescription: "Controls whether mounted server icons appear on the desktop.",
            category: .finder,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.finder",
            keyPath: "ShowMountedServersOnDesktop",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: "G073",
            searchAliases: ["servers", "network drives", "mounted servers desktop"],
            notes: "Absent = false."
        ),

        // S140
        SettingDefinition(
            id: "finder.showRemovableMedia",
            displayName: "Show removable media on desktop",
            technicalName: "ShowRemovableMediaOnDesktop",
            powerUserLabel: "Removable media on desktop",
            powerUserDescription: "Shows icons for USB drives, SD cards, and other removable media on the desktop.",
            propellerheadDescription: "Controls whether removable media icons appear on the desktop.",
            category: .finder,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.finder",
            keyPath: "ShowRemovableMediaOnDesktop",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: "G073",
            searchAliases: ["removable media", "usb drives", "sd card desktop"],
            notes: nil
        ),

        // S148
        SettingDefinition(
            id: "finder.openFoldersInTabs",
            displayName: "Open folders in tabs",
            technicalName: "FinderSpawnTab",
            powerUserLabel: "Open folders in tabs",
            powerUserDescription: "When you Cmd-double-click a folder, it opens as a new tab instead of a new window.",
            propellerheadDescription: "Controls whether Cmd-double-clicking a folder opens a new tab or a new window in Finder.",
            category: .finder,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.finder",
            keyPath: "FinderSpawnTab",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: "G004",
            searchAliases: ["finder tabs", "open in tab", "folder tab", "new tab"],
            notes: "Absent = true (tabs). False = new window."
        ),

        // S149
        SettingDefinition(
            id: "global.toolbarTitleRolloverDelay",
            displayName: "Toolbar title rollover delay",
            technicalName: "NSToolbarTitleViewRolloverDelay",
            powerUserLabel: "Toolbar icon rollover delay",
            powerUserDescription: "How long you need to hover over a Finder window title before the folder icon appears. Set to 0 for instant.",
            propellerheadDescription: "Controls the delay before the document-proxy icon appears when hovering over a toolbar title.",
            category: .finder,
            risk: .safe,
            interest: .obscure,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "NSToolbarTitleViewRolloverDelay",
            valueType: .double,
            allowedValues: nil,
            defaultValueStrategy: .absentIsSystemDefault,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: nil,
            searchAliases: ["toolbar rollover", "proxy icon", "title bar icon delay", "folder icon delay"],
            notes: "Default 0.5 seconds. 0 = instant. Delete key to restore default."
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

        // S110
        SettingDefinition(
            id: "dock.magnification",
            displayName: "Dock magnification",
            technicalName: "magnification",
            powerUserLabel: "Magnify Dock icons on hover",
            powerUserDescription: "Icons in the Dock grow larger when you hover over them.",
            propellerheadDescription: "Enables the Dock icon magnification effect on hover.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dock",
            keyPath: "magnification",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: "G066",
            searchAliases: ["magnification", "dock hover", "dock enlarge", "dock zoom"],
            notes: "Pair with largesize for the magnified size."
        ),

        // S111
        SettingDefinition(
            id: "dock.largeSize",
            displayName: "Dock magnification size",
            technicalName: "largesize",
            powerUserLabel: "Magnified icon size",
            powerUserDescription: "How large Dock icons grow when magnification is on.",
            propellerheadDescription: "Sets the magnified Dock icon size in pixels. Ranges from 16 to 128.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dock",
            keyPath: "largesize",
            valueType: .int,
            allowedValues: nil,
            defaultValueStrategy: .absentIsSystemDefault,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: "G066",
            searchAliases: ["magnification size", "large icon size", "dock hover size"],
            notes: "Range 16-128. Only relevant when magnification is enabled."
        ),

        // S112
        SettingDefinition(
            id: "dock.launchAnimation",
            displayName: "Dock launch animation",
            technicalName: "launchanim",
            powerUserLabel: "Bouncing launch animation",
            powerUserDescription: "The bouncing icon animation when you open an app from the Dock.",
            propellerheadDescription: "Controls whether Dock icons bounce when launching applications.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dock",
            keyPath: "launchanim",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: "G066",
            searchAliases: ["launch animation", "bouncing icon", "dock bounce", "app launch"],
            notes: "Absent = true. Set to false to disable bouncing."
        ),

        // S113
        SettingDefinition(
            id: "dock.showProcessIndicators",
            displayName: "Show process indicator dots",
            technicalName: "show-process-indicators",
            powerUserLabel: "Show dots under open apps",
            powerUserDescription: "Small dots under Dock icons show which apps are currently running.",
            propellerheadDescription: "Controls whether running application indicator dots are shown in the Dock.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dock",
            keyPath: "show-process-indicators",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: "G066",
            searchAliases: ["process indicators", "running dots", "dock dots", "open app dots"],
            notes: "Absent = true."
        ),

        // S114
        SettingDefinition(
            id: "dock.showHidden",
            displayName: "Translucent hidden apps",
            technicalName: "showhidden",
            powerUserLabel: "Make hidden app icons translucent",
            powerUserDescription: "Apps you've hidden (Cmd+H) appear semi-transparent in the Dock so you can tell them apart.",
            propellerheadDescription: "Controls whether hidden application icons are rendered translucent in the Dock.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dock",
            keyPath: "showhidden",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: "G066",
            searchAliases: ["hidden apps", "translucent", "hidden app icon", "cmd h"],
            notes: "Absent = false. Set to true to show translucency."
        ),

        // S115
        SettingDefinition(
            id: "dock.springLoadAll",
            displayName: "Spring loading for all Dock items",
            technicalName: "enable-spring-load-actions-on-all-items",
            powerUserLabel: "Spring-load all Dock items",
            powerUserDescription: "Drag a file onto any Dock icon and hold to spring-load it (open the app or folder).",
            propellerheadDescription: "Enables spring-load actions on all Dock items, not just folders.",
            category: .interface,
            risk: .safe,
            interest: .obscure,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dock",
            keyPath: "enable-spring-load-actions-on-all-items",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: nil,
            searchAliases: ["spring loading", "drag to dock", "spring load"],
            notes: "Absent = false."
        ),

        // S116
        SettingDefinition(
            id: "dock.appSwitcherAllDisplays",
            displayName: "App Switcher on all displays",
            technicalName: "appswitcher-all-displays",
            powerUserLabel: "Show App Switcher on all displays",
            powerUserDescription: "The Cmd+Tab app switcher appears on every connected display instead of just the active one.",
            propellerheadDescription: "Controls whether the application switcher is displayed on all connected monitors.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dock",
            keyPath: "appswitcher-all-displays",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: "G067",
            searchAliases: ["app switcher", "cmd tab", "multi monitor", "all displays"],
            notes: "Absent = false. Great for multi-monitor setups."
        ),

        // S117
        SettingDefinition(
            id: "dock.scrollToOpen",
            displayName: "Scroll on Dock icon to show windows",
            technicalName: "scroll-to-open",
            powerUserLabel: "Scroll to show app windows",
            powerUserDescription: "Scroll up on a Dock icon to see all that app's open windows, or open a Dock stack.",
            propellerheadDescription: "Enables scroll gesture on Dock icons to show all windows or open stacks.",
            category: .interface,
            risk: .safe,
            interest: .obscure,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dock",
            keyPath: "scroll-to-open",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: "G067",
            searchAliases: ["scroll to open", "dock scroll", "show windows", "dock stack"],
            notes: "Absent = false."
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

        // S127
        SettingDefinition(
            id: "global.windowTabbingMode",
            displayName: "Window tabbing mode",
            technicalName: "AppleWindowTabbingMode",
            powerUserLabel: "Window tabbing mode",
            powerUserDescription: "Controls whether new windows open as tabs. \"Always\" merges windows into tabs, \"Manual\" keeps them separate, \"Fullscreen\" only tabs in full screen.",
            propellerheadDescription: "Sets the system-wide preference for opening new documents as tabs vs separate windows.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "AppleWindowTabbingMode",
            valueType: .string,
            allowedValues: [.string("manual"), .string("always"), .string("fullscreen")],
            defaultValueStrategy: .absentIsSystemDefault,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G070",
            searchAliases: ["window tabs", "tabbing mode", "tabs vs windows", "merge windows"],
            notes: "Absent = fullscreen (system default). Values: manual, always, fullscreen."
        ),

        // S128
        SettingDefinition(
            id: "global.dragWindowFromAnywhere",
            displayName: "Drag windows from anywhere",
            technicalName: "NSWindowShouldDragOnGesture",
            powerUserLabel: "Drag windows from anywhere",
            powerUserDescription: "Hold Ctrl+Cmd and drag anywhere in a window to move it — no need to aim for the title bar. A Linux classic that works on macOS too.",
            propellerheadDescription: "Enables Ctrl+Cmd drag gesture to move windows from any position within the window.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "NSWindowShouldDragOnGesture",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G070",
            searchAliases: ["drag window", "move window", "ctrl cmd drag", "window drag anywhere"],
            notes: "Absent = false. Very popular with Linux converts."
        ),

        // S129
        SettingDefinition(
            id: "global.sidebarIconSize",
            displayName: "Sidebar icon size",
            technicalName: "NSTableViewDefaultSizeMode",
            powerUserLabel: "Sidebar icon size",
            powerUserDescription: "Changes the size of icons in Finder and app sidebars. Small, medium, or large.",
            propellerheadDescription: "Sets the default table/sidebar icon size. 1 = small, 2 = medium, 3 = large.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "NSTableViewDefaultSizeMode",
            valueType: .int,
            allowedValues: [.int(1), .int(2), .int(3)],
            defaultValueStrategy: .absentIsSystemDefault,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .finder,
            powerUserGrouping: "G070",
            searchAliases: ["sidebar icon size", "finder sidebar", "small icons", "large icons"],
            notes: "1 = small, 2 = medium (default), 3 = large."
        ),

        // S130
        SettingDefinition(
            id: "global.scrollbarClickBehavior",
            displayName: "Scroll bar click behavior",
            technicalName: "AppleScrollerPagingBehavior",
            powerUserLabel: "Click scroll bar to jump to spot",
            powerUserDescription: "Clicking in the scroll bar track jumps directly to that position instead of scrolling one page.",
            propellerheadDescription: "Controls whether clicking in the scroll bar track jumps to the clicked position (true) or scrolls by one page (false).",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "AppleScrollerPagingBehavior",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G070",
            searchAliases: ["scroll bar click", "scrollbar jump", "scroll bar page", "scrollbar behavior"],
            notes: "Absent = false (page by page). True = jump to spot."
        ),

        // S131
        SettingDefinition(
            id: "global.preventAutoTermination",
            displayName: "Prevent automatic app termination",
            technicalName: "NSDisableAutomaticTermination",
            powerUserLabel: "Stop macOS from quitting idle apps",
            powerUserDescription: "macOS silently quits apps it thinks you're not using. This prevents that.",
            propellerheadDescription: "Disables automatic termination of apps marked as terminable by the system.",
            category: .interface,
            risk: .advanced,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "NSDisableAutomaticTermination",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: nil,
            searchAliases: ["auto quit", "auto terminate", "kill idle apps", "app termination"],
            notes: "Absent = false (apps can be auto-terminated)."
        ),

        // S106
        SettingDefinition(
            id: "dock.hotCornerTopLeft",
            displayName: "Hot corner: top left",
            technicalName: "wvous-tl-corner",
            powerUserLabel: "Top-left hot corner",
            powerUserDescription: "Action triggered when you move the pointer to the top-left corner of the screen.",
            propellerheadDescription: "Sets the action for the top-left hot corner. Integer action codes.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dock",
            keyPath: "wvous-tl-corner",
            valueType: .int,
            allowedValues: [.int(0), .int(2), .int(3), .int(4), .int(5), .int(6), .int(10), .int(11), .int(12), .int(13), .int(14)],
            defaultValueStrategy: .absentIsSystemDefault,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: "G065",
            searchAliases: ["hot corner", "screen corner", "top left"],
            notes: "0=None, 2=Mission Control, 3=App Windows, 4=Desktop, 5=Start Screensaver, 6=Disable Screensaver, 10=Sleep Display, 11=Launchpad, 12=Notification Center, 13=Lock Screen, 14=Quick Note"
        ),

        // S107
        SettingDefinition(
            id: "dock.hotCornerTopRight",
            displayName: "Hot corner: top right",
            technicalName: "wvous-tr-corner",
            powerUserLabel: "Top-right hot corner",
            powerUserDescription: "Action triggered when you move the pointer to the top-right corner of the screen.",
            propellerheadDescription: "Sets the action for the top-right hot corner. Integer action codes.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dock",
            keyPath: "wvous-tr-corner",
            valueType: .int,
            allowedValues: [.int(0), .int(2), .int(3), .int(4), .int(5), .int(6), .int(10), .int(11), .int(12), .int(13), .int(14)],
            defaultValueStrategy: .absentIsSystemDefault,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: "G065",
            searchAliases: ["hot corner", "screen corner", "top right"],
            notes: "Same action codes as top-left."
        ),

        // S108
        SettingDefinition(
            id: "dock.hotCornerBottomLeft",
            displayName: "Hot corner: bottom left",
            technicalName: "wvous-bl-corner",
            powerUserLabel: "Bottom-left hot corner",
            powerUserDescription: "Action triggered when you move the pointer to the bottom-left corner of the screen.",
            propellerheadDescription: "Sets the action for the bottom-left hot corner. Integer action codes.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dock",
            keyPath: "wvous-bl-corner",
            valueType: .int,
            allowedValues: [.int(0), .int(2), .int(3), .int(4), .int(5), .int(6), .int(10), .int(11), .int(12), .int(13), .int(14)],
            defaultValueStrategy: .absentIsSystemDefault,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: "G065",
            searchAliases: ["hot corner", "screen corner", "bottom left"],
            notes: "Same action codes as top-left."
        ),

        // S109
        SettingDefinition(
            id: "dock.hotCornerBottomRight",
            displayName: "Hot corner: bottom right",
            technicalName: "wvous-br-corner",
            powerUserLabel: "Bottom-right hot corner",
            powerUserDescription: "Action triggered when you move the pointer to the bottom-right corner of the screen.",
            propellerheadDescription: "Sets the action for the bottom-right hot corner. Integer action codes.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dock",
            keyPath: "wvous-br-corner",
            valueType: .int,
            allowedValues: [.int(0), .int(2), .int(3), .int(4), .int(5), .int(6), .int(10), .int(11), .int(12), .int(13), .int(14)],
            defaultValueStrategy: .absentIsSystemDefault,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: "G065",
            searchAliases: ["hot corner", "screen corner", "bottom right"],
            notes: "Same action codes as top-left. Quick Note (14) is the macOS default for bottom-right."
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

        // S087
        SettingDefinition(
            id: "global.autoFillHeuristic",
            displayName: "Autofill heuristic controller",
            technicalName: "NSAutoFillHeuristicControllerEnabled",
            powerUserLabel: "Disable the autofill heuristic",
            powerUserDescription: "macOS Tahoe's autofill engine scans every text field in the background. On Electron apps like VS Code, Slack, and Discord, this causes severe input lag. Disabling it fixes the lag but turns off system-wide autofill prompts.",
            propellerheadDescription: "Disables NSAutoFillHeuristicController, which polls active text fields for autofill opportunities. Known to cause keystroke latency in Chromium/Electron apps on macOS 26.",
            category: .keyboardInput,
            risk: .advanced,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "NSAutoFillHeuristicControllerEnabled",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 26, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G057",
            searchAliases: ["autofill", "input lag", "typing delay", "electron", "vs code", "slack", "keystroke latency"],
            notes: "Tahoe-specific. Disabling removes autofill prompts as a trade-off for fixing input lag in Electron apps.",
            isInvertedInPowerUserMode: true
        ),

        // S132
        SettingDefinition(
            id: "global.inlinePrediction",
            displayName: "Inline predictive text",
            technicalName: "NSAutomaticInlinePredictionEnabled",
            powerUserLabel: "Inline predictive text",
            powerUserDescription: "Shows text predictions inline as you type. Disable if the suggestions get in the way.",
            propellerheadDescription: "Controls whether inline predictive text completions appear while typing.",
            category: .keyboardInput,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "NSAutomaticInlinePredictionEnabled",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 15, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G011",
            searchAliases: ["predictive text", "inline prediction", "auto suggest", "text prediction"],
            notes: "Absent = true. Added in macOS 15. Fits well in the typing helpers group."
        ),

        // S155
        SettingDefinition(
            id: "keyboard.fnKeyAction",
            displayName: "Fn/Globe key action",
            technicalName: "AppleFnUsageType",
            powerUserLabel: "Fn key action",
            powerUserDescription: "What happens when you press the Fn (globe) key: nothing, switch input language, open emoji picker, or start dictation.",
            propellerheadDescription: "Sets the action for the Fn/globe key. 0 = nothing, 1 = change input source, 2 = emoji, 3 = dictation.",
            category: .keyboardInput,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.HIToolbox",
            keyPath: "AppleFnUsageType",
            valueType: .int,
            allowedValues: [.int(0), .int(1), .int(2), .int(3)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .reboot,
            powerUserGrouping: "G077",
            searchAliases: ["fn key", "globe key", "function key", "emoji key", "dictation key"],
            notes: "0 = Do Nothing, 1 = Change Input Source, 2 = Show Emoji & Symbols, 3 = Start Dictation. Restart required."
        ),

        // S156
        SettingDefinition(
            id: "keyboard.fnKeysStandard",
            displayName: "Use F1-F12 as standard function keys",
            technicalName: "com.apple.keyboard.fnState",
            powerUserLabel: "F1-F12 as function keys",
            powerUserDescription: "F1-F12 keys behave as standard function keys instead of their special features (brightness, volume, etc). Hold Fn for the special features instead.",
            propellerheadDescription: "Controls whether F1-F12 keys act as standard function keys by default.",
            category: .keyboardInput,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "com.apple.keyboard.fnState",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .reboot,
            powerUserGrouping: "G077",
            searchAliases: ["function keys", "f1 f2 f3", "standard function keys", "media keys"],
            notes: "Absent = false (special features). True = standard F-keys. Restart required."
        ),

        // S157
        SettingDefinition(
            id: "keyboard.languageIndicator",
            displayName: "Language input indicator",
            technicalName: "TSMLanguageIndicatorEnabled",
            powerUserLabel: "Show language indicator when switching",
            powerUserDescription: "Briefly shows which input language is active when you switch. Disable for a cleaner look.",
            propellerheadDescription: "Controls whether a language indicator popup appears when switching input sources.",
            category: .keyboardInput,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "TSMLanguageIndicatorEnabled",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: nil,
            searchAliases: ["language indicator", "input source", "keyboard language", "input method"],
            notes: "Absent = true. Only visible when 2+ input sources are configured."
        ),

        // S090
        SettingDefinition(
            id: "trackpad.tapToClick",
            displayName: "Tap to click",
            technicalName: "Clicking",
            powerUserLabel: "Tap to click",
            powerUserDescription: "Lets you tap the trackpad instead of pressing it down to click.",
            propellerheadDescription: "Enables tap-to-click on the built-in trackpad.",
            category: .keyboardInput,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.AppleMultitouchTrackpad",
            keyPath: "Clicking",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G060",
            searchAliases: ["tap to click", "trackpad tap", "click", "trackpad"],
            notes: "Maps int 1/0 to bool. Takes effect immediately."
        ),

        // S091
        SettingDefinition(
            id: "trackpad.threeFingerDrag",
            displayName: "Three-finger drag",
            technicalName: "TrackpadThreeFingerDrag",
            powerUserLabel: "Three-finger drag",
            powerUserDescription: "Lets you drag windows and select text by swiping with three fingers. A beloved accessibility feature buried deep in settings.",
            propellerheadDescription: "Enables three-finger drag gesture on the built-in trackpad.",
            category: .keyboardInput,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.AppleMultitouchTrackpad",
            keyPath: "TrackpadThreeFingerDrag",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G060",
            searchAliases: ["three finger drag", "3 finger drag", "trackpad drag", "accessibility drag"],
            notes: "One of the most requested hidden settings. Takes effect immediately."
        ),

        // S092
        SettingDefinition(
            id: "trackpad.forceClick",
            displayName: "Force click suppressed",
            technicalName: "ForceSuppressed",
            powerUserLabel: "Disable force click",
            powerUserDescription: "Turns off the firm-press force click gesture on the trackpad.",
            propellerheadDescription: "Suppresses force click (deep press) detection on the built-in trackpad.",
            category: .keyboardInput,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.AppleMultitouchTrackpad",
            keyPath: "ForceSuppressed",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G060",
            searchAliases: ["force click", "force touch", "deep press", "firm click"],
            notes: "1 = force click disabled, 0 = enabled. Takes effect immediately."
        ),

        // S093
        SettingDefinition(
            id: "trackpad.silentClicking",
            displayName: "Haptic feedback",
            technicalName: "ActuateDetents",
            powerUserLabel: "Haptic feedback",
            powerUserDescription: "Controls the click feedback you feel when pressing the trackpad.",
            propellerheadDescription: "Enables or disables haptic actuator detent feedback on Force Touch trackpads.",
            category: .keyboardInput,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.AppleMultitouchTrackpad",
            keyPath: "ActuateDetents",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G060",
            searchAliases: ["haptic", "silent clicking", "click feedback", "vibration"],
            notes: "0 = silent clicking (no haptic), 1 = normal haptic feedback."
        ),

        // S094
        SettingDefinition(
            id: "trackpad.clickPressure",
            displayName: "Click pressure threshold",
            technicalName: "FirstClickThreshold",
            powerUserLabel: "Click pressure",
            powerUserDescription: "How hard you need to press to register a normal click. Light, medium, or firm.",
            propellerheadDescription: "Sets the first click threshold. 0 = light, 1 = medium, 2 = firm.",
            category: .keyboardInput,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.AppleMultitouchTrackpad",
            keyPath: "FirstClickThreshold",
            valueType: .int,
            allowedValues: [.int(0), .int(1), .int(2)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G061",
            searchAliases: ["click pressure", "click force", "trackpad pressure", "light click", "firm click"],
            notes: "0 = light, 1 = medium (default), 2 = firm."
        ),

        // S095
        SettingDefinition(
            id: "trackpad.forceClickPressure",
            displayName: "Force click pressure threshold",
            technicalName: "SecondClickThreshold",
            powerUserLabel: "Force click pressure",
            powerUserDescription: "How hard you need to press for a force click. Light, medium, or firm.",
            propellerheadDescription: "Sets the second (force) click threshold. 0 = light, 1 = medium, 2 = firm.",
            category: .keyboardInput,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.AppleMultitouchTrackpad",
            keyPath: "SecondClickThreshold",
            valueType: .int,
            allowedValues: [.int(0), .int(1), .int(2)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G061",
            searchAliases: ["force click pressure", "deep press force", "second click"],
            notes: "0 = light, 1 = medium (default), 2 = firm."
        ),

        // S096
        SettingDefinition(
            id: "trackpad.trackingSpeed",
            displayName: "Trackpad tracking speed",
            technicalName: "com.apple.trackpad.scaling",
            powerUserLabel: "Tracking speed",
            powerUserDescription: "How fast the pointer moves when you swipe the trackpad.",
            propellerheadDescription: "Controls trackpad pointer acceleration scaling. Range 0–3.",
            category: .keyboardInput,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "com.apple.trackpad.scaling",
            valueType: .double,
            allowedValues: nil,
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G061",
            searchAliases: ["tracking speed", "pointer speed", "trackpad speed", "cursor speed"],
            notes: "Range 0-3. Default varies by user. Takes effect immediately."
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

        // S086
        SettingDefinition(
            id: "windowManager.animationSpeed",
            displayName: "Stage Manager animation speed",
            technicalName: "AnimationSpeed",
            powerUserLabel: "Speed up Stage Manager animations",
            powerUserDescription: "Stage Manager's window-switching animations are slow and sweeping by default. Lower values make them snappier. Set to near-zero for instant transitions.",
            propellerheadDescription: "Controls the transition speed of Stage Manager window groupings. Lower float values produce faster animations.",
            category: .windowsSpaces,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.WindowManager",
            keyPath: "AnimationSpeed",
            valueType: .double,
            allowedValues: nil,
            defaultValueStrategy: .absentIsSystemDefault,
            supportedOS: OSRange(min: 15, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G056",
            searchAliases: ["stage manager", "window animation", "stage manager speed", "window switching"],
            notes: "Default is about 1.0. Lower is faster. 0.1 is near-instant. Delete key to restore default."
        ),

        // S097
        SettingDefinition(
            id: "windowManager.stageManager",
            displayName: "Stage Manager",
            technicalName: "GloballyEnabled",
            powerUserLabel: "Enable Stage Manager",
            powerUserDescription: "Organizes your recent windows into a strip on the left side of the screen for less clutter.",
            propellerheadDescription: "Enables or disables Stage Manager globally.",
            category: .windowsSpaces,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.WindowManager",
            keyPath: "GloballyEnabled",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 15, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G062",
            searchAliases: ["stage manager", "window organizer", "window strip"],
            notes: "Absent = off. Takes effect immediately."
        ),

        // S098
        SettingDefinition(
            id: "windowManager.autoHideStrip",
            displayName: "Auto-hide Stage Manager strip",
            technicalName: "AutoHide",
            powerUserLabel: "Auto-hide the Stage Manager strip",
            powerUserDescription: "Hides the strip of recent apps on the left until you hover near the edge.",
            propellerheadDescription: "Controls whether the Stage Manager strip auto-hides.",
            category: .windowsSpaces,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.WindowManager",
            keyPath: "AutoHide",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 15, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G062",
            searchAliases: ["stage manager hide", "auto hide strip", "hide recent apps"],
            notes: "Only relevant when Stage Manager is enabled."
        ),

        // S099
        SettingDefinition(
            id: "windowManager.clickToShowDesktop",
            displayName: "Click wallpaper to show desktop",
            technicalName: "EnableStandardClickToShowDesktop",
            powerUserLabel: "Click wallpaper to show desktop",
            powerUserDescription: "Clicking the wallpaper moves all windows aside to reveal the desktop. This changed in macOS Sonoma and annoyed a lot of people.",
            propellerheadDescription: "Controls whether clicking the desktop background hides all windows. Introduced in macOS 14.",
            category: .windowsSpaces,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.WindowManager",
            keyPath: "EnableStandardClickToShowDesktop",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G063",
            searchAliases: ["click desktop", "show desktop", "click wallpaper", "hide windows"],
            notes: "Absent = true (Apple default since Sonoma). Set to false to disable."
        ),

        // S100
        SettingDefinition(
            id: "windowManager.tilingByEdgeDrag",
            displayName: "Snap windows by dragging to edges",
            technicalName: "EnableTilingByEdgeDrag",
            powerUserLabel: "Snap windows to edges",
            powerUserDescription: "Drag a window to the left or right edge of the screen to tile it to that half.",
            propellerheadDescription: "Enables window tiling by dragging windows to screen edges. Introduced in macOS 15.",
            category: .windowsSpaces,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.WindowManager",
            keyPath: "EnableTilingByEdgeDrag",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 15, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G063",
            searchAliases: ["tiling", "snap windows", "edge drag", "split screen", "window snapping"],
            notes: "Absent = true. Set to false to disable edge-drag tiling."
        ),

        // S101
        SettingDefinition(
            id: "windowManager.tilingOptionKey",
            displayName: "Hold Option to tile windows",
            technicalName: "EnableTilingOptionAccelerator",
            powerUserLabel: "Hold Option to tile windows",
            powerUserDescription: "Hold the Option key while dragging a window to snap it into a tiled position.",
            propellerheadDescription: "Enables the Option key as a tiling accelerator when dragging windows.",
            category: .windowsSpaces,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.WindowManager",
            keyPath: "EnableTilingOptionAccelerator",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 15, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G063",
            searchAliases: ["option key tiling", "alt tiling", "window tiling shortcut"],
            notes: "Absent = true. Set to false to disable."
        ),

        // S102
        SettingDefinition(
            id: "windowManager.topEdgeTiling",
            displayName: "Drag to menu bar to fill screen",
            technicalName: "EnableTopTilingByEdgeDrag",
            powerUserLabel: "Drag to top to fill screen",
            powerUserDescription: "Drag a window to the top edge (menu bar) to make it fill the screen.",
            propellerheadDescription: "Enables window fill-screen behavior when dragged to the top edge.",
            category: .windowsSpaces,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.WindowManager",
            keyPath: "EnableTopTilingByEdgeDrag",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 15, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G063",
            searchAliases: ["top edge tiling", "fill screen drag", "maximize drag"],
            notes: "Absent = true. Set to false to disable."
        ),

        // S103
        SettingDefinition(
            id: "windowManager.tiledWindowMargins",
            displayName: "Margins between tiled windows",
            technicalName: "EnableTiledWindowMargins",
            powerUserLabel: "Gaps between tiled windows",
            powerUserDescription: "Adds small gaps between tiled windows so they don't touch.",
            propellerheadDescription: "Controls whether tiled windows have margins between them.",
            category: .windowsSpaces,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.WindowManager",
            keyPath: "EnableTiledWindowMargins",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 15, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G063",
            searchAliases: ["tiling margins", "window gaps", "tiled window spacing"],
            notes: "0 = no margins (flush), 1 = margins."
        ),

        // S104
        SettingDefinition(
            id: "windowManager.hideDesktopItems",
            displayName: "Hide desktop items (Stage Manager)",
            technicalName: "HideDesktop",
            powerUserLabel: "Hide desktop icons in Stage Manager",
            powerUserDescription: "Hides all files and folders on your desktop when Stage Manager is active.",
            propellerheadDescription: "Controls whether desktop items are hidden in Stage Manager mode.",
            category: .windowsSpaces,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.WindowManager",
            keyPath: "HideDesktop",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 15, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G062",
            searchAliases: ["hide desktop", "stage manager desktop", "clean desktop"],
            notes: "Only applies when Stage Manager is on."
        ),

        // S105
        SettingDefinition(
            id: "windowManager.hideDesktopIcons",
            displayName: "Hide desktop icons (standard)",
            technicalName: "StandardHideDesktopIcons",
            powerUserLabel: "Hide all desktop icons",
            powerUserDescription: "Hides all files and folders on the desktop in normal (non-Stage Manager) mode. Your files are still in ~/Desktop, just not shown.",
            propellerheadDescription: "Controls whether desktop icons are hidden when not using Stage Manager.",
            category: .windowsSpaces,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.WindowManager",
            keyPath: "StandardHideDesktopIcons",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G064",
            searchAliases: ["hide desktop icons", "clean desktop", "no desktop files"],
            notes: "Absent = false. Files still exist in ~/Desktop."
        ),

        // S158
        SettingDefinition(
            id: "global.switchSpaceOnActivate",
            displayName: "Switch Space when activating app",
            technicalName: "AppleSpacesSwitchOnActivate",
            powerUserLabel: "Switch to app's Space when activating",
            powerUserDescription: "When you click an app in the Dock or Cmd+Tab to it, macOS jumps to the Space where that app's windows are. Disable to stay on the current Space.",
            propellerheadDescription: "Controls whether activating an application switches to the Space containing its windows.",
            category: .windowsSpaces,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "AppleSpacesSwitchOnActivate",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .dock,
            powerUserGrouping: "G012",
            searchAliases: ["switch space", "spaces auto switch", "activate app space", "jump to space"],
            notes: "Absent = true. Set to false to stop jumping between Spaces.",
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

        // S141
        SettingDefinition(
            id: "screencapture.includeDate",
            displayName: "Include date in screenshot filenames",
            technicalName: "include-date",
            powerUserLabel: "Date in screenshot filenames",
            powerUserDescription: "Includes the date and time in screenshot file names. Turn off for cleaner names.",
            propellerheadDescription: "Controls whether screenshot filenames include the capture date and time.",
            category: .screenshots,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.screencapture",
            keyPath: "include-date",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .systemUIServer,
            powerUserGrouping: "G014",
            searchAliases: ["screenshot date", "filename date", "screenshot timestamp"],
            notes: "Absent = true."
        ),

        // S142
        SettingDefinition(
            id: "screencapture.rememberSelection",
            displayName: "Remember screenshot selection",
            technicalName: "save-selections",
            powerUserLabel: "Remember last screenshot area",
            powerUserDescription: "When taking area screenshots, remembers the last selection rectangle so you can quickly re-capture the same region.",
            propellerheadDescription: "Controls whether the screenshot tool remembers the previous selection window.",
            category: .screenshots,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.screencapture",
            keyPath: "save-selections",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .systemUIServer,
            powerUserGrouping: "G014",
            searchAliases: ["remember selection", "screenshot area", "save selection"],
            notes: "Absent = false."
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

        // S159
        SettingDefinition(
            id: "xcode.showBuildDuration",
            displayName: "Show build duration in Xcode",
            technicalName: "ShowBuildOperationDuration",
            powerUserLabel: "Show build duration in Xcode toolbar",
            powerUserDescription: "Shows how long each build takes in Xcode's activity viewer. Essential for optimizing build times.",
            propellerheadDescription: "Controls whether build duration is displayed in the Xcode toolbar activity viewer.",
            category: .safariDeveloper,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.dt.Xcode",
            keyPath: "ShowBuildOperationDuration",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .app(bundleID: "com.apple.dt.Xcode"),
            powerUserGrouping: "G078",
            searchAliases: ["xcode build time", "build duration", "compile time", "xcode toolbar"],
            notes: "Absent = false. Restart Xcode to take effect."
        ),

        // S160
        SettingDefinition(
            id: "terminal.focusFollowsMouse",
            displayName: "Terminal focus follows mouse",
            technicalName: "FocusFollowsMouse",
            powerUserLabel: "Terminal focus follows mouse",
            powerUserDescription: "Terminal windows gain focus automatically when you hover over them — no click needed. A classic X11 behavior.",
            propellerheadDescription: "Enables focus-follows-mouse behavior between Terminal windows.",
            category: .safariDeveloper,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.Terminal",
            keyPath: "FocusFollowsMouse",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .app(bundleID: "com.apple.Terminal"),
            powerUserGrouping: "G078",
            searchAliases: ["focus follows mouse", "terminal hover", "x11 focus", "sloppy focus"],
            notes: "Absent = false. Only works between Terminal windows, not all apps."
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

        // S088
        SettingDefinition(
            id: "global.disableSolarium",
            displayName: "Disable Liquid Glass",
            technicalName: "com.apple.SwiftUI.DisableSolarium",
            powerUserLabel: "Disable Liquid Glass",
            powerUserDescription: "Turns off Tahoe's translucent Liquid Glass rendering across all SwiftUI apps. Reverts to solid, opaque backgrounds like Sequoia. Requires a reboot. Note: may cause minor visual glitches in some menu bar items.",
            propellerheadDescription: "Disables the Solarium rendering framework (Apple's internal name for Liquid Glass). Forces all SwiftUI apps to render with opaque, pre-Tahoe backgrounds. Apple may remove this flag in future updates.",
            category: .accessibilityVisual,
            risk: .advanced,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "com.apple.SwiftUI.DisableSolarium",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 26, max: nil),
            restartRequirement: .reboot,
            powerUserGrouping: "G058",
            searchAliases: ["liquid glass", "solarium", "transparency", "tahoe", "opaque", "glass effect", "blur"],
            notes: "The headline Tahoe tweak. May cause minor menu bar visual glitches. Apple may patch this out in future updates."
        ),

        // S089
        SettingDefinition(
            id: "global.menuActionImages",
            displayName: "Menu bar action images",
            technicalName: "NSMenuEnableActionImages",
            powerUserLabel: "Hide icons in menu bar dropdowns",
            powerUserDescription: "Tahoe added icons next to every menu item in dropdown menus. If you find them distracting, this strips them out and restores the clean, text-only menus from Sequoia.",
            propellerheadDescription: "Suppresses the inline glyph icons that macOS 26 renders in standard AppKit menu bar dropdowns. Takes effect on next app launch.",
            category: .accessibilityVisual,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "NSMenuEnableActionImages",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 26, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G059",
            searchAliases: ["menu icons", "menu images", "menu bar clutter", "action images", "menu glyphs"],
            notes: "Takes effect immediately on next app launch. System icons (zoom, resize) are preserved.",
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

        // S118
        SettingDefinition(
            id: "menu.clockShowAMPM",
            displayName: "Show AM/PM in menu bar clock",
            technicalName: "ShowAMPM",
            powerUserLabel: "Show AM/PM",
            powerUserDescription: "Shows AM or PM next to the time in 12-hour mode.",
            propellerheadDescription: "Controls whether the AM/PM label is shown in the menu bar clock.",
            category: .menuBarStatus,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.menuextra.clock",
            keyPath: "ShowAMPM",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .controlCenter,
            powerUserGrouping: "G068",
            searchAliases: ["am pm", "12 hour", "clock am pm"],
            notes: "Only relevant when using 12-hour time."
        ),

        // S119
        SettingDefinition(
            id: "menu.clockShowSeconds",
            displayName: "Show seconds in menu bar clock",
            technicalName: "ShowSeconds",
            powerUserLabel: "Show seconds in the clock",
            powerUserDescription: "Adds seconds to the menu bar clock for precision timekeeping.",
            propellerheadDescription: "Controls whether the menu bar clock displays seconds.",
            category: .menuBarStatus,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.menuextra.clock",
            keyPath: "ShowSeconds",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .controlCenter,
            powerUserGrouping: "G068",
            searchAliases: ["show seconds", "clock seconds", "precise time"],
            notes: "Absent = false."
        ),

        // S120
        SettingDefinition(
            id: "menu.clockShowDayOfWeek",
            displayName: "Show day of week in menu bar clock",
            technicalName: "ShowDayOfWeek",
            powerUserLabel: "Show day of week",
            powerUserDescription: "Shows the day name (Mon, Tue, etc.) next to the clock.",
            propellerheadDescription: "Controls whether the day of the week appears in the menu bar clock.",
            category: .menuBarStatus,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.menuextra.clock",
            keyPath: "ShowDayOfWeek",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .controlCenter,
            powerUserGrouping: "G068",
            searchAliases: ["day of week", "weekday", "show day"],
            notes: nil
        ),

        // S121
        SettingDefinition(
            id: "menu.clockAnalog",
            displayName: "Analog clock in menu bar",
            technicalName: "IsAnalog",
            powerUserLabel: "Analog clock",
            powerUserDescription: "Replaces the digital clock in the menu bar with a tiny analog clock face.",
            propellerheadDescription: "Controls whether the menu bar clock is displayed as analog.",
            category: .menuBarStatus,
            risk: .safe,
            interest: .obscure,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.menuextra.clock",
            keyPath: "IsAnalog",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .controlCenter,
            powerUserGrouping: "G068",
            searchAliases: ["analog clock", "clock face", "round clock"],
            notes: "Absent = false (digital)."
        ),

        // S133
        SettingDefinition(
            id: "menu.autoHideMenuBar",
            displayName: "Auto-hide menu bar",
            technicalName: "_HIHideMenuBar",
            powerUserLabel: "Auto-hide the menu bar",
            powerUserDescription: "Hides the menu bar until you move the pointer to the top of the screen.",
            propellerheadDescription: "Controls whether the menu bar is automatically hidden.",
            category: .menuBarStatus,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "_HIHideMenuBar",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G071",
            searchAliases: ["auto hide menu bar", "hide menu bar", "menu bar visibility"],
            notes: "Absent = false. Takes effect immediately."
        ),

        // S134
        SettingDefinition(
            id: "menu.statusItemSpacing",
            displayName: "Menu bar icon spacing",
            technicalName: "NSStatusItemSpacing",
            powerUserLabel: "Menu bar icon spacing",
            powerUserDescription: "How much space between icons in the menu bar. Lower values pack more icons in.",
            propellerheadDescription: "Controls the pixel spacing between NSStatusItems in the menu bar.",
            category: .menuBarStatus,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "NSStatusItemSpacing",
            valueType: .int,
            allowedValues: nil,
            defaultValueStrategy: .absentIsSystemDefault,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G071",
            searchAliases: ["menu bar spacing", "status item spacing", "icon spacing", "menu bar density"],
            notes: "Default is around 12. Lower = tighter. Delete key to restore default."
        ),

        // S135
        SettingDefinition(
            id: "menu.statusItemPadding",
            displayName: "Menu bar icon padding",
            technicalName: "NSStatusItemSelectionPadding",
            powerUserLabel: "Menu bar icon padding",
            powerUserDescription: "Padding around each menu bar icon's click target. Lower values make icons sit closer together.",
            propellerheadDescription: "Controls the selection padding (hit area) for NSStatusItems in the menu bar.",
            category: .menuBarStatus,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "NSStatusItemSelectionPadding",
            valueType: .int,
            allowedValues: nil,
            defaultValueStrategy: .absentIsSystemDefault,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G071",
            searchAliases: ["menu bar padding", "icon padding", "status item padding", "bartender"],
            notes: "Default is around 8. Lower = tighter. Delete key to restore default."
        ),

        // S122
        SettingDefinition(
            id: "menu.ccBluetooth",
            displayName: "Show Bluetooth in menu bar",
            technicalName: "NSStatusItem Visible Bluetooth",
            powerUserLabel: "Bluetooth in menu bar",
            powerUserDescription: "Shows the Bluetooth icon in the menu bar for quick access.",
            propellerheadDescription: "Controls visibility of the Bluetooth status item in the menu bar.",
            category: .menuBarStatus,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.controlcenter",
            keyPath: "NSStatusItem Visible Bluetooth",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .controlCenter,
            powerUserGrouping: "G069",
            searchAliases: ["bluetooth menu bar", "bluetooth icon", "bluetooth status"],
            notes: "Absent = false (hidden)."
        ),

        // S123
        SettingDefinition(
            id: "menu.ccSound",
            displayName: "Show Sound in menu bar",
            technicalName: "NSStatusItem Visible Sound",
            powerUserLabel: "Sound in menu bar",
            powerUserDescription: "Shows the volume/sound icon in the menu bar.",
            propellerheadDescription: "Controls visibility of the Sound status item in the menu bar.",
            category: .menuBarStatus,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.controlcenter",
            keyPath: "NSStatusItem Visible Sound",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .controlCenter,
            powerUserGrouping: "G069",
            searchAliases: ["sound menu bar", "volume icon", "audio menu bar"],
            notes: nil
        ),

        // S124
        SettingDefinition(
            id: "menu.ccNowPlaying",
            displayName: "Show Now Playing in menu bar",
            technicalName: "NSStatusItem Visible NowPlaying",
            powerUserLabel: "Now Playing in menu bar",
            powerUserDescription: "Shows the currently playing media in the menu bar.",
            propellerheadDescription: "Controls visibility of the Now Playing status item in the menu bar.",
            category: .menuBarStatus,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.controlcenter",
            keyPath: "NSStatusItem Visible NowPlaying",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .controlCenter,
            powerUserGrouping: "G069",
            searchAliases: ["now playing", "music menu bar", "media menu bar"],
            notes: "Absent = false."
        ),

        // S125
        SettingDefinition(
            id: "menu.ccFocusModes",
            displayName: "Show Focus in menu bar",
            technicalName: "NSStatusItem Visible FocusModes",
            powerUserLabel: "Focus in menu bar",
            powerUserDescription: "Shows the Focus (Do Not Disturb) icon in the menu bar.",
            propellerheadDescription: "Controls visibility of the Focus Modes status item in the menu bar.",
            category: .menuBarStatus,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.controlcenter",
            keyPath: "NSStatusItem Visible FocusModes",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .controlCenter,
            powerUserGrouping: "G069",
            searchAliases: ["focus", "do not disturb", "dnd menu bar", "focus modes"],
            notes: "Absent = false."
        ),

        // S126
        SettingDefinition(
            id: "menu.ccDisplay",
            displayName: "Show Brightness in menu bar",
            technicalName: "NSStatusItem Visible Display",
            powerUserLabel: "Brightness in menu bar",
            powerUserDescription: "Shows the display brightness control in the menu bar.",
            propellerheadDescription: "Controls visibility of the Display brightness status item in the menu bar.",
            category: .menuBarStatus,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.controlcenter",
            keyPath: "NSStatusItem Visible Display",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .controlCenter,
            powerUserGrouping: "G069",
            searchAliases: ["brightness", "display menu bar", "screen brightness"],
            notes: "Absent = false."
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

        // S143
        SettingDefinition(
            id: "screensaver.askForPassword",
            displayName: "Require password after screensaver",
            technicalName: "askForPassword",
            powerUserLabel: "Lock screen after screensaver",
            powerUserDescription: "Requires your password when the screensaver is dismissed or stopped.",
            propellerheadDescription: "Controls whether a password is required to unlock the screen after the screensaver activates.",
            category: .securityPrivacy,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.screensaver",
            keyPath: "askForPassword",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G074",
            searchAliases: ["screensaver password", "lock screen", "screen lock", "require password"],
            notes: "Maps int 1/0 to bool. Absent = false."
        ),

        // S144
        SettingDefinition(
            id: "screensaver.askForPasswordDelay",
            displayName: "Screensaver password delay",
            technicalName: "askForPasswordDelay",
            powerUserLabel: "Password delay (seconds)",
            powerUserDescription: "How many seconds after the screensaver starts before the password is required. Set to 0 to require it immediately.",
            propellerheadDescription: "Sets the delay in seconds before a password is required after the screensaver activates.",
            category: .securityPrivacy,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.screensaver",
            keyPath: "askForPasswordDelay",
            valueType: .int,
            allowedValues: nil,
            defaultValueStrategy: .absentIsSystemDefault,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G074",
            searchAliases: ["password delay", "lock delay", "screensaver delay"],
            notes: "In seconds. 0 = immediate. Only relevant when askForPassword is enabled."
        ),

        // S145
        SettingDefinition(
            id: "loginwindow.text",
            displayName: "Login window message",
            technicalName: "LoginwindowText",
            powerUserLabel: "Custom login screen message",
            powerUserDescription: "Shows a custom message on the login screen. Useful for contact info if your Mac is lost, or for a bit of personality.",
            propellerheadDescription: "Sets custom text displayed on the macOS login window.",
            category: .securityPrivacy,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.loginwindow",
            keyPath: "LoginwindowText",
            valueType: .string,
            allowedValues: nil,
            defaultValueStrategy: .absentIsSystemDefault,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: nil,
            searchAliases: ["login message", "login text", "lock screen message", "lost mac"],
            notes: "Empty/absent = no message. Great for 'If found, call...' messages."
        ),

        // S161
        SettingDefinition(
            id: "appleIntelligence.enabled",
            displayName: "Apple Intelligence",
            technicalName: "545129924",
            powerUserLabel: "Apple Intelligence",
            powerUserDescription: "Apple Intelligence is activated by default on Apple Silicon Macs since macOS 15.3. Disable it here if you don't want on-device AI features.",
            propellerheadDescription: "Controls whether Apple Intelligence features are enabled. Uses CloudSubscriptionFeatures opt-in key 545129924.",
            category: .securityPrivacy,
            risk: .advanced,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.CloudSubscriptionFeatures.optIn",
            keyPath: "545129924",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 15, max: nil),
            restartRequirement: .reboot,
            powerUserGrouping: nil,
            searchAliases: ["apple intelligence", "ai", "siri ai", "on device ai", "machine learning"],
            notes: "Absent = true (enabled on Apple Silicon). Restart required. Only applicable to Apple Silicon Macs."
        ),

        // S146
        SettingDefinition(
            id: "activityMonitor.iconType",
            displayName: "Activity Monitor dock icon",
            technicalName: "IconType",
            powerUserLabel: "Activity Monitor dock icon style",
            powerUserDescription: "Changes what Activity Monitor shows in the Dock: the plain app icon, a CPU graph, or network activity.",
            propellerheadDescription: "Controls the Activity Monitor dock icon. 0 = app icon, 2 = network usage, 3 = disk activity, 5 = CPU usage, 6 = CPU history.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.ActivityMonitor",
            keyPath: "IconType",
            valueType: .int,
            allowedValues: [.int(0), .int(2), .int(3), .int(5), .int(6)],
            defaultValueStrategy: .absentIsSystemDefault,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .app(bundleID: "com.apple.ActivityMonitor"),
            powerUserGrouping: "G075",
            searchAliases: ["activity monitor", "cpu graph", "dock icon", "network graph"],
            notes: "0=App Icon, 2=Network, 3=Disk, 5=CPU Usage, 6=CPU History. Restart Activity Monitor to take effect."
        ),

        // S147
        SettingDefinition(
            id: "activityMonitor.showCategory",
            displayName: "Activity Monitor default filter",
            technicalName: "ShowCategory",
            powerUserLabel: "Default process filter",
            powerUserDescription: "Which processes Activity Monitor shows when it opens.",
            propellerheadDescription: "Sets the default process filter. 100 = All Processes, 101 = Hierarchical, 102 = My Processes.",
            category: .interface,
            risk: .safe,
            interest: .obscure,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.ActivityMonitor",
            keyPath: "ShowCategory",
            valueType: .int,
            allowedValues: [.int(100), .int(101), .int(102)],
            defaultValueStrategy: .readCurrentState,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .app(bundleID: "com.apple.ActivityMonitor"),
            powerUserGrouping: "G075",
            searchAliases: ["activity monitor filter", "show all processes", "process list"],
            notes: "100 = All Processes, 101 = Hierarchical, 102 = My Processes."
        ),

        // S150
        SettingDefinition(
            id: "activityMonitor.updatePeriod",
            displayName: "Activity Monitor update frequency",
            technicalName: "UpdatePeriod",
            powerUserLabel: "Update frequency",
            powerUserDescription: "How often Activity Monitor refreshes its data. More frequent updates give a real-time feel but use more CPU.",
            propellerheadDescription: "Controls the Activity Monitor data refresh interval in seconds.",
            category: .interface,
            risk: .safe,
            interest: .obscure,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.ActivityMonitor",
            keyPath: "UpdatePeriod",
            valueType: .int,
            allowedValues: [.int(1), .int(2), .int(5)],
            defaultValueStrategy: .absentIsSystemDefault,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .app(bundleID: "com.apple.ActivityMonitor"),
            powerUserGrouping: "G075",
            searchAliases: ["activity monitor refresh", "update frequency", "refresh rate"],
            notes: "1 = every second, 2 = every 2 seconds, 5 = every 5 seconds (default)."
        ),

        // S151
        SettingDefinition(
            id: "global.keepWindowsOnQuit",
            displayName: "Keep windows when quitting apps",
            technicalName: "NSQuitAlwaysKeepsWindow",
            powerUserLabel: "Restore windows when reopening apps",
            powerUserDescription: "When you quit and reopen an app, your open documents and windows come back automatically.",
            propellerheadDescription: "Controls whether application windows and documents are restored on relaunch.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "NSQuitAlwaysKeepsWindow",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .signOut,
            powerUserGrouping: "G076",
            searchAliases: ["keep windows", "restore windows", "resume", "reopen windows"],
            notes: "Absent = true. Requires sign out to take effect."
        ),

        // S152
        SettingDefinition(
            id: "global.closeConfirmsChanges",
            displayName: "Ask to save on close",
            technicalName: "NSCloseAlwaysConfirmsChanges",
            powerUserLabel: "Ask to save changes when closing",
            powerUserDescription: "When you close a document, you get a save prompt instead of changes being auto-saved silently.",
            propellerheadDescription: "Controls whether closing a document prompts to save instead of auto-saving.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "NSGlobalDomain",
            keyPath: "NSCloseAlwaysConfirmsChanges",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: "G076",
            searchAliases: ["save prompt", "close confirm", "auto save", "unsaved changes"],
            notes: "Absent = true (auto-saves). False = prompts before closing.",
            isInvertedInPowerUserMode: true
        ),

        // S153
        SettingDefinition(
            id: "music.songNotifications",
            displayName: "Music song notifications",
            technicalName: "userWantsPlaybackNotifications",
            powerUserLabel: "Music now-playing notifications",
            powerUserDescription: "Shows a notification when a new song starts playing in the Music app.",
            propellerheadDescription: "Controls whether the Music app displays notifications for new song playback.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.Music",
            keyPath: "userWantsPlaybackNotifications",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsTrue,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .app(bundleID: "com.apple.Music"),
            powerUserGrouping: nil,
            searchAliases: ["music notifications", "now playing", "song notification", "music app"],
            notes: "Absent = true. Restart Music to take effect."
        ),

        // S154
        SettingDefinition(
            id: "timeMachine.dontOfferNewDisks",
            displayName: "Don't offer new disks for backup",
            technicalName: "DoNotOfferNewDisksForBackup",
            powerUserLabel: "Stop Time Machine disk prompts",
            powerUserDescription: "Stops macOS from asking if you want to use every new disk you plug in as a Time Machine backup.",
            propellerheadDescription: "Prevents Time Machine from prompting to use newly connected volumes as backup destinations.",
            category: .interface,
            risk: .safe,
            interest: .common,
            supportLevel: .shipping,
            mechanism: .defaults,
            domain: "com.apple.TimeMachine",
            keyPath: "DoNotOfferNewDisksForBackup",
            valueType: .bool,
            allowedValues: [.bool(true), .bool(false)],
            defaultValueStrategy: .assumeAbsentIsFalse,
            supportedOS: OSRange(min: 14, max: nil),
            restartRequirement: .none,
            powerUserGrouping: nil,
            searchAliases: ["time machine", "backup prompt", "new disk", "time machine popup"],
            notes: "Absent = false (prompts you). Set to true to silence."
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

        // G054 — Finder column auto-sizing (simple toggle)
        GroupedControlDefinition(
            id: "G054",
            title: "Auto-resize Finder columns",
            subtitle: "Columns in Finder's Column View automatically widen to fit long filenames. Fixes the Tahoe scrollbar-over-resize-handle bug.",
            category: .finder,
            kind: .toggle,
            backingSettingIDs: ["finder.columnAutoSizing"],
            options: nil
        ),

        // G055 — Hide desktop icons (simple toggle)
        GroupedControlDefinition(
            id: "G055",
            title: "Hide desktop icons",
            subtitle: "Stops Finder from drawing anything on the desktop. No more accidental window dismissals when you click empty space. Files stay in ~/Desktop.",
            category: .finder,
            kind: .toggle,
            backingSettingIDs: ["finder.createDesktop"],
            options: nil
        ),

        // G072 — Auto-empty Trash (simple toggle)
        GroupedControlDefinition(
            id: "G072",
            title: "Auto-empty Trash after 30 days",
            subtitle: "Items that have been in the Trash for more than 30 days are automatically deleted.",
            category: .finder,
            kind: .toggle,
            backingSettingIDs: ["finder.autoRemoveOldTrash"],
            options: nil
        ),

        // G073 — Desktop drive icons (multi-toggle card)
        GroupedControlDefinition(
            id: "G073",
            title: "Desktop drive icons",
            subtitle: "Choose which types of drives and volumes show icons on the desktop.",
            category: .finder,
            kind: .multiToggle,
            backingSettingIDs: [
                "finder.showExternalDrives",
                "finder.showInternalDrives",
                "finder.showServers",
                "finder.showRemovableMedia",
            ],
            options: nil
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

        // G076 — Window persistence (multi-toggle)
        GroupedControlDefinition(
            id: "G076",
            title: "Window persistence",
            subtitle: "Control whether apps restore their windows when reopened, and whether closing prompts you to save.",
            category: .interface,
            kind: .multiToggle,
            backingSettingIDs: [
                "global.keepWindowsOnQuit",
                "global.closeConfirmsChanges",
            ],
            options: nil
        ),

        // G075 — Activity Monitor (multi-control card)
        GroupedControlDefinition(
            id: "G075",
            title: "Activity Monitor",
            subtitle: "Change Activity Monitor's dock icon to show live CPU or network stats, and set which processes are shown by default.",
            category: .interface,
            kind: .multiControl,
            backingSettingIDs: [
                "activityMonitor.iconType",
                "activityMonitor.showCategory",
            ],
            options: nil
        ),

        // G070 — Window behavior (multi-control card)
        GroupedControlDefinition(
            id: "G070",
            title: "Window behavior",
            subtitle: "Control window tabbing, drag-from-anywhere, sidebar icon size, and scroll bar click behavior.",
            category: .interface,
            kind: .multiControl,
            backingSettingIDs: [
                "global.windowTabbingMode",
                "global.dragWindowFromAnywhere",
                "global.sidebarIconSize",
                "global.scrollbarClickBehavior",
            ],
            options: nil
        ),

        // G066 — Dock extras (multi-toggle card)
        GroupedControlDefinition(
            id: "G066",
            title: "Dock extras",
            subtitle: "Magnification, launch animation, process indicators, and hidden app translucency.",
            category: .interface,
            kind: .multiToggle,
            backingSettingIDs: [
                "dock.magnification",
                "dock.launchAnimation",
                "dock.showProcessIndicators",
                "dock.showHidden",
            ],
            options: nil
        ),

        // G067 — Dock multi-monitor & scroll (multi-toggle card)
        GroupedControlDefinition(
            id: "G067",
            title: "Dock multi-monitor & scroll",
            subtitle: "Show the App Switcher on every display and scroll on Dock icons to see windows.",
            category: .interface,
            kind: .multiToggle,
            backingSettingIDs: [
                "dock.appSwitcherAllDisplays",
                "dock.scrollToOpen",
            ],
            options: nil
        ),

        // G065 — Hot corners (multi-control card)
        GroupedControlDefinition(
            id: "G065",
            title: "Hot corners",
            subtitle: "Trigger actions by moving the pointer to a screen corner. Set each corner to Mission Control, Desktop, Lock Screen, and more — or leave it off.",
            category: .interface,
            kind: .multiControl,
            backingSettingIDs: [
                "dock.hotCornerTopLeft",
                "dock.hotCornerTopRight",
                "dock.hotCornerBottomLeft",
                "dock.hotCornerBottomRight",
            ],
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
            subtitle: "Disables automatic quote changes, dash changes, capitalization, spelling correction, period shortcuts, and inline predictions.",
            category: .keyboardInput,
            kind: .multiToggle,
            backingSettingIDs: [
                "global.smartQuotes",
                "global.smartDashes",
                "global.autoCapitalization",
                "global.autoSpellingCorrection",
                "global.periodSubstitution",
                "global.inlinePrediction",
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

        // G057 — Disable autofill heuristic (simple toggle)
        GroupedControlDefinition(
            id: "G057",
            title: "Disable the autofill heuristic",
            subtitle: "Tahoe's autofill engine scans every text field in the background, causing severe input lag in VS Code, Slack, and other Electron apps. Disabling it fixes the lag but turns off system autofill prompts.",
            category: .keyboardInput,
            kind: .toggle,
            backingSettingIDs: ["global.autoFillHeuristic"],
            options: nil
        ),

        // G077 — Fn/Globe key (multi-control card)
        GroupedControlDefinition(
            id: "G077",
            title: "Fn/Globe key & function keys",
            subtitle: "Choose what the Fn key does, and whether F1-F12 act as standard function keys or media controls.",
            category: .keyboardInput,
            kind: .multiControl,
            backingSettingIDs: [
                "keyboard.fnKeyAction",
                "keyboard.fnKeysStandard",
            ],
            options: nil
        ),

        // G060 — Trackpad gestures (multi-toggle card)
        GroupedControlDefinition(
            id: "G060",
            title: "Trackpad gestures",
            subtitle: "Customise tap, drag, and click behavior on the built-in trackpad.",
            category: .keyboardInput,
            kind: .multiToggle,
            backingSettingIDs: [
                "trackpad.tapToClick",
                "trackpad.threeFingerDrag",
                "trackpad.forceClick",
                "trackpad.silentClicking",
            ],
            options: nil
        ),

        // G061 — Trackpad click pressure (discrete choice)
        GroupedControlDefinition(
            id: "G061",
            title: "Trackpad click & tracking",
            subtitle: "Set how hard you need to press to click, and how fast the pointer moves.",
            category: .keyboardInput,
            kind: .multiControl,
            backingSettingIDs: [
                "trackpad.clickPressure",
                "trackpad.forceClickPressure",
                "trackpad.trackingSpeed",
            ],
            options: nil
        ),

        // ---------------------------------------------------------------
        // MARK: Windows & Spaces (most popular first)
        // ---------------------------------------------------------------

        // G012 — Spaces behavior (multi-toggle)
        GroupedControlDefinition(
            id: "G012",
            title: "Spaces behavior",
            subtitle: "Control Space reordering and whether activating an app jumps you to its Space.",
            category: .windowsSpaces,
            kind: .multiToggle,
            backingSettingIDs: [
                "dock.mruSpaces",
                "global.switchSpaceOnActivate",
            ],
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

        // G056 — Stage Manager speed (discrete choice)
        GroupedControlDefinition(
            id: "G056",
            title: "Speed up Stage Manager",
            subtitle: "Stage Manager's window-switching animations are slow by default. Make them snappier or near-instant.",
            category: .windowsSpaces,
            kind: .discreteChoice,
            backingSettingIDs: ["windowManager.animationSpeed"],
            options: [
                MappingOption(
                    label: "Default",
                    settingValues: [
                        "windowManager.animationSpeed": .systemDefault,
                    ]
                ),
                MappingOption(
                    label: "Faster",
                    settingValues: [
                        "windowManager.animationSpeed": .explicitValue(.double(0.3)),
                    ]
                ),
                MappingOption(
                    label: "Instant",
                    settingValues: [
                        "windowManager.animationSpeed": .explicitValue(.double(0.1)),
                    ]
                ),
            ]
        ),

        // G062 — Stage Manager controls (multi-toggle card)
        GroupedControlDefinition(
            id: "G062",
            title: "Stage Manager",
            subtitle: "Organizes your windows into a strip on the left. Control whether it's on, whether the strip auto-hides, and whether desktop items are hidden.",
            category: .windowsSpaces,
            kind: .multiToggle,
            backingSettingIDs: [
                "windowManager.stageManager",
                "windowManager.autoHideStrip",
                "windowManager.hideDesktopItems",
            ],
            options: nil
        ),

        // G063 — Window tiling controls (multi-toggle card)
        GroupedControlDefinition(
            id: "G063",
            title: "Window tiling",
            subtitle: "Control how windows snap to edges, whether the Option key helps, and whether tiled windows have gaps.",
            category: .windowsSpaces,
            kind: .multiToggle,
            backingSettingIDs: [
                "windowManager.clickToShowDesktop",
                "windowManager.tilingByEdgeDrag",
                "windowManager.tilingOptionKey",
                "windowManager.topEdgeTiling",
                "windowManager.tiledWindowMargins",
            ],
            options: nil
        ),

        // G064 — Hide desktop icons (simple toggle)
        GroupedControlDefinition(
            id: "G064",
            title: "Hide all desktop icons",
            subtitle: "Hides all files and folders from the desktop. They're still in ~/Desktop, just invisible. Great for a clean look.",
            category: .windowsSpaces,
            kind: .toggle,
            backingSettingIDs: ["windowManager.hideDesktopIcons"],
            options: nil
        ),

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
                "screencapture.includeDate",
                "screencapture.rememberSelection",
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

        // G078 — Developer tools (multi-toggle)
        GroupedControlDefinition(
            id: "G078",
            title: "Developer tools",
            subtitle: "Show build durations in Xcode and enable focus-follows-mouse in Terminal.",
            category: .safariDeveloper,
            kind: .multiToggle,
            backingSettingIDs: [
                "xcode.showBuildDuration",
                "terminal.focusFollowsMouse",
            ],
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

        // G058 — Disable Liquid Glass (simple toggle)
        GroupedControlDefinition(
            id: "G058",
            title: "Disable Liquid Glass",
            subtitle: "Turns off Tahoe's translucent glass rendering and reverts to solid, opaque backgrounds like Sequoia. Requires a reboot. Apple may remove this option in future updates.",
            category: .accessibilityVisual,
            kind: .toggle,
            backingSettingIDs: ["global.disableSolarium"],
            options: nil
        ),

        // G059 — Hide menu bar icons (simple toggle)
        GroupedControlDefinition(
            id: "G059",
            title: "Hide icons in menu dropdowns",
            subtitle: "Tahoe added icons next to every item in dropdown menus. This strips them out for a cleaner, text-only look like Sequoia.",
            category: .accessibilityVisual,
            kind: .toggle,
            backingSettingIDs: ["global.menuActionImages"],
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

        // G068 — Clock display extras (multi-toggle card)
        GroupedControlDefinition(
            id: "G068",
            title: "Clock display options",
            subtitle: "Control what appears in the menu bar clock — seconds, day of week, AM/PM, and analog mode.",
            category: .menuBarStatus,
            kind: .multiToggle,
            backingSettingIDs: [
                "menu.clockShowAMPM",
                "menu.clockShowSeconds",
                "menu.clockShowDayOfWeek",
                "menu.clockAnalog",
            ],
            options: nil
        ),

        // G071 — Menu bar density (multi-control card)
        GroupedControlDefinition(
            id: "G071",
            title: "Menu bar density",
            subtitle: "Auto-hide the menu bar and control how tightly icons are packed. Lower spacing values fit more icons — great if you use a lot of menu bar apps.",
            category: .menuBarStatus,
            kind: .multiControl,
            backingSettingIDs: [
                "menu.autoHideMenuBar",
                "menu.statusItemSpacing",
                "menu.statusItemPadding",
            ],
            options: nil
        ),

        // G069 — Control Center menu bar items (multi-toggle card)
        GroupedControlDefinition(
            id: "G069",
            title: "Control Center items in the menu bar",
            subtitle: "Choose which Control Center items get their own permanent icon in the menu bar.",
            category: .menuBarStatus,
            kind: .multiToggle,
            backingSettingIDs: [
                "menu.ccBluetooth",
                "menu.ccSound",
                "menu.ccNowPlaying",
                "menu.ccFocusModes",
                "menu.ccDisplay",
            ],
            options: nil
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

        // G074 — Screensaver lock (multi-control card)
        GroupedControlDefinition(
            id: "G074",
            title: "Screen lock",
            subtitle: "Require a password when the screensaver is dismissed, and how long to wait before requiring it.",
            category: .securityPrivacy,
            kind: .multiControl,
            backingSettingIDs: [
                "screensaver.askForPassword",
                "screensaver.askForPasswordDelay",
            ],
            options: nil
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
