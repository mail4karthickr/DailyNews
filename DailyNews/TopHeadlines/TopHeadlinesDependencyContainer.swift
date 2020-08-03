//
//  TopHeadlinesDependencyContainer.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/19/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import SwiftUI

class TopHeadlinesDependencyContainer {
    private var appDependencyContainer: AppDependencyContainer
    
    init(appDependencyContainer: AppDependencyContainer) {
        self.appDependencyContainer = appDependencyContainer
    }
    
    func makeTopHeadlinesView() -> TopHeadlinesView {
        let makeTopHeadlinesRowFactory = { article in
            self.makeTopHeadlinesRow(article: article)
        }
        let makeNewsFilterViewFactory = { applyNewsFilter  in
            self.makeNewsFilterView(applyNewsFilter: applyNewsFilter)
        }
        return TopHeadlinesView(viewModel: makeTopHeadlinesViewModel(),
                                makeTopHeadlinesRow: makeTopHeadlinesRowFactory,
                                makeNewsFilterView: makeNewsFilterViewFactory)
    }
    
    func makeTopHeadlinesViewModel() -> TopHeadlinesViewModel {
        return TopHeadlinesViewModel(service: appDependencyContainer.sharedService)
    }
    
    func makeTopHeadlinesRow(article: Article) -> ArticleRow {
        return ArticleRow(article: article, viewModel: makeTopHeadlinesRowViewModel())
    }
    
    func makeTopHeadlinesRowViewModel() -> ArticleRowViewModel {
        return ArticleRowViewModel(fileManager: makeFileManager())
    }
    
    func makeFileManager() -> ImageFileManagerType {
        return ImageFileManager()
    }
    
    func makeNewsFilterView(applyNewsFilter: @escaping TopHeadlinesView.ApplyNewsFilter) -> NewsFilterView {
        let makeNewsFilterRowFactory = { category in
            CategoryFilterRowView(viewModel: self.makeNewsFilterRowViewModel(), category: category)
        }
        let makeCountryNameRowFactory = { country in
            CountryFilterRowView(viewModel: self.makeCountryNameRowViewModel(), country: country)
        }
        return NewsFilterView(viewModel: makeNewsFilterViewModel(),
                              makeNewsFilterRow: makeNewsFilterRowFactory,
                              makeCountryNameRow: makeCountryNameRowFactory,
                              applyNewsFilter: applyNewsFilter)
    }
    
    func makeNewsFilterViewModel() -> NewsFilterViewModel {
        return NewsFilterViewModel()
    }
    
    func makeNewsFilterRowViewModel() -> CategoryFilterRowViewModel {
        return CategoryFilterRowViewModel()
    }
    
    func makeCountryNameRowViewModel() -> CountryFilterRowViewModel {
        return CountryFilterRowViewModel()
    }
}
