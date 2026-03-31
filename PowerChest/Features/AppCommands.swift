import SwiftUI
import AppKit

// MARK: - Notification triggers for UI-bound actions

extension Notification.Name {
    static let menuCreateSnapshot = Notification.Name("PowerChest.menuCreateSnapshot")
    static let menuRestoreSnapshot = Notification.Name("PowerChest.menuRestoreSnapshot")
    static let menuExportConfig = Notification.Name("PowerChest.menuExportConfig")
    static let menuImportConfig = Notification.Name("PowerChest.menuImportConfig")
    static let menuSavePreset = Notification.Name("PowerChest.menuSavePreset")
    static let menuResetToDefaults = Notification.Name("PowerChest.menuResetToDefaults")
}

// MARK: - File Menu

struct FileCommands: Commands {
    var body: some Commands {
        CommandGroup(replacing: .saveItem) {
            Button("Create Snapshot") {
                NotificationCenter.default.post(name: .menuCreateSnapshot, object: nil)
            }
            .keyboardShortcut("s", modifiers: .command)

            Button("Restore Snapshot...") {
                NotificationCenter.default.post(name: .menuRestoreSnapshot, object: nil)
            }
            .keyboardShortcut("s", modifiers: [.command, .shift])

            Divider()

            Button("Export Config...") {
                NotificationCenter.default.post(name: .menuExportConfig, object: nil)
            }
            .keyboardShortcut("e", modifiers: .command)

            Button("Import Config...") {
                NotificationCenter.default.post(name: .menuImportConfig, object: nil)
            }
            .keyboardShortcut("i", modifiers: .command)

            Divider()

            Button("Save as Preset...") {
                NotificationCenter.default.post(name: .menuSavePreset, object: nil)
            }
            .keyboardShortcut("p", modifiers: [.command, .shift])
        }
    }
}

// MARK: - Edit Menu (Undo + Reset)

struct EditCommands: Commands {
    @Bindable var appState: AppState

    var body: some Commands {
        CommandGroup(after: .undoRedo) {
            let lastChange = appState.lastChangeDescription

            Button("Undo \(lastChange ?? "Last Change")") {
                let success = appState.undoLastChange()
                if success {
                    appState.presentToast(title: "Undone", subtitle: lastChange, icon: "arrow.uturn.backward")
                }
            }
            .keyboardShortcut("z", modifiers: .command)
            .disabled(lastChange == nil)

            Divider()

            Button("Reset to macOS Defaults...") {
                NotificationCenter.default.post(name: .menuResetToDefaults, object: nil)
            }
        }
    }
}

// MARK: - View Menu

struct ViewCommands: Commands {
    @Bindable var appState: AppState

    var body: some Commands {
        CommandGroup(after: .toolbar) {
            Button("Power User Mode") {
                appState.userMode = .powerUser
            }
            .keyboardShortcut("1", modifiers: .command)

            Button("Propellerhead Mode") {
                appState.userMode = .propellerhead
            }
            .keyboardShortcut("2", modifiers: .command)

            Divider()

            Button("Go to Home") {
                appState.selectedSidebarItem = .home
            }
            .keyboardShortcut("0", modifiers: .command)

            Button("Show Changes") {
                appState.selectedSidebarItem = .changes
            }
            .keyboardShortcut("l", modifiers: .command)

            Button("Show Snapshots") {
                appState.selectedSidebarItem = .snapshots
            }
            .keyboardShortcut("t", modifiers: .command)
        }
    }
}

// MARK: - Help Menu

struct HelpCommands: Commands {
    var body: some Commands {
        CommandGroup(replacing: .help) {
            Button("PowerChest Website") {
                NSWorkspace.shared.open(URL(string: "https://powerchest.app")!)
            }

            Button("Report an Issue...") {
                NSWorkspace.shared.open(URL(string: "https://github.com/scripsweave/PowerChest/issues")!)
            }

            Divider()

            let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "?"
            Button("What's New in \(version)") {
                NSWorkspace.shared.open(URL(string: "https://github.com/scripsweave/PowerChest/releases/tag/v\(version)")!)
            }
        }
    }
}

// MARK: - App Menu (About + Update)

struct AppMenuCommands: Commands {
    @Bindable var appState: AppState

    var body: some Commands {
        CommandGroup(after: .appInfo) {
            Button("Check for Updates...") {
                appState.checkForUpdate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    if let update = appState.availableUpdate {
                        let alert = NSAlert()
                        alert.messageText = "PowerChest \(update.version) is available"
                        alert.informativeText = "A new version is ready to download."
                        alert.alertStyle = .informational
                        alert.addButton(withTitle: "Download")
                        alert.addButton(withTitle: "Later")
                        if alert.runModal() == .alertFirstButtonReturn {
                            NSWorkspace.shared.open(update.url)
                        }
                    } else {
                        let alert = NSAlert()
                        alert.messageText = "You're up to date"
                        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "?"
                        alert.informativeText = "PowerChest \(version) is the latest version."
                        alert.alertStyle = .informational
                        alert.addButton(withTitle: "OK")
                        alert.runModal()
                    }
                }
            }

            Button("Settings...") {
                appState.selectedSidebarItem = .appSettings
                NSApp.activate(ignoringOtherApps: true)
            }
            .keyboardShortcut(",", modifiers: .command)

            Divider()
        }
    }
}
