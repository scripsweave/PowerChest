import Foundation
import os.log

private let logger = Logger(subsystem: "janvanrensburg.PowerChest", category: "PrivilegedAdapter")

/// Executes commands and defaults writes that require admin privileges.
/// Uses AppleScript "with administrator privileges" which shows the native macOS password dialog.
/// macOS caches the auth for ~5 minutes so bulk changes only prompt once.
final class PrivilegedAdapter: Sendable {

    // MARK: - Privileged defaults

    func readParsed(domain: String, key: String, valueType: SettingValueType) -> CodableValue? {
        // System-level plists can be read without root via defaults read
        let result = runUnprivileged("/usr/bin/defaults", arguments: ["read", domain, key])
        guard result.exitCode == 0 else { return nil }
        let raw = result.output.trimmingCharacters(in: .whitespacesAndNewlines)

        switch valueType {
        case .bool:
            let lower = raw.lowercased()
            if lower == "1" || lower == "true" { return .bool(true) }
            if lower == "0" || lower == "false" { return .bool(false) }
            if let n = Int(raw) { return .bool(n != 0) }
            return nil
        case .int:
            if let v = Int(raw) { return .int(v) }
            if let v = Double(raw) { return .int(Int(v)) }
            return nil
        case .double:
            if let v = Double(raw) { return .double(v) }
            return nil
        case .string, .enum:
            return .string(raw)
        case .path:
            return .path(raw)
        }
    }

    func keyExists(domain: String, key: String) -> Bool {
        let result = runUnprivileged("/usr/bin/defaults", arguments: ["read", domain, key])
        return result.exitCode == 0
    }

    func writeDefaults(domain: String, key: String, value: CodableValue, valueType: SettingValueType) throws {
        var args = "defaults write '\(domain)' '\(key)'"
        switch value {
        case .bool(let v):
            args += " -bool \(v ? "true" : "false")"
        case .int(let v):
            args += " -int \(v)"
        case .double(let v):
            args += " -float \(v)"
        case .string(let v), .path(let v):
            args += " -string '\(v.replacingOccurrences(of: "'", with: "'\\''"))'"
        }
        try runPrivileged(args)
    }

    func deleteDefaults(domain: String, key: String) throws {
        try runPrivileged("defaults delete '\(domain)' '\(key)'")
    }

    // MARK: - Privileged commands

    func read(settingID: String) -> CodableValue? {
        switch settingID {
        case "network.captivePortal":
            let result = runUnprivileged("/usr/bin/defaults", arguments: [
                "read", "/Library/Preferences/SystemConfiguration/com.apple.captive.control", "Active"
            ])
            if result.exitCode == 0 {
                let raw = result.output.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                return .bool(raw == "1" || raw == "true")
            }
            return .bool(true) // default is enabled

        case "network.firewallEnabled":
            let result = runUnprivileged("/usr/libexec/ApplicationFirewall/socketfilterfw", arguments: ["--getglobalstate"])
            return .bool(result.output.contains("enabled"))

        case "network.firewallStealth":
            let result = runUnprivileged("/usr/libexec/ApplicationFirewall/socketfilterfw", arguments: ["--getstealthmode"])
            return .bool(result.output.contains("enabled"))

        case "network.firewallBlockAll":
            let result = runUnprivileged("/usr/libexec/ApplicationFirewall/socketfilterfw", arguments: ["--getblockall"])
            return .bool(result.output.contains("enabled"))

        case "network.remoteLogin":
            let result = runUnprivileged("/usr/sbin/systemsetup", arguments: ["-getremotelogin"])
            return .bool(result.output.lowercased().contains(": on"))

        case "network.ipv6Wi-Fi":
            let result = runUnprivileged("/usr/sbin/networksetup", arguments: ["-getinfo", "Wi-Fi"])
            let lines = result.output.components(separatedBy: "\n")
            let ipv6Line = lines.first { $0.hasPrefix("IPv6:") }
            let isOn = ipv6Line?.contains("Automatic") ?? true
            return .bool(isOn)

        case "network.macAddressEthernet":
            // Read MAC from first available interface
            if let iface = listInterfaces().first {
                return .string(iface.mac)
            }
            return nil

        default:
            return nil
        }
    }

    func commandKeyExists(settingID: String) -> Bool {
        // All privileged command settings always have a readable state
        switch settingID {
        case "network.captivePortal", "network.firewallEnabled", "network.firewallStealth",
             "network.firewallBlockAll", "network.remoteLogin", "network.ipv6Wi-Fi",
             "network.macAddressEthernet":
            return true
        default:
            return false
        }
    }

    func writeCommand(settingID: String, value: CodableValue) throws {
        switch settingID {
        case "network.captivePortal":
            let enabled = value.asBool ?? false
            try runPrivileged("defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool \(enabled ? "true" : "false")")

        case "network.firewallEnabled":
            let enabled = value.asBool ?? false
            try runPrivileged("/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate \(enabled ? "on" : "off")")

        case "network.firewallStealth":
            let enabled = value.asBool ?? false
            try runPrivileged("/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode \(enabled ? "on" : "off")")

        case "network.firewallBlockAll":
            let enabled = value.asBool ?? false
            try runPrivileged("/usr/libexec/ApplicationFirewall/socketfilterfw --setblockall \(enabled ? "on" : "off")")

        case "network.remoteLogin":
            let enabled = value.asBool ?? false
            try runPrivileged("systemsetup -setremotelogin \(enabled ? "on" : "off")")

        case "network.ipv6Wi-Fi":
            let enabled = value.asBool ?? false
            if enabled {
                try runPrivileged("networksetup -setv6automatic Wi-Fi")
            } else {
                try runPrivileged("networksetup -setv6off Wi-Fi")
            }

        case "network.macAddressEthernet":
            guard let mac = value.asString else {
                throw PrivilegedAdapterError.commandFailed(detail: "Invalid MAC address")
            }
            guard let iface = listInterfaces().first else {
                throw PrivilegedAdapterError.commandFailed(detail: "No network interface found")
            }
            try spoofMAC(interface: iface.id, mac: mac)

        default:
            throw PrivilegedAdapterError.unknownSetting(settingID)
        }
    }

    func resetCommand(settingID: String) throws {
        switch settingID {
        case "network.captivePortal":
            try runPrivileged("defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool true")
        case "network.firewallEnabled":
            try runPrivileged("/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate off")
        case "network.firewallStealth":
            try runPrivileged("/usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode off")
        case "network.firewallBlockAll":
            try runPrivileged("/usr/libexec/ApplicationFirewall/socketfilterfw --setblockall off")
        case "network.remoteLogin":
            try runPrivileged("systemsetup -setremotelogin off")
        case "network.ipv6Wi-Fi":
            try runPrivileged("networksetup -setv6automatic Wi-Fi")
        case "network.macAddressEthernet":
            // Reset means randomize — there's no "original" to restore (it reverts on reboot)
            guard let iface = listInterfaces().first else {
                throw PrivilegedAdapterError.commandFailed(detail: "No network interface found")
            }
            try spoofMAC(interface: iface.id, mac: Self.generateRandomMAC())
        default:
            throw PrivilegedAdapterError.unknownSetting(settingID)
        }
    }

    // MARK: - One-shot actions

    func flushDNSCache() throws {
        try runPrivileged("dscacheutil -flushcache; killall -HUP mDNSResponder")
    }

    func spoofMAC(interface: String, mac: String) throws {
        let macRegex = /^([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}$/
        guard mac.wholeMatch(of: macRegex) != nil else {
            throw PrivilegedAdapterError.commandFailed(detail: "Invalid MAC format. Use XX:XX:XX:XX:XX:XX")
        }
        // Validate interface name (alphanumeric only, prevent injection)
        guard interface.allSatisfy({ $0.isLetter || $0.isNumber }) else {
            throw PrivilegedAdapterError.commandFailed(detail: "Invalid interface name")
        }
        try runPrivileged("ifconfig \(interface) ether \(mac)")
    }

    // MARK: - Network interface discovery

    struct NetworkInterface: Identifiable, Hashable {
        let id: String       // e.g. "en0"
        let name: String     // e.g. "Wi-Fi" or "Ethernet Adapter (en3)"
        let mac: String      // current MAC address
        var isWiFi: Bool { name.contains("Wi-Fi") }
    }

    func listInterfaces() -> [NetworkInterface] {
        let result = runUnprivileged("/usr/sbin/networksetup", arguments: ["-listallhardwareports"])
        guard result.exitCode == 0 else { return [] }

        var interfaces: [NetworkInterface] = []
        let blocks = result.output.components(separatedBy: "\n\n")
        for block in blocks {
            let lines = block.components(separatedBy: "\n")
            var name: String?
            var device: String?
            var mac: String?
            for line in lines {
                if line.hasPrefix("Hardware Port: ") {
                    name = String(line.dropFirst("Hardware Port: ".count))
                } else if line.hasPrefix("Device: ") {
                    device = String(line.dropFirst("Device: ".count))
                } else if line.hasPrefix("Ethernet Address: ") {
                    mac = String(line.dropFirst("Ethernet Address: ".count))
                }
            }
            if let name, let device, let mac, device.hasPrefix("en") {
                interfaces.append(NetworkInterface(id: device, name: name, mac: mac))
            }
        }
        return interfaces
    }

    func readMAC(interface: String) -> String? {
        let result = runUnprivileged("/sbin/ifconfig", arguments: [interface])
        let lines = result.output.components(separatedBy: "\n")
        if let etherLine = lines.first(where: { $0.contains("ether ") }) {
            return etherLine.trimmingCharacters(in: .whitespaces)
                .replacingOccurrences(of: "ether ", with: "")
                .trimmingCharacters(in: .whitespaces)
        }
        return nil
    }

    /// Generates a random locally-administered unicast MAC address.
    static func generateRandomMAC() -> String {
        var bytes = (0..<6).map { _ in UInt8.random(in: 0...255) }
        bytes[0] = (bytes[0] | 0x02) & 0xFE  // locally administered, unicast
        return bytes.map { String(format: "%02x", $0) }.joined(separator: ":")
    }

    // MARK: - Execution

    private func runPrivileged(_ command: String) throws {
        let escaped = command.replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
        let source = "do shell script \"\(escaped)\" with administrator privileges"
        let script = NSAppleScript(source: source)
        var errorDict: NSDictionary?
        script?.executeAndReturnError(&errorDict)

        if let error = errorDict {
            let message = error[NSAppleScript.errorMessage] as? String ?? "Unknown error"
            // User cancelled the auth dialog
            if let code = error[NSAppleScript.errorNumber] as? Int, code == -128 {
                throw PrivilegedAdapterError.userCancelled
            }
            logger.error("Privileged command failed: \(message)")
            throw PrivilegedAdapterError.commandFailed(detail: message)
        }
    }

    private func runUnprivileged(_ path: String, arguments: [String]) -> (output: String, exitCode: Int32) {
        let process = Process()
        let pipe = Pipe()
        process.executableURL = URL(fileURLWithPath: path)
        process.arguments = arguments
        process.standardOutput = pipe
        process.standardError = pipe

        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            return (error.localizedDescription, -1)
        }

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        return (output, process.terminationStatus)
    }
}

enum PrivilegedAdapterError: Error, LocalizedError {
    case unknownSetting(String)
    case commandFailed(detail: String)
    case userCancelled

    var errorDescription: String? {
        switch self {
        case .unknownSetting(let id):
            return "Unknown privileged setting: \(id)"
        case .commandFailed(let detail):
            return detail
        case .userCancelled:
            return "Authentication was cancelled."
        }
    }
}
