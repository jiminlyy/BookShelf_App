import SwiftUI
import SwiftData

struct BookDetailView: View {
    let book: Book

    @Environment(\.dismiss) private var dismiss
    @State private var showingEdit = false

    private var previewHeight: CGFloat {
        max(80, PageThickness.height(for: book.pageCount) * 1.4)
    }

    private var coverBandHeight: CGFloat {
        max(5, previewHeight * 0.14)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(spacing: 0) {
                    Color(hex: book.colorHex)
                        .frame(height: coverBandHeight)

                    ZStack {
                        Color(red: 0.96, green: 0.93, blue: 0.85)

                        Text(book.title)
                            .font(.title3.weight(.bold))
                            .foregroundStyle(Color.black.opacity(0.8))
                            .lineLimit(2)
                            .minimumScaleFactor(0.6)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                    }

                    Color(hex: book.colorHex)
                        .frame(height: coverBandHeight)
                }
                .frame(maxWidth: .infinity)
                .frame(height: previewHeight)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
                )
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)

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
