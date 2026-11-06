import SwiftUI

struct DayCell: View {
    let day: MonthGrid.Day
    let isToday: Bool

    var body: some View {
        Text(day.number, format: .number)
            .font(.system(size: day.isInMonth ? 15 : 14).monospacedDigit())
            .italic(!day.isInMonth)
            .foregroundStyle(foreground)
            .frame(width: 26, height: 26)
            .background {
                if isToday {
                    Circle().fill(.tint)
                }
            }
            .accessibilityLabel(Text(day.date, format: .dateTime.weekday(.wide).day().month(.wide)))
            .accessibilityAddTraits(isToday ? .isSelected : [])
    }

    private var foreground: AnyShapeStyle {
        if isToday { return AnyShapeStyle(.white) }
        return switch (day.isWeekend, day.isInMonth) {
        case (true, true): AnyShapeStyle(Color.weekend)
        case (true, false): AnyShapeStyle(Color.weekend.opacity(0.4))
        case (false, true): AnyShapeStyle(.primary)
        case (false, false): AnyShapeStyle(.tertiary)
        }
    }
}

extension ShapeStyle where Self == Color {
    /// A muted red, with a separate shade for light and dark mode.
    static var weekend: Color {
        Color(nsColor: NSColor(name: "weekend") { appearance in
            appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
                ? NSColor(srgbRed: 0.93, green: 0.52, blue: 0.50, alpha: 1)
                : NSColor(srgbRed: 0.78, green: 0.33, blue: 0.31, alpha: 1)
        })
    }
}
