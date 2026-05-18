import SwiftUI
import SwiftData

struct BookshelfView: View {
    @Query(sort: \Book.finishedDate, order: .reverse) private var books: [Book]
    @State private var showingAddBook = false

    var body: some View {
        NavigationStack {
            Group {
                if books.isEmpty {
                    EmptyBookshelfView {
                        showingAddBook = true
                    }
                } else {
                    BookshelfContent(books: books)
                }
            }
            .navigationTitle("나의 지식양성소")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddBook = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddBook) {
                AddBookView()
            }
        }
    }
}

private struct BookshelfContent: View {
    let books: [Book]

    private var totalPages: Int {
        books.reduce(0) { $0 + $1.pageCount }
    }

    private var totalCentimeters: Double {
        BookMeasurement.centimeters(forPages: totalPages)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 6) {
                    Color.clear.frame(height: 8)
                    ForEach(books) { book in
                        NavigationLink {
                            BookDetailView(book: book)
                        } label: {
                            BookSpineView(book: book)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
            }

            Rectangle()
                .fill(Color(.tertiaryLabel))
                .frame(height: 2)
                .padding(.horizontal, 16)

            VStack(spacing: 4) {
                Text("지금까지 \(BookMeasurement.formatted(centimeters: totalCentimeters)) 읽었어요!")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)

                HStack(spacing: 6) {
                    Text("총 \(books.count)권")
                    Text("·")
                    Text("\(totalPages.formatted())p")
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
            .padding(.vertical, 10)
        }
    }
}
