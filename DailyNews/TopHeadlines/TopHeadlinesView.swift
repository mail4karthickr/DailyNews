//
//  TopHeadlinesView.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/19/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import SwiftUI

extension URL: Identifiable {
    public var id: UUID {
        UUID()
    }
}

struct TopHeadlinesView: View {
    typealias MakeArticleRow = (Article) -> ArticleRow
    typealias MakeNewsFilterView = (@escaping ApplyNewsFilter) -> NewsFilterView
    typealias MakeNewsContent = (Article) -> ReadMoreNewsView
    typealias ApplyNewsFilter = () -> ()
    
    @ObservedObject var viewModel: TopHeadlinesViewModel
    @State var presentNewsFilter: Bool = false

    var makeTopHeadlinesRow: MakeArticleRow
    var makeNewsFilterView: MakeNewsFilterView
    
    init(viewModel: TopHeadlinesViewModel,
         makeTopHeadlinesRow: @escaping MakeArticleRow,
         makeNewsFilterView: @escaping MakeNewsFilterView) {
        self.viewModel = viewModel
        self.makeTopHeadlinesRow = makeTopHeadlinesRow
        self.makeNewsFilterView = makeNewsFilterView
        
        UITableView.appearance().allowsSelection = false
        UITableViewCell.appearance().selectionStyle = .none
    }
    
    var body: some View {
        NavigationView {
            LoadingView(isShowing: self.$viewModel.showActivityIndicator) {
                List(self.viewModel.articles) { article in
                    self.makeTopHeadlinesRow(article)
                }
                .navigationBarTitle("TopHeadlines")
                .navigationBarItems(trailing: Button(action: { self.presentNewsFilter.toggle() }) {
                    Image(uiImage: UIImage(named: "filter.png")!)
                        .resizable()
                        .frame(width: 25, height: 25, alignment: .center)
                })
                .sheet(isPresented: self.$presentNewsFilter) {
                   NavigationView {
                       self.makeNewsFilterView {
                           self.viewModel.applyFilter()
                       }
                   }
                }
            }
        }
        .onAppear { self.viewModel.onViewAppear() }
    }
}

struct TopHeadlinesView_Previews: PreviewProvider {
    static var previews: some View {
        let di = TopHeadlinesDependencyContainer(appDependencyContainer: AppDependencyContainer())
        return di.makeTopHeadlinesView()
    }
}
