//
//  FavouritesDependencyContainer.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/19/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation

class FavouritesDependencyContainer {
    private var appDependencyContainer: AppDependencyContainer
    
    init(appDependencyContainer: AppDependencyContainer) {
        self.appDependencyContainer = appDependencyContainer
    }
    
    func makeFavouritesView() -> FavouritesView {
        return FavouritesView(viewModel: makeFavoritesViewModel(), makeArticleRow: appDependencyContainer.makeArticleRow())
    }
    
    func makeFavoritesViewModel() -> FavoritesViewModel {
        return FavoritesViewModel()
    }
}
