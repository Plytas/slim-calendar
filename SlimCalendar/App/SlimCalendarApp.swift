import SwiftUI

@main
struct SlimCalendarApp: App {
    @State private var clock = Clock()

    var body: some Scene {
        MenuBarExtra {
            CalendarView()
                .environment(clock)
        } label: {
            Image(nsImage: MenuBarIcon.image(day: clock.day))
        }
        .menuBarExtraStyle(.window)
    }
}
