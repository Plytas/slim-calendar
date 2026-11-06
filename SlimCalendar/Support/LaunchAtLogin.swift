import OSLog
import ServiceManagement

enum LaunchAtLogin {
    private static let logger = Logger(subsystem: "com.vytas.slimcalendar", category: "LaunchAtLogin")

    static var isEnabled: Bool {
        SMAppService.mainApp.status == .enabled
    }

    static func toggle() {
        do {
            if isEnabled {
                try SMAppService.mainApp.unregister()
            } else {
                try SMAppService.mainApp.register()
            }
        } catch {
            logger.error("Could not change launch at login: \(error.localizedDescription)")
        }
    }
}
