//
//  TopHeadlinesRow.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/21/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import SwiftUI

extension UserDefaults {
    @objc dynamic var favoriteArticle: String {
        return string(forKey: "selectedCategory") ?? "selectedCategory"
    }
}

struct ArticleRow: View {
    var article: Article
    @State var selection: Int? = 0
    @ObservedObject var viewModel: ArticleRowViewModel
    
    init(article: Article,
         viewModel: ArticleRowViewModel) {
        self.article = article
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
                NavigationLink(destination: ReadMoreNewsView(article: article)) {
                    VStack(alignment: .leading, spacing: 10) {
                        Image(uiImage: self.viewModel.image)
                                             .resizable()
                                             .frame(width: 340, height: 170, alignment: .leading)
                        Text(self.viewModel.title).lineLimit(2).font(.headline)
                        Text(self.viewModel.description).font(.body)
                    }
                }
                Button(action: {}) {
                    Group {
                        if viewModel.isFavorite {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .frame(width: 25, height: 20)
                       } else {
                           Image(systemName: "heart")
                            .resizable()
                           .frame(width: 25, height: 20)
                       }
                    }
                    .foregroundColor(.blue)
                }.onTapGesture {
                    self.viewModel.markAsFavorite()
                }
        }.onAppear { self.viewModel.onViewAppear(article: self.article) }
    }
}

struct TopHeadlinesRow_Previews: PreviewProvider {
    static var previews: some View {
        let source = Source()
        
        let article = Article(source: source, author: "Author",
                                   title: "Covid", articleDescription: "desc",
                                   url: "https://picsum.photos/",
                                   urlToImage: "https://picsum.photos/200/300",
                                   publishedAt: "22/3/1990", content: "content")
        let di = TopHeadlinesDependencyContainer(appDependencyContainer: AppDependencyContainer())
        return di.makeTopHeadlinesRow(article: article)
    }
}
