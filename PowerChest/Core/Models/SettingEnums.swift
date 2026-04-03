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
    case privilegedDefaults   // defaults write to system domains (needs admin)
    case privilegedCommand    // shell commands that need admin (networksetup, etc.)
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
    case networkConnectivity
    case internals
}

enum RestartRequirement: Equatable, Hashable, Sendable {
    case none
    case finder
    case dock
    case systemUIServer
    case controlCenter
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
        case .controlCenter: return "Needs menu bar refresh"
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

extension RestartRequirement: Codable {
    private enum CodingKeys: String, CodingKey {
        case type, bundleID
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "none": self = .none
        case "finder": self = .finder
        case "dock": self = .dock
        case "systemUIServer": self = .systemUIServer
        case "controlCenter": self = .controlCenter
        case "safari": self = .safari
        case "signOut": self = .signOut
        case "reboot": self = .reboot
        case "app":
            let bundleID = try container.decode(String.self, forKey: .bundleID)
            self = .app(bundleID: bundleID)
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown RestartRequirement type: \(type)")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .none: try container.encode("none", forKey: .type)
        case .finder: try container.encode("finder", forKey: .type)
        case .dock: try container.encode("dock", forKey: .type)
        case .systemUIServer: try container.encode("systemUIServer", forKey: .type)
        case .controlCenter: try container.encode("controlCenter", forKey: .type)
        case .safari: try container.encode("safari", forKey: .type)
        case .signOut: try container.encode("signOut", forKey: .type)
        case .reboot: try container.encode("reboot", forKey: .type)
        case .app(let bundleID):
            try container.encode("app", forKey: .type)
            try container.encode(bundleID, forKey: .bundleID)
        }
    }
}

struct OSRange: Codable, Sendable {
    let min: Int
    let max: Int?

    func isSupported(on version: Int) -> Bool {
        guard version >= min else { return false }
        guard let max else { return true }
        return version <= max
    }
}

enum UserMode: String, Codable, Sendable {
    case powerUser
    case propellerhead
}
