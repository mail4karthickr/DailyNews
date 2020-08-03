//
//  ContentView.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/13/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var topHeadlinesView: TopHeadlinesView
    var newsSearchView: NewsSearchView
    var favouritesView: FavouritesView
    
    init(topHeadlinesView: TopHeadlinesView,
         newsSearchView: NewsSearchView,
         favouritesView: FavouritesView) {
        self.topHeadlinesView = topHeadlinesView
        self.newsSearchView = newsSearchView
        self.favouritesView = favouritesView
    }
    
    var body: some View {
        TabView {
                topHeadlinesView
                .tabItem {
                    Image("TopHeadLines")
                    Text("Headlines")
                }
                .tag(0)
            newsSearchView
                .tabItem {
                Image(systemName: "magnifyingglass")
                Text("NewsSearchView")
            }
            .tag(1)
            favouritesView
                .tabItem {
                Image(systemName: "heart")
                Text("FavouritesView")
            }
            .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let container = AppDependencyContainer()
        return container.makeContentView()
    }
}
