import Foundation
import os.log

private let logger = Logger(subsystem: "janvanrensburg.PowerChest", category: "Update")

struct AppUpdate: Sendable {
    let version: String
    let url: URL
}

final class UpdateService: Sendable {
    private let repo = "scripsweave/PowerChest"

    /// Checks the latest GitHub release against the current bundle version.
    /// Returns an `AppUpdate` if a newer version is available, nil otherwise.
    func checkForUpdate() async -> AppUpdate? {
        let endpoint = "https://api.github.com/repos/\(repo)/releases/latest"
        guard let url = URL(string: endpoint) else { return nil }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                return nil
            }

            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let tagName = json["tag_name"] as? String,
                  let htmlURL = json["html_url"] as? String,
                  let releaseURL = URL(string: htmlURL) else {
                return nil
            }

            let remoteVersion = tagName.trimmingCharacters(in: CharacterSet(charactersIn: "vV"))
            let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0"

            if remoteVersion.compare(currentVersion, options: .numeric) == .orderedDescending {
                logger.info("Update available: \(remoteVersion) (current: \(currentVersion))")
                return AppUpdate(version: remoteVersion, url: releaseURL)
            }

            logger.info("Up to date (\(currentVersion))")
            return nil
        } catch {
            logger.error("Update check failed: \(error.localizedDescription)")
            return nil
        }
    }
}
