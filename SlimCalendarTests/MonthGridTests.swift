import Foundation
import Testing
@testable import Slim_Calendar

struct MonthGridTests {
    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.locale = Locale(identifier: "en_GB")
        calendar.timeZone = TimeZone(identifier: "Europe/Vilnius")!
        return calendar
    }()

    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        calendar.date(from: DateComponents(year: year, month: month, day: day))!
    }

    @Test func gridStartsOnMondayAndHasSixWeeks() {
        let grid = MonthGrid(containing: date(2026, 11, 6), calendar: calendar)

        #expect(grid.weeks.count == 6)
        #expect(grid.weeks.allSatisfy { $0.days.count == 7 })
        #expect(grid.weekdays.map(\.symbol) == ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"])
        #expect(grid.weeks[0].days[0].date == date(2026, 10, 26))
    }

    @Test func marksDaysOutsideTheMonth() {
        let grid = MonthGrid(containing: date(2026, 11, 6), calendar: calendar)
        let first = grid.weeks[0].days

        #expect(first.prefix(6).allSatisfy { !$0.isInMonth })
        #expect(first[6].isInMonth && first[6].number == 1)
    }

    @Test func marksSaturdayAndSundayAsWeekend() {
        let grid = MonthGrid(containing: date(2026, 11, 6), calendar: calendar)

        #expect(grid.weekdays.map(\.isWeekend) == [false, false, false, false, false, true, true])
        #expect(grid.weeks.allSatisfy { $0.days.map(\.isWeekend) == grid.weekdays.map(\.isWeekend) })
    }

    @Test func usesISOWeekNumbers() {
        let november = MonthGrid(containing: date(2026, 11, 6), calendar: calendar)
        #expect(november.weeks.map(\.number) == [44, 45, 46, 47, 48, 49])

        // 2026 has 53 ISO weeks; 1 January 2027 is in week 53.
        let january = MonthGrid(containing: date(2027, 1, 15), calendar: calendar)
        #expect(january.weeks[0].number == 53)
        #expect(january.weeks[1].number == 1)
    }

    @Test(arguments: [-1, 1, 12, -12])
    func offsetMovesByMonths(offset: Int) {
        let grid = MonthGrid(containing: date(2026, 11, 6), offset: offset, calendar: calendar)
        let expected = calendar.date(byAdding: .month, value: offset, to: date(2026, 11, 1))!
        #expect(grid.month == expected)
    }

    @Test func monthStartingOnMondayHasNoLeadingDays() {
        // 1 June 2026 is a Monday.
        let grid = MonthGrid(containing: date(2026, 6, 10), calendar: calendar)
        #expect(grid.weeks[0].days[0].date == date(2026, 6, 1))
    }
}
