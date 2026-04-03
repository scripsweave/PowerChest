import SwiftUI

enum SidebarSection: String, CaseIterable, Identifiable {
    case home
    case settings
    case utilities
    case app

    var id: String { rawValue }
}

enum SidebarItem: String, CaseIterable, Identifiable {
    case home
    case dockAndInterface
    case finderAndFiles
    case keyboardAndInput
    case windowsAndSpaces
    case screenshots
    case appsAndDeveloper
    case visualsAndAccessibility
    case menuBar
    case internals
    case safetyAndSecurity
    case networkAndConnectivity
    case snapshots
    case changes
    case appSettings

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .home: return "Home"
        case .dockAndInterface: return "Dock & Interface"
        case .finderAndFiles: return "Finder & Files"
        case .keyboardAndInput: return "Keyboard & Input"
        case .windowsAndSpaces: return "Windows & Spaces"
        case .screenshots: return "Screenshots"
        case .appsAndDeveloper: return "Apps & Developer"
        case .visualsAndAccessibility: return "Visuals & Accessibility"
        case .menuBar: return "Menu Bar"
        case .internals: return "Internals"
        case .safetyAndSecurity: return "Safety & Security"
        case .networkAndConnectivity: return "Network & Connectivity"
        case .snapshots: return "Time Machine"
        case .changes: return "Changes"
        case .appSettings: return "PowerChest"
        }
    }

    var systemImage: String {
        switch self {
        case .home: return "house.fill"
        case .dockAndInterface: return "dock.rectangle"
        case .finderAndFiles: return "folder.fill"
        case .keyboardAndInput: return "keyboard.fill"
        case .windowsAndSpaces: return "rectangle.on.rectangle"
        case .screenshots: return "camera.viewfinder"
        case .appsAndDeveloper: return "wrench.and.screwdriver.fill"
        case .visualsAndAccessibility: return "eye.fill"
        case .menuBar: return "menubar.rectangle"
        case .internals: return "gearshape.2.fill"
        case .safetyAndSecurity: return "shield.fill"
        case .networkAndConnectivity: return "network"
        case .snapshots: return "clock.arrow.circlepath"
        case .changes: return "list.bullet.clipboard.fill"
        case .appSettings: return "gearshape.fill"
        }
    }

    var iconColor: Color {
        switch self {
        case .home: return .blue
        case .dockAndInterface: return .indigo
        case .finderAndFiles: return .blue
        case .keyboardAndInput: return .gray
        case .windowsAndSpaces: return .purple
        case .screenshots: return .pink
        case .appsAndDeveloper: return .cyan
        case .visualsAndAccessibility: return .teal
        case .menuBar: return .mint
        case .internals: return .brown
        case .safetyAndSecurity: return .red
        case .networkAndConnectivity: return .blue
        case .snapshots: return .orange
        case .changes: return .yellow
        case .appSettings: return .gray
        }
    }

    var section: SidebarSection {
        switch self {
        case .home: return .home
        case .dockAndInterface, .finderAndFiles, .keyboardAndInput, .windowsAndSpaces,
             .screenshots, .appsAndDeveloper, .visualsAndAccessibility, .menuBar,
             .internals, .safetyAndSecurity, .networkAndConnectivity:
            return .settings
        case .snapshots, .changes: return .utilities
        case .appSettings: return .app
        }
    }

    var settingCategory: SettingCategory? {
        switch self {
        case .dockAndInterface: return .interface
        case .finderAndFiles: return .finder
        case .keyboardAndInput: return .keyboardInput
        case .windowsAndSpaces: return .windowsSpaces
        case .screenshots: return .screenshots
        case .appsAndDeveloper: return .safariDeveloper
        case .visualsAndAccessibility: return .accessibilityVisual
        case .menuBar: return .menuBarStatus
        case .internals: return .internals
        case .safetyAndSecurity: return .securityPrivacy
        case .networkAndConnectivity: return .networkConnectivity
        default: return nil
        }
    }

    static var settingsItems: [SidebarItem] {
        allCases.filter { $0.section == .settings }
    }

    static var utilityItems: [SidebarItem] {
        allCases.filter { $0.section == .utilities }
    }

    var categoryDescription: String? {
        switch self {
        case .dockAndInterface: return "Dock size, magnification, scroll bars, dialogs, and interface behavior."
        case .finderAndFiles: return "Hidden files, path bars, extensions, desktop drives, and folder sorting."
        case .keyboardAndInput: return "Key repeat, accents, autocorrect, trackpad gestures, and typing shortcuts."
        case .windowsAndSpaces: return "Window tiling, hot corners, Stage Manager, Mission Control, and Spaces."
        case .screenshots: return "Screenshot format, location, shadows, and filename options."
        case .appsAndDeveloper: return "TextEdit, Activity Monitor, Help Viewer, Xcode, Terminal, and Safari."
        case .visualsAndAccessibility: return "Transparency, contrast, motion, animations, and pointer size."
        case .menuBar: return "Clock display, Control Center items, menu bar density, and notifications."
        case .internals: return "Under-the-hood system behaviors most people never need to touch."
        case .safetyAndSecurity: return "Quarantine, crash reports, screen lock, login window, and AI."
        case .networkAndConnectivity: return "Firewall, DNS, AirDrop, remote access, and network privacy."
        default: return nil
        }
    }
}
