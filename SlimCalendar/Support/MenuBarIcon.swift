import AppKit

enum MenuBarIcon {
    /// A small calendar glyph with today's day number, drawn as a template
    /// image so macOS tints it for light and dark menu bars.
    static func image(day: Int) -> NSImage {
        let image = NSImage(size: NSSize(width: 18, height: 16), flipped: false) { _ in
            let frame = NSRect(x: 1, y: 0.75, width: 16, height: 14.5)
            let outline = NSBezierPath(roundedRect: frame, xRadius: 3, yRadius: 3)

            // Top band.
            NSGraphicsContext.saveGraphicsState()
            outline.addClip()
            NSColor.black.setFill()
            NSRect(x: frame.minX, y: frame.maxY - 4, width: frame.width, height: 4).fill()
            NSGraphicsContext.restoreGraphicsState()

            outline.lineWidth = 1.2
            NSColor.black.setStroke()
            outline.stroke()

            // Day number.
            let text = NSAttributedString(string: "\(day)", attributes: [
                .font: NSFont.monospacedDigitSystemFont(ofSize: 9, weight: .bold),
                .foregroundColor: NSColor.black,
            ])
            let size = text.size()
            let body = NSRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height - 4)
            text.draw(at: NSPoint(x: body.midX - size.width / 2, y: body.midY - size.height / 2 + 0.5))
            return true
        }
        image.isTemplate = true
        image.accessibilityDescription = "Calendar"
        return image
    }
}
