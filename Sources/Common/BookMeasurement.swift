import Foundation

enum BookMeasurement {
    static let centimetersPer100Pages: Double = 0.6

    static func centimeters(forPages pages: Int) -> Double {
        Double(pages) / 100.0 * centimetersPer100Pages
    }

    static func formatted(centimeters cm: Double) -> String {
        if cm >= 100 {
            let meters = cm / 100
            return String(format: "%.2f m", meters)
        } else {
            return String(format: "%.1f cm", cm)
        }
    }
}
