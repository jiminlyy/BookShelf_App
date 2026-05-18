import SwiftUI
import SwiftData

@main
struct BookClubApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
        .modelContainer(for: Book.self)
    }
}
