//
//  APIKeyView.swift
//  spotlightchat
//
//  Created by Andrey Gerasimov on 03.10.2025.
//


import SwiftUI

struct APIKeyView: View {
    @State private var apiKey: String = ""
    @State private var message: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Введите ваш OpenAI API ключ")
                .font(.headline)
            
            SecureField("sk-...", text: $apiKey)
                .textFieldStyle(.roundedBorder)
                .padding()

            Button("Сохранить") {
                do {
                    try KeychainHelper.shared.save(apiKey, key: KeychainHelper.openAIKey)
                    message = "✅ Ключ сохранён!"
                    apiKey = ""
                } catch {
                    message = "❌ Ошибка при сохранении"
                }
            }
            .buttonStyle(.borderedProminent)

            if !message.isEmpty {
                Text(message)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(width: 400)
    }
}