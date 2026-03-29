import Foundation
import AppKit

final class RestartService {
    func executeRestarts(_ requirements: [RestartRequirement]) -> [RestartAction] {
        let unique = deduplicate(requirements)
        return unique.map { execute($0) }
    }

    private func deduplicate(_ requirements: [RestartRequirement]) -> [RestartRequirement] {
        var seen = Set<String>()
        var result: [RestartRequirement] = []

        // Order: SystemUIServer, Dock, Finder (lightweight first)
        let ordered: [RestartRequirement] = [.systemUIServer, .dock, .finder, .safari, .signOut, .reboot]

        for req in ordered {
            let key = "\(req)"
            if requirements.contains(req), !seen.contains(key) {
                seen.insert(key)
                result.append(req)
            }
        }

        // Handle app-specific restarts
        for req in requirements {
            if case .app = req {
                let key = "\(req)"
                if !seen.contains(key) {
                    seen.insert(key)
                    result.append(req)
                }
            }
        }

        return result
    }

    private func execute(_ requirement: RestartRequirement) -> RestartAction {
        switch requirement {
        case .none:
            return RestartAction(target: .none, result: .completed, userMessage: "")

        case .systemUIServer:
            return killProcess("SystemUIServer",
                              target: .systemUIServer,
                              message: "The menu bar will refresh shortly.")

        case .dock:
            return killProcess("Dock",
                              target: .dock,
                              message: "The Dock will refresh in a moment.")

        case .finder:
            return killProcess("Finder",
                              target: .finder,
                              message: "Finder will briefly relaunch so the change sticks.")

        case .safari:
            let running = NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.Safari")
            if running.isEmpty {
                return RestartAction(
                    target: .safari,
                    result: .completed,
                    userMessage: "Safari is not running. Changes will take effect on next launch."
                )
            } else {
                return RestartAction(
                    target: .safari,
                    result: .deferred(reason: "Safari is running"),
                    userMessage: "Safari needs a relaunch for this change to take effect."
                )
            }

        case .app(let bundleID):
            return killProcess(bundleID, target: requirement,
                              message: "\(bundleID) will restart.")

        case .signOut:
            return RestartAction(
                target: .signOut,
                result: .deferred(reason: "User action required"),
                userMessage: "This change takes effect after you sign out and back in."
            )

        case .reboot:
            return RestartAction(
                target: .reboot,
                result: .deferred(reason: "User action required"),
                userMessage: "A restart is needed for this to stick. No rush — do it when you are ready."
            )
        }
    }

    private func killProcess(_ name: String, target: RestartRequirement, message: String) -> RestartAction {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/killall")
        process.arguments = [name]
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        do {
            try process.run()
            process.waitUntilExit()
            if process.terminationStatus == 0 {
                return RestartAction(target: target, result: .completed, userMessage: message)
            } else {
                return RestartAction(
                    target: target,
                    result: .failed(error: "killall exited with \(process.terminationStatus)"),
                    userMessage: "Could not restart \(name). You may need to restart it manually."
                )
            }
        } catch {
            return RestartAction(
                target: target,
                result: .failed(error: error.localizedDescription),
                userMessage: "Could not restart \(name). You may need to restart it manually."
            )
        }
    }
}
