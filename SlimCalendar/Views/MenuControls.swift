import SwiftUI

/// A row that looks and behaves like a native menu item.
struct MenuRow: View {
    let title: LocalizedStringKey
    let checked: Bool?
    let action: () -> Void
    @State private var isHovering = false

    init(_ title: LocalizedStringKey, checked: Bool? = nil, action: @escaping () -> Void) {
        self.title = title
        self.checked = checked
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: "checkmark")
                    .font(.system(size: 11, weight: .semibold))
                    .opacity(checked == true ? 1 : 0)
                    .frame(width: 14)
                Text(title).font(.system(size: 13))
                Spacer()
            }
            .padding(.horizontal, 4)
            .frame(height: 22)
            .foregroundStyle(isHovering ? AnyShapeStyle(.white) : AnyShapeStyle(.primary))
            .background(.tint.opacity(isHovering ? 1 : 0), in: .rect(cornerRadius: 4))
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
        .accessibilityAddTraits(checked == true ? .isSelected : [])
    }
}

struct NavButton: View {
    let systemImage: String
    let label: LocalizedStringKey
    let action: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 12, weight: .semibold))
                .frame(width: 24, height: 22)
                .background(.primary.opacity(isHovering ? 0.1 : 0), in: .rect(cornerRadius: 5))
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.secondary)
        .onHover { isHovering = $0 }
        .accessibilityLabel(label)
    }
}
