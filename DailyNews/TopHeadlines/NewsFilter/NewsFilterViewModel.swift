//
//  NewsFilterViewModel.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/23/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import Combine

class NewsFilterViewModel: ObservableObject {
    private var bag = Set<AnyCancellable>()
    @Published var categories: [Category] = []
    @Published var countries: [Country] = []

    init() {
        onAppearSubject
            .map { Category.allCases }
            .assign(to: \.categories, on: self)
            .store(in: &bag)
        
        onAppearSubject
            .map { Country.allCases }
            .assign(to: \.countries, on: self)
            .store(in: &bag)
    }
    
    let onAppearSubject = PassthroughSubject<Void, Never>()
    func onAppear() {
        onAppearSubject.send()
    }
    
    let applyFilterSubject = PassthroughSubject<Void, Never>()
    func applyFilter() {
        applyFilterSubject.send()
    }
}
