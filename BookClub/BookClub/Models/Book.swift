import Foundation
import SwiftData

@Model
final class Book {
    var id: UUID
    var title: String
    var author: String
    var publisher: String
    var pageCount: Int
    var finishedDate: Date
    var colorHex: String
    var memo: String
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        author: String,
        publisher: String,
        pageCount: Int,
        finishedDate: Date,
        colorHex: String,
        memo: String = "",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.publisher = publisher
        self.pageCount = pageCount
        self.finishedDate = finishedDate
        self.colorHex = colorHex
        self.memo = memo
        self.createdAt = createdAt
    }
}
