//
//  OpenAIClient.swift
//  spotlightchat
//

import Foundation

actor OpenAIClient {
    static let shared = OpenAIClient()
    private init() {}

    enum OpenAIError: Error {
        case noAPIKey
        case invalidResponse(code: Int)
        case decodeError
    }

    struct APIResponse: Decodable {
        struct OutputItem: Decodable {
            struct Content: Decodable {
                let text: String?
            }
            let content: [Content]
        }
        let output: [OutputItem]
    }

    func ask(_ prompt: String) async throws -> String {
        // Разворачиваем Optional безопасно
        guard let key = try KeychainHelper.shared.get(key: KeychainHelper.openAIKey) else {
            throw OpenAIError.noAPIKey
        }

        let url = URL(string: "https://api.openai.com/v1/responses")!
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "input": prompt,
            "max_output_tokens": 300
        ]
        req.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await URLSession.shared.data(for: req)
        guard let http = response as? HTTPURLResponse else { throw OpenAIError.decodeError }
        guard (200...299).contains(http.statusCode) else { throw OpenAIError.invalidResponse(code: http.statusCode) }

        let decoder = JSONDecoder()
        if let apiResp = try? decoder.decode(APIResponse.self, from: data),
           let first = apiResp.output.first,
           let content = first.content.first,
           let txt = content.text {
            return txt
        }

        return String(data: data, encoding: .utf8) ?? ""
    }
}
