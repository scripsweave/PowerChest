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
    case visualsAndAccessibility
    case menuBar
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
        case .visualsAndAccessibility: return "Visuals & Accessibility"
        case .menuBar: return "Menu Bar"
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
        case .visualsAndAccessibility: return "eye.fill"
        case .menuBar: return "menubar.rectangle"
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
        case .visualsAndAccessibility: return .teal
        case .menuBar: return .mint
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
             .screenshots, .visualsAndAccessibility, .menuBar,
             .safetyAndSecurity, .networkAndConnectivity:
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
        case .visualsAndAccessibility: return .accessibilityVisual
        case .menuBar: return .menuBarStatus
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
        case .dockAndInterface: return "Dock size, magnification, hot corners, window behavior, and dialog defaults."
        case .finderAndFiles: return "Hidden files, path bars, extensions, desktop drives, and folder sorting."
        case .keyboardAndInput: return "Key repeat, accents, autocorrect, trackpad gestures, and typing shortcuts."
        case .windowsAndSpaces: return "Mission Control, Stage Manager, window tiling, and desktop spaces."
        case .screenshots: return "Screenshot format, location, shadows, and filename options."
        case .visualsAndAccessibility: return "Transparency, contrast, motion, and pointer size."
        case .menuBar: return "Clock display, Control Center items, menu bar density, and status items."
        case .safetyAndSecurity: return "Quarantine, crash reports, screen lock, and login window."
        case .networkAndConnectivity: return "Firewall, DNS, AirDrop, .DS_Store, and network privacy."
        default: return nil
        }
    }
}
