//
//  IntentHandler.swift
//  spotlightchatIntent
//
//  Created by Andrey Gerasimov on 03.10.2025.
//

@preconcurrency import Intents
import Foundation

final class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        return ChatQueryHandler()
    }
}

final class ChatQueryHandler: NSObject, INSendMessageIntentHandling {

    func handle(intent: INSendMessageIntent, completion: @escaping (INSendMessageIntentResponse) -> Void) {
        guard let query = intent.content else {
            let response = INSendMessageIntentResponse(code: .failure, userActivity: nil)
            completion(response)
            return
        }

        Task {
            do {
                let answer = try await OpenAIClient.shared.ask(query)

                // Формируем NSUserActivity с ответом
                let activity = NSUserActivity(activityType: "com.gerasimovstudio.spotlightchat.reply")
                activity.title = answer                  // короткий текст для UI
                activity.userInfo = ["answer": answer]   // можно использовать в приложении
                // по желанию:
                // activity.isEligibleForPrediction = false
                activity.isEligibleForSearch = false

                // Возвращаем response с userActivity — это корректный и простой способ
                let response = INSendMessageIntentResponse(code: .success, userActivity: activity)

                // completion нужно вызывать на главном потоке
                DispatchQueue.main.async {
                    completion(response)
                }
            } catch {
                let response = INSendMessageIntentResponse(code: .failure, userActivity: nil)
                DispatchQueue.main.async {
                    completion(response)
                }
            }
        }
    }
}
