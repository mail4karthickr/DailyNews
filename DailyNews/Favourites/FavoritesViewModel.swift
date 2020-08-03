//
//  FavoritesViewModel.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 8/2/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import Combine

class FavoritesViewModel: ObservableObject {
    private var bag = Set<AnyCancellable>()
    @Published var favoriteArticles: [Article] = []
    
    init() {
        onViewAppearSubject
            .map {
                FavoriteArticleManagedObject.favoriteArticles()
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.favoriteArticles, on: self)
            .store(in: &bag)
    }
    
    let onViewAppearSubject = PassthroughSubject<Void, Never>()
    func onViewAppear() {
        onViewAppearSubject.send()
    }
}
