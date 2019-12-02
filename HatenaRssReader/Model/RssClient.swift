//
//  RssClient.swift
//  HatenaRssReader
//
//  Created by TOUYA KAWANO on 2019/12/01.
//  Copyright © 2019 Toya Kawano. All rights reserved.
//

import Foundation

class RssClient {
    
    /// 記事の一覧を取得します。
    /// - Parameter urlString: 取得元RSSのurl
    /// - Parameter completion: 完了時の処理
    static func fetchArticleList(urlString: String, completion: @escaping (Result<ArticleList, Error>) -> ()) {

        let rssToJsonFormat = "https://api.rss2json.com/v1/api.json?rss_url="
        let apiKey = "&api_key=hybg4dcph35nb1dukcxlctpevjn8hb2fvibpuhzd"
        let count = "&count=25"
        let rssToJsonUrl = rssToJsonFormat + urlString + apiKey + count
        
         // URL型に変換できない文字列の場合は弾く
        guard let url = URL(string: rssToJsonUrl) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.unknown))
                return
            }

            let decoder = JSONDecoder()
            guard let articleList = try?decoder.decode(ArticleList.self, from: data) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            completion(.success(articleList))
        })
        task.resume()
    }
}

/// ネットワークエラー
enum NetworkError: Error {
    // 不正なURLが指定されました。
    case invalidURL
    // 不正なレスポンスが返されました。
    case invalidResponse
    // 想定外のエラーです。
    case unknown
}
/// アプリケーションエラー
enum AppalicationError: Error {
    // 何かのパースに失敗しました。
    case parseFailed
    // 想定外のエラーです。
    case unknown
}
