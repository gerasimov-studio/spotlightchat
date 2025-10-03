import CoreSpotlight

class SpotlightChatExtension: NSObject, CSSearchableIndexDelegate {

    // ✅ Этот метод обязателен — сообщает об ошибках индексации
    func searchableIndex(_ searchableIndex: CSSearchableIndex, reindexAllSearchableItemsWithAcknowledgementHandler acknowledgementHandler: @escaping () -> Void) {
        // Здесь можно пересоздать индекс (например, заново проиндексировать все сообщения)
        print("Reindexing all searchable items...")
        acknowledgementHandler()
    }

    // ✅ Этот метод опционален, но часто нужен — пересоздание конкретных элементов
    func searchableIndex(_ searchableIndex: CSSearchableIndex, reindexSearchableItemsWithIdentifiers identifiers: [String], acknowledgementHandler: @escaping () -> Void) {
        // Можно переиндексировать конкретные элементы по идентификаторам
        print("Reindexing specific items: \(identifiers)")
        acknowledgementHandler()
    }
}
