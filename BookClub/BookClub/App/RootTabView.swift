import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            BookshelfView()
                .tabItem {
                    Label("책장", systemImage: "books.vertical.fill")
                }

            CalendarView()
                .tabItem {
                    Label("캘린더", systemImage: "calendar")
                }

            StatsView()
                .tabItem {
                    Label("통계", systemImage: "chart.bar.fill")
                }
        }
    }
}
