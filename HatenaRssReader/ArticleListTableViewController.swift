//
//  ArticleListTableViewController.swift
//  HatenaRssReader
//
//  Created by TOUYA KAWANO on 2019/12/01.
//  Copyright © 2019 Toya Kawano. All rights reserved.
//

import UIKit

class ArticleListTableViewController: UITableViewController {
    
    var articleList: ArticleList? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        RssClient.fetchArticleList(urlString: "https://api.rss2json.com/v1/api.json?rss_url=http%3A%2F%2Fb.hatena.ne.jp%2Fhotentry.rss&api_key=hybg4dcph35nb1dukcxlctpevjn8hb2fvibpuhzd", completion: { response in
            switch response {
            case .success(let articleList):
                DispatchQueue.main.async() { [weak self] in
                    guard let me = self else { return }
                    me.articleList = articleList
                }
            case .failure(let err):
                print("記事の取得に失敗しました: reason(\(err))")
            }
        })
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = articleList?.items[indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articleList?.items.count ?? 0
    }

}
