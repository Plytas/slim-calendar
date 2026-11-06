import Foundation

/// The days shown for one month: always 6 full weeks, so the popup keeps
/// the same height from month to month.
struct MonthGrid {
    struct Day: Identifiable {
        let date: Date
        let number: Int
        let isInMonth: Bool
        let isWeekend: Bool
        var id: Date { date }
    }

    struct Week: Identifiable {
        let number: Int
        let days: [Day]
        var id: Date { days[0].date }
    }

    struct Weekday: Identifiable {
        let symbol: String
        let isWeekend: Bool
        var id: String { symbol }
    }

    let month: Date
    let weeks: [Week]
    let weekdays: [Weekday]

    /// - Parameters:
    ///   - date: Any date in the base month.
    ///   - offset: Months to move from the base month (negative = earlier).
    init(containing date: Date, offset: Int = 0, calendar: Calendar = .iso8601Current) {
        let base = calendar.dateInterval(of: .month, for: date)!.start
        let month = calendar.date(byAdding: .month, value: offset, to: base)!
        let monthNumber = calendar.component(.month, from: month)

        let lead = (calendar.component(.weekday, from: month) - calendar.firstWeekday + 7) % 7
        let gridStart = calendar.date(byAdding: .day, value: -lead, to: month)!

        let weeks = (0..<6).map { week in
            let days = (0..<7).map { index in
                let date = calendar.date(byAdding: .day, value: week * 7 + index, to: gridStart)!
                return Day(
                    date: date,
                    number: calendar.component(.day, from: date),
                    isInMonth: calendar.component(.month, from: date) == monthNumber,
                    isWeekend: calendar.isDateInWeekend(date)
                )
            }
            return Week(number: calendar.component(.weekOfYear, from: days[0].date), days: days)
        }

        let symbols = calendar.shortStandaloneWeekdaySymbols
        let shift = calendar.firstWeekday - 1
        let ordered = Array(symbols[shift...] + symbols[..<shift])

        self.month = month
        self.weeks = weeks
        self.weekdays = zip(ordered, weeks[0].days).map { symbol, day in
            Weekday(symbol: symbol, isWeekend: day.isWeekend)
        }
    }
}

extension Calendar {
    /// ISO 8601 rules (weeks start on Monday, week 1 contains the first
    /// Thursday) with the user's language for month and day names.
    static var iso8601Current: Calendar {
        var calendar = Calendar(identifier: .iso8601)
        calendar.locale = .current
        calendar.timeZone = .current
        return calendar
    }
}
