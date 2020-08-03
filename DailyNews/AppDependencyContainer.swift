//
//  AppDependencyContainer.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/19/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation

class AppDependencyContainer {
    
    // Long-lived dependencies
    let sharedService = Service()
    
    init() {
        
    }
    
    func makeContentView() -> ContentView {
        let headlinesContainer = TopHeadlinesDependencyContainer(appDependencyContainer: self)
        let newsSearchContainer = NewsSearchDependencyContainer(appDependencyContainer: self)
        let favouritesContainer = FavouritesDependencyContainer(appDependencyContainer: self)
        
        return ContentView(topHeadlinesView: headlinesContainer.makeTopHeadlinesView(),
                           newsSearchView: newsSearchContainer.makeNewsSearchView(),
                           favouritesView: favouritesContainer.makeFavouritesView())
    }
    
    func makeNewsSearchViewRow(article: Article) -> ArticleRow {
        let container = TopHeadlinesDependencyContainer(appDependencyContainer: self)
        return container.makeTopHeadlinesRow(article: article)
    }
    
    func makeArticleRow() -> TopHeadlinesView.MakeArticleRow {
         let container = TopHeadlinesDependencyContainer(appDependencyContainer: self)
        let makeArticleRowFactory = { article in
            return container.makeTopHeadlinesRow(article: article)
        }
        return makeArticleRowFactory
    }
}
