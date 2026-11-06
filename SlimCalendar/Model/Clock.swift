import AppKit
import Observation

/// Tracks "today" and updates when the date changes: at midnight, after
/// wake from sleep, and when the time zone changes.
@MainActor
@Observable
final class Clock {
    private(set) var today = Date.now

    var day: Int { Calendar.current.component(.day, from: today) }

    @ObservationIgnored private var observers: [Task<Void, Never>] = []

    init() {
        let sources: [(NotificationCenter, Notification.Name)] = [
            (.default, .NSCalendarDayChanged),
            (.default, .NSSystemTimeZoneDidChange),
            (NSWorkspace.shared.notificationCenter, NSWorkspace.didWakeNotification),
        ]
        observers = sources.map { center, name in
            Task { [weak self] in
                for await _ in center.notifications(named: name) {
                    self?.refresh()
                }
            }
        }
    }

    func refresh() {
        let now = Date.now
        if !Calendar.current.isDate(now, inSameDayAs: today) {
            today = now
        }
    }
}
