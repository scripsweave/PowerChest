import Foundation

enum RiskLevel: String, Codable, Sendable {
    case safe
    case advanced
    case systemSensitive
}

enum InterestLevel: String, Codable, Sendable {
    case common
    case obscure
}

enum SupportLevel: String, Codable, Sendable {
    case shipping
    case verify
    case hold
}

enum SettingMechanism: String, Codable, Sendable {
    case defaults
    case command
}

enum SettingValueType: String, Codable, Sendable {
    case bool
    case int
    case double
    case string
    case path
    case `enum`
}

enum DefaultValueStrategy: String, Codable, Sendable {
    case assumeAbsentIsFalse
    case assumeAbsentIsTrue
    case readCurrentState
    case absentIsSystemDefault
}

enum SettingCategory: String, Codable, CaseIterable, Sendable {
    case interface
    case finder
    case keyboardInput
    case windowsSpaces
    case screenshots
    case safariDeveloper
    case menuBarStatus
    case accessibilityVisual
    case securityPrivacy
}

enum RestartRequirement: Codable, Equatable, Hashable, Sendable {
    case none
    case finder
    case dock
    case systemUIServer
    case app(bundleID: String)
    case safari
    case signOut
    case reboot

    var displayName: String {
        switch self {
        case .none: return "No restart needed"
        case .finder: return "Needs Finder restart"
        case .dock: return "Needs Dock restart"
        case .systemUIServer: return "Needs menu bar refresh"
        case .app(let id): return "Needs \(id) restart"
        case .safari: return "Needs Safari relaunch"
        case .signOut: return "Needs sign out"
        case .reboot: return "Needs reboot"
        }
    }

    var isRequired: Bool {
        self != .none
    }
}

struct OSRange: Codable, Sendable {
    let min: Int
    let max: Int?

    func isSupported(on version: Int) -> Bool {
        version >= min && (max == nil || version <= max!)
    }
}

enum UserMode: String, Codable, Sendable {
    case powerUser
    case propellerhead
}
