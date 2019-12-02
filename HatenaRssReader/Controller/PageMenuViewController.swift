//
//  PageMenuViewController.swift
//  HatenaRssReader
//
//  Created by TOUYA KAWANO on 2019/12/02.
//  Copyright © 2019 Toya Kawano. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PageMenuViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        setupTabMenu()
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .systemBlue
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.title = "ホーム"
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return createViewControllers()
    }
    
    private func setupTabMenu() {
        settings.style.buttonBarItemBackgroundColor = UIColor(red: 245/255,
                                                              green: 245/255,
                                                              blue: 245/255,
                                                              alpha: 1)
        settings.style.selectedBarBackgroundColor = .systemBlue
        settings.style.buttonBarItemTitleColor = .darkGray
        settings.style.buttonBarMinimumLineSpacing = 0
    }
    
    private func createViewControllers() -> [UIViewController] {
        var childViewControllers: [UIViewController] = []
        DefaultRssList.allCases.forEach {
            let itemInfo = IndicatorInfo(title: $0.tabTitle)
            let vc = ArticleListTableViewController(rssUrl: $0.url,
                                                    style: .plain,
                                                    itemInfo: itemInfo)
            childViewControllers.append(vc)
        }
        return childViewControllers
    }
}
