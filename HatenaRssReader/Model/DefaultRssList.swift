//
//  DefaultRssList.swift
//  HatenaRssReader
//
//  Created by TOUYA KAWANO on 2019/12/03.
//  Copyright © 2019 Toya Kawano. All rights reserved.
//

import Foundation

enum DefaultRssList: CaseIterable {
    case top
    case social
    case economics
    case life
    case knowledge
    case technology
    case entertainment
    case game
    case fun
    
    var url: String {
        switch self {
        case .top: return "http://b.hatena.ne.jp/hotentry.rss"
        case .social: return "http://b.hatena.ne.jp/hotentry/social.rss"
        case .economics: return "http://b.hatena.ne.jp/hotentry/economics.rss"
        case .life: return "http://b.hatena.ne.jp/hotentry/life.rss"
        case .knowledge: return "http://b.hatena.ne.jp/hotentry/knowledge.rss"
        case .technology: return "http://b.hatena.ne.jp/hotentry/it.rss"
        case .entertainment: return "http://b.hatena.ne.jp/hotentry/entertainment.rss"
        case .game: return "http://b.hatena.ne.jp/hotentry/game.rss"
        case .fun: return "http://b.hatena.ne.jp/hotentry/fun.rss"
        }
    }
    
    var tabTitle: String {
        switch self {
        case .top: return "総合"
        case .social: return "世の中"
        case .economics: return "政治と経済"
        case .life: return "暮らし"
        case .knowledge: return "学び"
        case .technology: return "テクノロジー"
        case .entertainment: return "エンタメ"
        case .game: return "アニメとゲーム"
        case .fun: return "おもしろ"
        }
    }
    
}
