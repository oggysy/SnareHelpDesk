//
//  APICaller.swift
//  SnareHelpDesk
//
//  Created by 小木曽佑介 on 2023/05/04.
//

import Foundation
import OpenAISwift

struct Constants {
    static let baseURL = "https://app.rakuten.co.jp/services/api/IchibaItem/Search/20220601?format=json"
    static let keyWord = "keyword=%E3%82%B9%E3%83%8D%E3%82%A2%E3%83%89%E3%83%A9%E3%83%A0%E3%80%80"
    static let shopCode = "shopCode=ikebe"
    static let APIKey = "applicationId="
}


enum APIError: Error {
    case failedTogetData
}

class APICaller {
    static let shared = APICaller()

    func getSnare(with maker: String, completion: @escaping (Result<[ItemElement], Error>) -> Void){
        sleep(1)
        guard let url = URL(string: "\(Constants.baseURL)&\(Constants.keyWord)\(maker)&\(Constants.shopCode)&\(Constants.APIKey)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(ResultItems.self, from: data).Items
                completion(.success(results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }


    func getSearchSnare(with word: String, completion: @escaping (Result<[ItemElement], Error>) -> Void){
        guard let url = URL(string: "\(Constants.baseURL)&\(Constants.keyWord)\(word)&\(Constants.shopCode)&\(Constants.APIKey)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(ResultItems.self, from: data).Items
                completion(.success(results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
    }

    func generatedAnswer(from chatMessages: [ChatMessage]) async throws -> String {
        let openAI = OpenAISwift(authToken: "")
        let result = try await openAI.sendChat(with: chatMessages)
        return result.choices?.first?.message.content ?? ""
    }
}
