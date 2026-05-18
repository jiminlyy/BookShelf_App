import CoreGraphics

enum PageThickness {
    private static let baseHeight: CGFloat = 14
    private static let pointsPerPage: CGFloat = 0.18
    private static let minHeight: CGFloat = 20
    private static let maxHeight: CGFloat = 160

    static func height(for pageCount: Int) -> CGFloat {
        let computed = baseHeight + CGFloat(pageCount) * pointsPerPage
        return min(maxHeight, max(minHeight, computed))
    }
}
