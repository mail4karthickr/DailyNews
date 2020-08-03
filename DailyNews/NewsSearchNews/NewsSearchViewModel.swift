//
//  NewsSearchViewModel.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/30/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import Combine

class NewsSearchViewModel: ObservableObject {
    private var bag = Set<AnyCancellable>()
    @Published var searchText: String = ""
    @Published var articles: [Article] = []
    @Published var showNoArticlesMessage: Bool = false
    @Published var errorMessage: String = ""
    @Published var showActivityIndicator = false
    @Published var isSearchEnabled = false
    
    init(service: Service) {
        
        let searchArticlesResponse = searchNewsSubject
            .flatMapLatest { service.searchNews(text: $0).materialize() }
            .handleEvents(receiveOutput: { val in
                print(val)
            })
            .share(replay: 1)
        
        let articles = searchArticlesResponse
            .values()
            .map(\.articles)
            .handleEvents(receiveOutput: { val in
                print(val)
            })
        
        $searchText
            .map { $0.count > 0 ? true : false }
            .handleEvents(receiveOutput: { val in
                print(val)
            })
            .receive(on: DispatchQueue.main)
            .assign(to: \.isSearchEnabled, on: self)
            .store(in: &bag)
        
        let shouldShowNoArticlesMessage = articles
            .map { $0.count == 0 ? true : false }
        
        shouldShowNoArticlesMessage
            .handleEvents(receiveOutput: { val in
                print(val)
            })
            .receive(on: DispatchQueue.main)
            .assign(to: \.showNoArticlesMessage, on: self)
            .store(in: &bag)
        
        articles
            .receive(on: DispatchQueue.main)
            .assign(to: \.articles, on: self)
            .store(in: &bag)
        
        searchArticlesResponse
            .failures()
            .handleEvents(receiveOutput: { val in
                print(val)
            })
            .map { $0.localizedDescription }
            .receive(on: DispatchQueue.main)
            .assign(to: \.errorMessage, on: self)
            .store(in: &bag)
        
        Publishers.Merge(searchNewsSubject.map { _ in true },
                         searchArticlesResponse.map { _ in false })
            .receive(on: DispatchQueue.main)
            .assign(to: \.showActivityIndicator, on: self)
            .store(in: &bag)
    }
    
    let searchNewsSubject = PassthroughSubject<String, Never>()
    func searchNews(searchText: String) {
        searchNewsSubject.send(searchText)
    }
}
