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
    static let APIKey = "applicationId=1094381194134200287"
}


enum APIError: Error {
    case failedTogetData
}

class APICaller {
    static let shared = APICaller()
    private let requestInterval: TimeInterval = 0.5
    private let apiQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    func getSnare(with maker: String, completion: @escaping (Result<[ItemElement], Error>) -> Void) {
        let operation = SnareRequestOperation(maker: maker, completion: completion)
        apiQueue.addOperation(operation)
        apiQueue.addOperation(BlockOperation(block: { [weak self] in
            guard let self = self else { return }
            Thread.sleep(forTimeInterval: self.requestInterval)
        }))
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

    // chatGPTAPIを呼び、得られた回答のみ返す関数
    func generatedAnswer(from chatMessages: [ChatMessage]) async throws -> String {
        let openAI = OpenAISwift(authToken: "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")
        let result = try await openAI.sendChat(with: chatMessages)
        return result.choices?.first?.message.content ?? ""
    }
}

class SnareRequestOperation: Operation {
    let maker: String
    let completion: (Result<[ItemElement], Error>) -> Void

    init(maker: String, completion: @escaping (Result<[ItemElement], Error>) -> Void) {
        self.maker = maker
        self.completion = completion
    }

    override func main() {
        guard !isCancelled else { return }
        guard let url = URL(string: "\(Constants.baseURL)&\(Constants.keyWord)\(maker)&\(Constants.shopCode)&\(Constants.APIKey)") else { return }

        let semaphore = DispatchSemaphore(value: 0)

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            if let data = data, error == nil {
                do {
                    let results = try JSONDecoder().decode(ResultItems.self, from: data).Items
                    self.completion(.success(results))
                } catch {
                    self.completion(.failure(APIError.failedTogetData))
                }
            } else {
                self.completion(.failure(APIError.failedTogetData))
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
}
