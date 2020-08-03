//
//  NewsSearchDependencyContainer.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/19/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation

class NewsSearchDependencyContainer {
    private var appDependencyContainer: AppDependencyContainer
    
    init(appDependencyContainer: AppDependencyContainer) {
        self.appDependencyContainer = appDependencyContainer
    }
    
    func makeNewsSearchView() -> NewsSearchView {
        return NewsSearchView(viewModel: makeNewsSearchViewModel(),
                              makeNewsSearchView: makeNewsSearchViewRowFactory())
    }
    
    func makeNewsSearchViewRowFactory() -> TopHeadlinesView.MakeArticleRow   {
        return { article in
            self.appDependencyContainer.makeNewsSearchViewRow(article: article)
        }
    }
    
    func makeTopHeadlinesViewModel() -> TopHeadlinesViewModel {
        return TopHeadlinesViewModel(service: appDependencyContainer.sharedService)
    }
    
    func makeNewsSearchViewModel() -> NewsSearchViewModel {
        return NewsSearchViewModel(service: appDependencyContainer.sharedService)
    }
}
