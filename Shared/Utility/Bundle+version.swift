import UIKit

extension Bundle {
    var releaseVersion: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersion: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var version: String?{
        "\(releaseVersion ?? "??").\(buildVersion ?? "??")"
    }
}
