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

    /// Shell-safe single-quote escaping: wraps in single quotes, escapes any embedded single quotes.
    private func shellQuote(_ s: String) -> String {
        "'" + s.replacingOccurrences(of: "'", with: "'\\''") + "'"
    }

    func writeDefaults(domain: String, key: String, value: CodableValue, valueType: SettingValueType) throws {
        var args = "defaults write \(shellQuote(domain)) \(shellQuote(key))"
        switch value {
        case .bool(let v):
            args += " -bool \(v ? "true" : "false")"
        case .int(let v):
            args += " -int \(v)"
        case .double(let v):
            args += " -float \(v)"
        case .string(let v), .path(let v):
            args += " -string \(shellQuote(v))"
        }
        try runPrivileged(args)
    }

    func deleteDefaults(domain: String, key: String) throws {
        try runPrivileged("defaults delete \(shellQuote(domain)) \(shellQuote(key))")
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
            // Output: "Firewall stealth mode is on" or "Firewall stealth mode is off"
            let lower = result.output.lowercased()
            return .bool(lower.contains("mode is on") || lower.contains("mode enabled"))

        case "network.firewallBlockAll":
            let result = runUnprivileged("/usr/libexec/ApplicationFirewall/socketfilterfw", arguments: ["--getblockall"])
            return .bool(result.output.contains("enabled"))

        case "network.remoteLogin":
            let result = runUnprivileged("/usr/sbin/systemsetup", arguments: ["-getremotelogin"])
            if result.output.contains("administrator access") {
                // macOS 26+: systemsetup requires admin even for reads.
                // Fall back: check if sshd is loaded in the system domain.
                let launchctl = runUnprivileged("/bin/launchctl", arguments: ["print", "system/com.openssh.sshd"])
                // "Could not find service" means SSH is off; any other output means it's loaded.
                return .bool(!launchctl.output.contains("Could not find service"))
            }
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
            // systemsetup can hang — always run outside batch with timeout
            let enabled = value.asBool ?? false
            try runPrivilegedDirect("systemsetup -setremotelogin \(enabled ? "on" : "off")")

        case "network.ipv6Wi-Fi":
            // networksetup can hang indefinitely — always run outside batch
            // with a shell-level timeout so it doesn't block other commands
            let enabled = value.asBool ?? false
            let cmd = enabled ? "networksetup -setv6automatic Wi-Fi" : "networksetup -setv6off Wi-Fi"
            try runPrivilegedDirect(cmd)

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
            // systemsetup can hang — always run outside batch with timeout
            try runPrivilegedDirect("systemsetup -setremotelogin off")
        case "network.ipv6Wi-Fi":
            // networksetup can hang — always run outside batch with timeout
            try runPrivilegedDirect("networksetup -setv6automatic Wi-Fi")
        case "network.macAddressEthernet":
            // MAC address is temporary (reverts on reboot) — skip in bulk resets
            break
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

    // MARK: - Batch execution (single password prompt for multiple commands)

    /// Collects commands to be executed in a single privileged batch.
    /// Call `addToBatch` for each command, then `executeBatch` once.
    private var batchCommands: [String] = []
    private var batchActive = false

    func beginBatch() {
        batchCommands = []
        batchActive = true
    }

    func executeBatch() throws {
        batchActive = false
        guard !batchCommands.isEmpty else { return }
        let joined = batchCommands.joined(separator: "; ")
        batchCommands = []
        try runPrivilegedDirect(joined)
    }

    func cancelBatch() {
        batchActive = false
        batchCommands = []
    }

    // MARK: - Execution

    private func runPrivileged(_ command: String) throws {
        if batchActive {
            batchCommands.append(command)
            return
        }
        try runPrivilegedDirect(command)
    }

    private func runPrivilegedDirect(_ command: String) throws {
        // Use osascript process instead of NSAppleScript to avoid memory leaks
        let escaped = command.replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
        let script = "do shell script \"\(escaped)\" with administrator privileges"

        let process = Process()
        let stdoutPipe = Pipe()
        let stderrPipe = Pipe()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
        process.arguments = ["-e", script]
        process.standardOutput = stdoutPipe
        process.standardError = stderrPipe

        // Read output asynchronously to prevent pipe buffer deadlock.
        // If the process writes enough to fill the ~64KB pipe buffer before we
        // read, it blocks — while we block on waitUntilExit(). Deadlock.
        var stdoutData = Data()
        var stderrData = Data()
        let stdoutHandle = stdoutPipe.fileHandleForReading
        let stderrHandle = stderrPipe.fileHandleForReading
        let group = DispatchGroup()

        group.enter()
        DispatchQueue.global(qos: .userInitiated).async {
            stdoutData = stdoutHandle.readDataToEndOfFile()
            group.leave()
        }
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async {
            stderrData = stderrHandle.readDataToEndOfFile()
            group.leave()
        }

        do {
            try process.run()
        } catch {
            group.wait()
            throw PrivilegedAdapterError.commandFailed(detail: error.localizedDescription)
        }

        // Timeout after 30 seconds — networksetup commands can hang indefinitely
        let deadline = DispatchTime.now() + .seconds(30)
        let completed = DispatchSemaphore(value: 0)

        DispatchQueue.global(qos: .userInitiated).async {
            process.waitUntilExit()
            completed.signal()
        }

        if completed.wait(timeout: deadline) == .timedOut {
            process.terminate()
            // Close pipes so async readers get EOF and unblock
            try? stdoutPipe.fileHandleForWriting.close()
            try? stderrPipe.fileHandleForWriting.close()
            // Wait for readers with a timeout to avoid permanent hang
            _ = group.wait(timeout: .now() + .seconds(5))
            throw PrivilegedAdapterError.commandFailed(detail: "Command timed out after 30 seconds")
        }

        group.wait()

        if process.terminationStatus != 0 {
            let output = String(data: stderrData, encoding: .utf8)
                ?? String(data: stdoutData, encoding: .utf8) ?? ""
            if output.contains("-128") || output.contains("User canceled") {
                throw PrivilegedAdapterError.userCancelled
            }
            logger.error("Privileged command failed: \(output)")
            throw PrivilegedAdapterError.commandFailed(detail: output.isEmpty ? "Exit code \(process.terminationStatus)" : output)
        }
    }

    private func runUnprivileged(_ path: String, arguments: [String]) -> (output: String, exitCode: Int32) {
        let process = Process()
        let stdoutPipe = Pipe()
        let stderrPipe = Pipe()
        process.executableURL = URL(fileURLWithPath: path)
        process.arguments = arguments
        process.standardOutput = stdoutPipe
        process.standardError = stderrPipe

        // Read output asynchronously to prevent pipe buffer deadlock
        var stdoutData = Data()
        let stdoutHandle = stdoutPipe.fileHandleForReading
        let group = DispatchGroup()

        group.enter()
        DispatchQueue.global(qos: .userInitiated).async {
            stdoutData = stdoutHandle.readDataToEndOfFile()
            group.leave()
        }

        // Drain stderr so the pipe doesn't fill up
        let stderrHandle = stderrPipe.fileHandleForReading
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async {
            _ = stderrHandle.readDataToEndOfFile()
            group.leave()
        }

        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            group.wait()
            return (error.localizedDescription, -1)
        }

        group.wait()
        let output = String(data: stdoutData, encoding: .utf8) ?? ""
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
