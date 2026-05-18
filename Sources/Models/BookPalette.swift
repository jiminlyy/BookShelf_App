import Foundation

enum BookPalette {
    static let colors: [String] = [
        "#E63946",
        "#F77F00",
        "#FCBF49",
        "#06A77D",
        "#1D7874",
        "#3D5A80",
        "#6A4C93",
        "#B5179E",
        "#9E2A2B",
        "#264653",
        "#7209B7",
        "#43AA8B",
        "#2A9D8F",
        "#E76F51",
        "#8E7DBE"
    ]

    static func random() -> String {
        colors.randomElement() ?? "#3D5A80"
    }
}
