import SwiftUI
import SwiftData

struct BookDetailView: View {
    let book: Book

    @Environment(\.dismiss) private var dismiss
    @State private var showingEdit = false

    private var previewHeight: CGFloat {
        max(80, PageThickness.height(for: book.pageCount) * 1.4)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(hex: book.colorHex))
                    .frame(maxWidth: .infinity)
                    .frame(height: previewHeight)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .overlay(
                        Text(book.title)
                            .font(.title3.weight(.bold))
                            .foregroundStyle(.white)
                            .lineLimit(2)
                            .minimumScaleFactor(0.6)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    )

                VStack(alignment: .leading, spacing: 6) {
                    Text(book.title)
                        .font(.title2.weight(.bold))
                    Text("\(book.author) · \(book.publisher)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text("\(book.pageCount)p · \(book.finishedDate.formatted(date: .numeric, time: .omitted)) 완독")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Divider()

                VStack(alignment: .leading, spacing: 10) {
                    Label("나의 리뷰", systemImage: "note.text")
                        .font(.headline)

                    if book.memo.isEmpty {
                        Text("아직 작성된 리뷰가 없어요")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } else {
                        Text(book.memo)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding(20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("편집") { showingEdit = true }
            }
        }
        .sheet(isPresented: $showingEdit) {
            EditBookView(book: book) {
                dismiss()
            }
        }
    }
}
