import Foundation
import os.log

private let logger = Logger(subsystem: "janvanrensburg.PowerChest", category: "DefaultsAdapter")

enum DefaultsAdapterError: Error, LocalizedError {
    case writeFailed(domain: String, key: String, detail: String)
    case deleteFailed(domain: String, key: String, detail: String)
    case readFailed(domain: String, key: String, detail: String)

    var errorDescription: String? {
        switch self {
        case .writeFailed(let d, let k, let detail):
            return "Failed to write \(d) \(k): \(detail)"
        case .deleteFailed(let d, let k, let detail):
            return "Failed to delete \(d) \(k): \(detail)"
        case .readFailed(let d, let k, let detail):
            return "Failed to read \(d) \(k): \(detail)"
        }
    }
}

final class DefaultsAdapter: Sendable {

    func read(domain: String, key: String) -> (value: String?, exists: Bool) {
        // Use UserDefaults for fast in-memory reads instead of spawning a process
        if let defaults = UserDefaults(suiteName: domain) {
            let obj = defaults.object(forKey: key)
            if let obj {
                return ("\(obj)", true)
            }
            return (nil, false)
        }
        // Fallback to CLI for domains UserDefaults can't open
        let result = runDefaults(["read", domain, key])
        if result.exitCode == 0 {
            return (result.output.trimmingCharacters(in: .whitespacesAndNewlines), true)
        }
        return (nil, false)
    }

    func write(domain: String, key: String, value: CodableValue, valueType: SettingValueType) throws {
        var args = ["write", domain, key]
        switch value {
        case .bool(let v):
            args.append("-bool")
            args.append(v ? "true" : "false")
        case .int(let v):
            args.append("-int")
            args.append("\(v)")
        case .double(let v):
            args.append("-float")
            args.append("\(v)")
        case .string(let v), .path(let v):
            args.append("-string")
            args.append(v)
        }
        let result = runDefaults(args)
        if result.exitCode != 0 {
            throw DefaultsAdapterError.writeFailed(
                domain: domain, key: key,
                detail: result.output.isEmpty ? "exit code \(result.exitCode)" : result.output
            )
        }
    }

    func delete(domain: String, key: String) throws {
        let result = runDefaults(["delete", domain, key])
        // Exit code 1 with "does not exist" is fine — key is already absent
        if result.exitCode != 0 && !result.output.contains("does not exist") {
            throw DefaultsAdapterError.deleteFailed(
                domain: domain, key: key,
                detail: result.output.isEmpty ? "exit code \(result.exitCode)" : result.output
            )
        }
    }

    func readParsed(domain: String, key: String, valueType: SettingValueType) -> CodableValue? {
        // Fast path: read native types directly via UserDefaults (no process spawn)
        if let defaults = UserDefaults(suiteName: domain) {
            let obj = defaults.object(forKey: key)
            guard let obj else { return nil }

            switch valueType {
            case .bool:
                if let b = obj as? Bool { return .bool(b) }
                if let n = obj as? NSNumber { return .bool(n.boolValue) }
                if let s = obj as? String {
                    let lower = s.lowercased()
                    if lower == "true" || lower == "1" { return .bool(true) }
                    if lower == "false" || lower == "0" { return .bool(false) }
                }
                logger.warning("Cannot parse bool for \(domain)/\(key): \(String(describing: obj))")
                return nil
            case .int:
                if let n = obj as? NSNumber { return .int(n.intValue) }
                if let s = obj as? String, let v = Int(s) { return .int(v) }
                logger.warning("Cannot parse int for \(domain)/\(key): \(String(describing: obj))")
                return nil
            case .double:
                if let n = obj as? NSNumber { return .double(n.doubleValue) }
                if let s = obj as? String, let v = Double(s) { return .double(v) }
                logger.warning("Cannot parse double for \(domain)/\(key): \(String(describing: obj))")
                return nil
            case .string, .enum:
                if let s = obj as? String { return .string(s) }
                return .string("\(obj)")
            case .path:
                if let s = obj as? String { return .path(s) }
                return .path("\(obj)")
            }
        }

        // Fallback: parse from CLI output
        let (raw, exists) = read(domain: domain, key: key)
        guard exists, let raw else { return nil }

        switch valueType {
        case .bool:
            let lower = raw.lowercased()
            if lower == "1" || lower == "true" { return .bool(true) }
            if lower == "0" || lower == "false" { return .bool(false) }
            if let intVal = Int(raw) { return .bool(intVal != 0) }
            logger.warning("Cannot parse bool from '\(raw)' for \(domain)/\(key)")
            return nil
        case .int:
            if let v = Int(raw) { return .int(v) }
            if let v = Double(raw) { return .int(Int(v)) }
            logger.warning("Cannot parse int from '\(raw)' for \(domain)/\(key)")
            return nil
        case .double:
            if let v = Double(raw) { return .double(v) }
            logger.warning("Cannot parse double from '\(raw)' for \(domain)/\(key)")
            return nil
        case .string, .enum:
            return .string(raw)
        case .path:
            return .path(raw)
        }
    }

    func keyExists(domain: String, key: String) -> Bool {
        if let defaults = UserDefaults(suiteName: domain) {
            return defaults.object(forKey: key) != nil
        }
        return read(domain: domain, key: key).exists
    }

    private func runDefaults(_ arguments: [String]) -> (output: String, exitCode: Int32) {
        let process = Process()
        let pipe = Pipe()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/defaults")
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
