import Foundation

/// Handles command-mechanism settings that don't use `defaults write`.
/// Each setting ID has custom read/write logic.
final class CommandAdapter: Sendable {

    func read(settingID: String) -> CodableValue? {
        switch settingID {
        case "finder.showLibraryFolder":
            return .bool(isLibraryFolderVisible())
        default:
            return nil
        }
    }

    func keyExists(settingID: String) -> Bool {
        // Command-based settings always "exist" — they have a readable state
        switch settingID {
        case "finder.showLibraryFolder":
            return true
        default:
            return false
        }
    }

    func write(settingID: String, value: CodableValue) throws {
        switch settingID {
        case "finder.showLibraryFolder":
            let show = value.asBool ?? false
            try setLibraryFolderVisible(show)
        default:
            throw CommandAdapterError.unknownSetting(settingID)
        }
    }

    func reset(settingID: String) throws {
        switch settingID {
        case "finder.showLibraryFolder":
            try setLibraryFolderVisible(false) // default is hidden
        default:
            throw CommandAdapterError.unknownSetting(settingID)
        }
    }

    // MARK: - ~/Library visibility

    private func libraryPath() -> String {
        NSHomeDirectory() + "/Library"
    }

    private func isLibraryFolderVisible() -> Bool {
        let path = libraryPath()
        let result = runCommand("/usr/bin/ls", arguments: ["-lOd", path])
        // If the flags contain "hidden", it's invisible
        return !result.output.contains("hidden")
    }

    private func setLibraryFolderVisible(_ visible: Bool) throws {
        let flag = visible ? "nohidden" : "hidden"
        let result = runCommand("/usr/bin/chflags", arguments: [flag, libraryPath()])
        if result.exitCode != 0 {
            throw CommandAdapterError.commandFailed(
                detail: "chflags \(flag) ~/Library failed: \(result.output)"
            )
        }
    }

    // MARK: - Helpers

    private func runCommand(_ path: String, arguments: [String]) -> (output: String, exitCode: Int32) {
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

enum CommandAdapterError: Error, LocalizedError {
    case unknownSetting(String)
    case commandFailed(detail: String)

    var errorDescription: String? {
        switch self {
        case .unknownSetting(let id):
            return "Unknown command setting: \(id)"
        case .commandFailed(let detail):
            return detail
        }
    }
}
