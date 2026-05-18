import SwiftUI
import SwiftData
import Charts

struct StatsView: View {
    @Query private var books: [Book]
    @State private var selectedMetric: Metric = .count
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())

    enum Metric: String, CaseIterable, Identifiable {
        case count = "권수"
        case pages = "페이지"
        var id: String { rawValue }
    }

    private var availableYears: [Int] {
        let years = Set(books.map { Calendar.current.component(.year, from: $0.finishedDate) })
        let currentYear = Calendar.current.component(.year, from: Date())
        let combined = years.union([currentYear])
        return Array(combined).sorted(by: >)
    }

    private var booksInYear: [Book] {
        books.filter { Calendar.current.component(.year, from: $0.finishedDate) == selectedYear }
    }

    private var monthlyData: [MonthlyStat] {
        var byMonth: [Int: (count: Int, pages: Int)] = [:]
        for book in booksInYear {
            let month = Calendar.current.component(.month, from: book.finishedDate)
            let existing = byMonth[month] ?? (0, 0)
            byMonth[month] = (existing.count + 1, existing.pages + book.pageCount)
        }
        return (1...12).map { month in
            let stat = byMonth[month] ?? (0, 0)
            return MonthlyStat(month: month, count: stat.count, pages: stat.pages)
        }
    }

    private var totalCount: Int { booksInYear.count }
    private var totalPages: Int { booksInYear.reduce(0) { $0 + $1.pageCount } }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Picker("Metric", selection: $selectedMetric) {
                        ForEach(Metric.allCases) { metric in
                            Text(metric.rawValue).tag(metric)
                        }
                    }
                    .pickerStyle(.segmented)

                    HStack {
                        Text("월별 독서량")
                            .font(.headline)
                        Spacer()
                        Menu {
                            ForEach(availableYears, id: \.self) { year in
                                Button("\(year)년") {
                                    selectedYear = year
                                }
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text("\(String(selectedYear))년 (\(totalCount))")
                                Image(systemName: "chevron.down")
                                    .font(.caption2)
                            }
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(Capsule())
                        }
                    }

                    Text(selectedMetric == .count ? "권수별" : "페이지별")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Chart(monthlyData) { stat in
                        BarMark(
                            x: .value("월", stat.month),
                            y: .value(
                                selectedMetric.rawValue,
                                selectedMetric == .count
                                    ? Double(stat.count)
                                    : Double(stat.pages)
                            )
                        )
                        .foregroundStyle(.pink.gradient)
                        .cornerRadius(4)
                    }
                    .chartXAxis {
                        AxisMarks(values: [1, 3, 5, 7, 9, 11]) { value in
                            AxisValueLabel {
                                if let month = value.as(Int.self) {
                                    Text("\(month)월")
                                }
                            }
                            AxisGridLine()
                        }
                    }
                    .chartXScale(domain: 0.5...12.5)
                    .frame(height: 240)
                    .padding(.vertical, 4)
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                    Divider()

                    HStack(spacing: 6) {
                        Text("\(String(selectedYear))년 총 \(totalCount)권")
                        Text("·")
                        Text("\(totalPages.formatted())p")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(20)
            }
            .navigationTitle("통계")
        }
    }
}

struct MonthlyStat: Identifiable {
    let id = UUID()
    let month: Int
    let count: Int
    let pages: Int
}
