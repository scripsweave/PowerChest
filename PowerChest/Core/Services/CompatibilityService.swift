import Foundation

final class CompatibilityService: Sendable {
    let currentOSMajorVersion: Int

    init() {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        self.currentOSMajorVersion = version.majorVersion
    }

    func isSupported(_ definition: SettingDefinition) -> Bool {
        guard definition.supportLevel != .hold else { return false }
        return definition.supportedOS.isSupported(on: currentOSMajorVersion)
    }
}
