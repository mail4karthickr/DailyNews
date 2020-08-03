//
//  FavouritesView.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/19/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import SwiftUI

struct FavouritesView: View {
    @ObservedObject var viewModel: FavoritesViewModel
    var makeArticleRow: TopHeadlinesView.MakeArticleRow
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.favoriteArticles.count > 0 {
                    List(viewModel.favoriteArticles) { article in
                        self.makeArticleRow(article)
                    }
               } else {
                   Text("No Favorite Articles found")
               }
            }.navigationBarTitle("Favorite Articles")
        }.onAppear { self.viewModel.onViewAppear() }
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        let di = FavouritesDependencyContainer(appDependencyContainer: AppDependencyContainer())
        return di.makeFavouritesView()
    }
}
