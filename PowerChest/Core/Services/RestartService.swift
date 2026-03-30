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
            return restartBundle(
                bundleID: "com.apple.systemuiserver",
                displayName: "Menu Bar",
                requirement: .systemUIServer,
                successMessage: "The menu bar will refresh shortly."
            )

        case .dock:
            return restartBundle(
                bundleID: "com.apple.dock",
                displayName: "Dock",
                requirement: .dock,
                successMessage: "The Dock will refresh in a moment."
            )

        case .finder:
            return restartBundle(
                bundleID: "com.apple.finder",
                displayName: "Finder",
                requirement: .finder,
                successMessage: "Finder will briefly relaunch so the change sticks."
            )

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
            return restartBundle(
                bundleID: bundleID,
                displayName: bundleID,
                requirement: requirement,
                successMessage: "\(bundleID) will restart."
            )

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

    private func restartBundle(
        bundleID: String,
        displayName: String,
        requirement: RestartRequirement,
        successMessage: String
    ) -> RestartAction {
        let runningApps = NSRunningApplication.runningApplications(withBundleIdentifier: bundleID)
        var terminatedAny = false

        for app in runningApps {
            if app.forceTerminate() {
                terminatedAny = true
            }
        }

        if runningApps.isEmpty {
            terminatedAny = true
        }

        if bundleID == "com.apple.finder" {
            NSWorkspace.shared.launchApplication("Finder")
        }

        if terminatedAny {
            return RestartAction(target: requirement, result: .completed, userMessage: successMessage)
        } else {
            return RestartAction(
                target: requirement,
                result: .failed(error: "Unable to terminate \(displayName)"),
                userMessage: "Could not restart \(displayName). You may need to restart it manually."
            )
        }
    }
}
