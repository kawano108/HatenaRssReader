//
//  ArticleListTableViewController.swift
//  HatenaRssReader
//
//  Created by TOUYA KAWANO on 2019/12/01.
//  Copyright © 2019 Toya Kawano. All rights reserved.
//

import UIKit
import SDWebImage
import HTMLReader

class ArticleListTableViewController: UITableViewController {
    
    var articleList: ArticleList? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ArticleCell",bundle: nil), forCellReuseIdentifier: "ArticleCell")

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
        let articleCell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        articleCell.titleLabel.text = articleList?.items[indexPath.row].title
        articleCell.pubDateLabel.text = articleList?.items[indexPath.row].pubDate
        
        let thumbnailImage = (articleList?.items[indexPath.row].thumbnail)!
        let thumbnailImageURL = URL(string: thumbnailImage)
        SDWebImageManager.shared.loadImage(with: thumbnailImageURL,
                                           options: .avoidAutoSetImage,
                                           progress: nil,
                                           completed: { image, data, error, cache, finished, url  in
                                            articleCell.thumbnailImageView.image = image
        })
        
        let htmlStr = articleList?.items[indexPath.row].content
        let html = HTMLDocument(string: htmlStr ?? "")
        let htmlElement = html.nodes(matchingSelector: "img")
        if let mainImageUrlStr = htmlElement[1].attributes["src"] {
            let mainImageUrl = URL(string: mainImageUrlStr)
            SDWebImageManager.shared.loadImage(with: mainImageUrl,
                                               options: .avoidAutoSetImage,
                                               progress: nil,
                                               completed: { image, data, error, cache, finished, url  in
                                                articleCell.mainImageView.image = image
            })
        }
        return articleCell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articleList?.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
