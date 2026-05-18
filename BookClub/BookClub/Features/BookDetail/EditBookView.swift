import SwiftUI
import SwiftData

struct EditBookView: View {
    let book: Book
    let onDeleted: () -> Void

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var title: String
    @State private var author: String
    @State private var publisher: String
    @State private var pageCountText: String
    @State private var finishedDate: Date
    @State private var memo: String
    @State private var showingDeleteConfirm = false

    init(book: Book, onDeleted: @escaping () -> Void) {
        self.book = book
        self.onDeleted = onDeleted
        _title = State(initialValue: book.title)
        _author = State(initialValue: book.author)
        _publisher = State(initialValue: book.publisher)
        _pageCountText = State(initialValue: String(book.pageCount))
        _finishedDate = State(initialValue: book.finishedDate)
        _memo = State(initialValue: book.memo)
    }

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

                Section("리뷰") {
                    TextEditor(text: $memo)
                        .frame(minHeight: 140)
                }

                Section {
                    Button(role: .destructive) {
                        showingDeleteConfirm = true
                    } label: {
                        HStack {
                            Spacer()
                            Label("삭제하기", systemImage: "trash")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("편집")
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
            .alert("정말 삭제할까요?", isPresented: $showingDeleteConfirm) {
                Button("취소", role: .cancel) {}
                Button("삭제", role: .destructive, action: delete)
            } message: {
                Text("이 책의 메모도 함께 삭제됩니다.")
            }
        }
    }

    private func save() {
        guard canSave, let pages = pageCount else { return }
        book.title = title.trimmingCharacters(in: .whitespaces)
        book.author = author.trimmingCharacters(in: .whitespaces)
        book.publisher = publisher.trimmingCharacters(in: .whitespaces)
        book.pageCount = pages
        book.finishedDate = finishedDate
        book.memo = memo
        dismiss()
    }

    private func delete() {
        context.delete(book)
        dismiss()
        onDeleted()
    }
}
