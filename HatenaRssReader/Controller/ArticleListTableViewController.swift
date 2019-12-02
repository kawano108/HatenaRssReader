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
import XLPagerTabStrip

class ArticleListTableViewController: UITableViewController, IndicatorInfoProvider {
    
    var items: [Item] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var rssUrl: String = ""
    var itemInfo = IndicatorInfo(title: "")

    init(rssUrl: String, style: UITableView.Style, itemInfo: IndicatorInfo) {
        self.rssUrl = rssUrl
        self.itemInfo = itemInfo
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ArticleCell",bundle: nil), forCellReuseIdentifier: "ArticleCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        RssClient.fetchArticleList(urlString: rssUrl, completion: { response in
            switch response {
            case .success(let articleList):
                DispatchQueue.main.async() { [weak self] in
                    guard let me = self else { return }
                    articleList.items.forEach { me.items.append($0) }
                }
            case .failure(let err):
                print("記事の取得に失敗しました: reason(\(err))")
            }
        })
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let articleCell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        articleCell.titleLabel.text = items[indexPath.row].title
        articleCell.pubDateLabel.text = items[indexPath.row].pubDate
        
        let thumbnailImage = (items[indexPath.row].thumbnail)
        let thumbnailImageURL = URL(string: thumbnailImage)
        SDWebImageManager.shared.loadImage(with: thumbnailImageURL,
                                           options: .avoidAutoSetImage,
                                           progress: nil,
                                           completed: { image, data, error, cache, finished, url  in
                                            articleCell.thumbnailImageView.image = image
        })
        
        let htmlStr = items[indexPath.row].content
        let html = HTMLDocument(string: htmlStr)
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
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // TODO: RSSから次の10件取得する方法がわからないので未実装
    }
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}
