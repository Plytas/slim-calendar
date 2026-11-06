import SwiftUI

struct CalendarView: View {
    @Environment(Clock.self) private var clock
    @AppStorage("showWeekNumbers") private var showWeekNumbers = true
    @State private var monthOffset = 0
    @State private var launchAtLogin = LaunchAtLogin.isEnabled

    private let cellWidth: CGFloat = 32
    private let cellHeight: CGFloat = 28

    private var grid: MonthGrid {
        MonthGrid(containing: clock.today, offset: monthOffset)
    }

    var body: some View {
        let grid = grid

        VStack(alignment: .leading, spacing: 6) {
            Text(clock.today, format: .dateTime.weekday(.wide).day().month(.wide).year())
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)

            Divider()

            header(for: grid)
            days(for: grid)

            Divider()

            VStack(spacing: 0) {
                MenuRow("Show Week Numbers", checked: showWeekNumbers) {
                    showWeekNumbers.toggle()
                }
                MenuRow("Launch at Login", checked: launchAtLogin) {
                    LaunchAtLogin.toggle()
                    launchAtLogin = LaunchAtLogin.isEnabled
                }
                Divider().padding(.vertical, 4)
                MenuRow("Quit") {
                    NSApplication.shared.terminate(nil)
                }
            }
        }
        .padding(10)
        .fixedSize()
        .focusable()
        .focusEffectDisabled()
        .onKeyPress(.leftArrow) { move(by: -1) }
        .onKeyPress(.rightArrow) { move(by: 1) }
        .onKeyPress(.upArrow) { move(by: -12) }
        .onKeyPress(.downArrow) { move(by: 12) }
        .onKeyPress(.space) { monthOffset = 0; return .handled }
        .task {
            // The popup window becomes key each time it opens: jump back to
            // the current month.
            for await _ in NotificationCenter.default.notifications(named: NSWindow.didBecomeKeyNotification) {
                clock.refresh()
                monthOffset = 0
                launchAtLogin = LaunchAtLogin.isEnabled
            }
        }
    }

    private func move(by months: Int) -> KeyPress.Result {
        monthOffset += months
        return .handled
    }

    private func header(for grid: MonthGrid) -> some View {
        HStack {
            NavButton(systemImage: "chevron.left", label: "Previous Month") { monthOffset -= 1 }
            Spacer()
            Button {
                monthOffset = 0
            } label: {
                Text(grid.month, format: .dateTime.month(.wide).year())
                    .font(.system(size: 16, weight: .semibold))
                    .contentShape(.rect)
            }
            .buttonStyle(.plain)
            .help("Go to today")
            Spacer()
            NavButton(systemImage: "chevron.right", label: "Next Month") { monthOffset += 1 }
        }
        .padding(.horizontal, 4)
    }

    private func days(for grid: MonthGrid) -> some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            GridRow {
                ForEach(grid.weekdays) { weekday in
                    Text(weekday.symbol)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(weekday.isWeekend ? AnyShapeStyle(Color.weekend) : AnyShapeStyle(.primary))
                        .frame(width: cellWidth, height: 20)
                }
                if showWeekNumbers {
                    Color.clear.frame(width: cellWidth, height: 20)
                }
            }

            ForEach(grid.weeks) { week in
                GridRow {
                    ForEach(week.days) { day in
                        DayCell(day: day, isToday: Calendar.current.isDate(day.date, inSameDayAs: clock.today))
                            .frame(width: cellWidth, height: cellHeight)
                    }
                    if showWeekNumbers {
                        Text(week.number, format: .number)
                            .font(.system(size: 11).monospacedDigit())
                            .foregroundStyle(.tertiary)
                            .frame(width: cellWidth, height: cellHeight)
                            .accessibilityLabel("Week \(week.number)")
                    }
                }
            }
        }
    }
}

#Preview {
    CalendarView()
        .environment(Clock())
}
