import SwiftUI

struct EmptyBookshelfView: View {
    let onAdd: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "books.vertical")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)

            VStack(spacing: 6) {
                Text("아직 읽은 책이 없어요")
                    .font(.headline)
                Text("첫 책을 추가해보세요")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Button(action: onAdd) {
                Label("책 추가하기", systemImage: "plus")
                    .font(.subheadline.weight(.semibold))
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 6)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
