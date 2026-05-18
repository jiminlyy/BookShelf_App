import SwiftUI

struct BookSpineView: View {
    let book: Book

    private var height: CGFloat {
        PageThickness.height(for: book.pageCount)
    }

    private var coverColor: Color {
        Color(hex: book.colorHex)
    }

    private var pagesColor: Color {
        Color(red: 0.96, green: 0.93, blue: 0.85)
    }

    private var coverBandHeight: CGFloat {
        max(3, height * 0.14)
    }

    private var widthFactor: CGFloat {
        0.78 + CGFloat(book.id.uuid.0) / 255 * 0.22
    }

    private var horizontalOffset: CGFloat {
        (CGFloat(book.id.uuid.1) / 255 - 0.5) * 26
    }

    private var titleFont: Font {
        if height >= 80 {
            .headline
        } else if height >= 50 {
            .subheadline
        } else {
            .footnote
        }
    }

    var body: some View {
        GeometryReader { geo in
            let bookWidth = geo.size.width * widthFactor

            VStack(spacing: 0) {
                coverColor
                    .frame(height: coverBandHeight)

                ZStack {
                    pagesColor

                    Text(book.title)
                        .font(titleFont)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.black.opacity(0.78))
                        .lineLimit(2)
                        .minimumScaleFactor(0.55)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 14)
                }

                coverColor
                    .frame(height: coverBandHeight)
            }
            .frame(width: bookWidth, height: height)
            .clipShape(RoundedRectangle(cornerRadius: 3))
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
            )
            .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
            .offset(x: horizontalOffset)
            .frame(width: geo.size.width, alignment: .center)
        }
        .frame(height: height)
    }
}
