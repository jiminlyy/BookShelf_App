import SwiftUI
import SwiftData

struct AddBookView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var title = ""
    @State private var author = ""
    @State private var publisher = ""
    @State private var pageCountText = ""
    @State private var finishedDate = Date()
    @State private var memo = ""

    private var pageCount: Int? {
        Int(pageCountText)
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
            && !author.trimmingCharacters(in: .whitespaces).isEmpty
            && (pageCount ?? 0) > 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("책 정보") {
                    TextField("제목", text: $title)
                    TextField("작가", text: $author)
                    TextField("출판사", text: $publisher)
                    TextField("페이지 수", text: $pageCountText)
                        .keyboardType(.numberPad)
                    DatePicker(
                        "완독 날짜",
                        selection: $finishedDate,
                        displayedComponents: .date
                    )
                }

                Section("리뷰 (선택)") {
                    TextEditor(text: $memo)
                        .frame(minHeight: 140)
                }
            }
            .navigationTitle("책 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("취소") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("저장", action: save)
                        .disabled(!canSave)
                }
            }
        }
    }

    private func save() {
        guard canSave, let pages = pageCount else { return }
        let book = Book(
            title: title.trimmingCharacters(in: .whitespaces),
            author: author.trimmingCharacters(in: .whitespaces),
            publisher: publisher.trimmingCharacters(in: .whitespaces),
            pageCount: pages,
            finishedDate: finishedDate,
            colorHex: BookPalette.random(),
            memo: memo
        )
        context.insert(book)
        dismiss()
    }
}
