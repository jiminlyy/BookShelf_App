import SwiftUI
import SwiftData

struct CalendarView: View {
    @Query(sort: \Book.finishedDate, order: .reverse) private var books: [Book]
    @State private var displayedMonth = Date()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                MonthHeader(month: $displayedMonth)
                WeekdayHeader()
                MonthGrid(month: displayedMonth, books: books)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .navigationTitle("캘린더")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct MonthHeader: View {
    @Binding var month: Date
    private let calendar = Calendar.current

    private var yearText: String {
        String(calendar.component(.year, from: month))
    }

    private var monthText: String {
        "\(calendar.component(.month, from: month))월"
    }

    private var previousMonthText: String {
        guard let prev = calendar.date(byAdding: .month, value: -1, to: month) else { return "" }
        return "\(calendar.component(.month, from: prev))월"
    }

    private var nextMonthText: String {
        guard let next = calendar.date(byAdding: .month, value: 1, to: month) else { return "" }
        return "\(calendar.component(.month, from: next))월"
    }

    var body: some View {
        VStack(spacing: 4) {
            Text(yearText)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack {
                Button {
                    if let prev = calendar.date(byAdding: .month, value: -1, to: month) {
                        month = prev
                    }
                } label: {
                    HStack(spacing: 2) {
                        Image(systemName: "chevron.left")
                        Text(previousMonthText)
                    }
                    .font(.subheadline)
                }

                Spacer()

                Text(monthText)
                    .font(.title2.weight(.bold))

                Spacer()

                Button {
                    if let next = calendar.date(byAdding: .month, value: 1, to: month) {
                        month = next
                    }
                } label: {
                    HStack(spacing: 2) {
                        Text(nextMonthText)
                        Image(systemName: "chevron.right")
                    }
                    .font(.subheadline)
                }
            }
        }
    }
}

private struct WeekdayHeader: View {
    private let symbols = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]

    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(symbols.enumerated()), id: \.offset) { index, symbol in
                Text(symbol)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(weekdayColor(for: index))
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private func weekdayColor(for index: Int) -> Color {
        switch index {
        case 0: .red
        case 6: .blue
        default: .secondary
        }
    }
}

private struct MonthGrid: View {
    let month: Date
    let books: [Book]

    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)

    private var days: [Date?] {
        guard
            let interval = calendar.dateInterval(of: .month, for: month),
            let monthRange = calendar.range(of: .day, in: .month, for: month)
        else {
            return []
        }
        let firstWeekday = calendar.component(.weekday, from: interval.start)
        let leadingEmpty = firstWeekday - 1
        var result: [Date?] = Array(repeating: nil, count: leadingEmpty)
        for day in monthRange {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: interval.start) {
                result.append(date)
            }
        }
        return result
    }

    private func books(on date: Date) -> [Book] {
        books.filter { calendar.isDate($0.finishedDate, inSameDayAs: date) }
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(Array(days.enumerated()), id: \.offset) { _, date in
                if let date {
                    DayCell(date: date, books: books(on: date))
                } else {
                    Color.clear.frame(height: 64)
                }
            }
        }
    }
}

private struct DayCell: View {
    let date: Date
    let books: [Book]

    private let calendar = Calendar.current

    private var dayNumber: Int {
        calendar.component(.day, from: date)
    }

    private var weekday: Int {
        calendar.component(.weekday, from: date)
    }

    private var numberColor: Color {
        switch weekday {
        case 1: .red
        case 7: .blue
        default: .primary
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("\(dayNumber)")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(numberColor)

            VStack(spacing: 2) {
                ForEach(books.prefix(3)) { book in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color(hex: book.colorHex))
                        .frame(height: 6)
                }
                if books.count > 3 {
                    Text("+\(books.count - 3)")
                        .font(.system(size: 8))
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(4)
        .frame(height: 64)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}
