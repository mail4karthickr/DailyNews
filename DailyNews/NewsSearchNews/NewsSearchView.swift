//
//  NewsSearchView.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/19/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct NewsSearchView: View {
    typealias MakeNewsSearchView = (Article) -> ArticleRow
    @ObservedObject var viewModel: NewsSearchViewModel
    var makeNewsSearchView: MakeNewsSearchView
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchText, isSearchEnabled: $viewModel.isSearchEnabled) {
                    self.viewModel.searchNews(searchText: $0)
                    UIApplication.shared.endEditing()
                }
                Spacer()
                if viewModel.showNoArticlesMessage {
                    Text("No articles found")
                } else if viewModel.errorMessage.count > 0 {
                    Text(viewModel.errorMessage).multilineTextAlignment(.center)
                } else {
                    List(viewModel.articles) { article in
                       NavigationLink(destination: ReadMoreNewsView(article: article)) {
                            self.makeNewsSearchView(article)
                       }
                    }
                }
                Spacer()
            }
            .navigationBarTitle(Text("Search News"))
        }
    }
}

struct NewsSearchView_Previews: PreviewProvider {
    static var previews: some View {
        let di = NewsSearchDependencyContainer(appDependencyContainer: AppDependencyContainer())
        return NewsSearchView(viewModel: di.makeNewsSearchViewModel(), makeNewsSearchView: di.makeNewsSearchViewRowFactory())
    }
}

