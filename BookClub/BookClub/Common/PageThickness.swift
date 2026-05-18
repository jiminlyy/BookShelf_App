import CoreGraphics

enum PageThickness {
        private static let baseHeight: CGFloat = 18
        private static let pointsPerPage: CGFloat = 0.08
        private static let minHeight: CGFloat = 22
        private static let maxHeight: CGFloat = 110

    static func height(for pageCount: Int) -> CGFloat {
        let computed = baseHeight + CGFloat(pageCount) * pointsPerPage
                return min(maxHeight, max(minHeight, computed))
    }
}
