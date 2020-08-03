//
//  NewsFilterRowViewModel.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/26/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import Combine

extension UserDefaults {
    @objc dynamic var selectedCategory: String {
        return string(forKey: "selectedCategory") ?? "selectedCategory"
    }
}

class CategoryFilterRowViewModel: ObservableObject {
    @Published var isSelected: Bool = false
    var bag = Set<AnyCancellable>()
    
    init() {
        let categorySelected = categorySelectedSubject
            .withLatestFrom(onAppearSubject)
            
        categorySelected
            .sink(receiveValue: { category in
                UserDefaults.standard.set(category, forKey: "selectedCategory")
            })
            .store(in: &bag)
        
       onAppearSubject
            .combineLatest(UserDefaults.standard.publisher(for: \.selectedCategory))
            .map { $0.0 == $0.1 ? true : false }
            .assign(to: \.isSelected, on: self)
            .store(in: &bag)
    }
    
    let onAppearSubject = PassthroughSubject<String, Never>()
    func onAppear(category: String) {
        onAppearSubject.send(category)
    }
    
    let categorySelectedSubject = PassthroughSubject<Void, Never>()
    func categorySelected() {
        categorySelectedSubject.send()
    }
}
