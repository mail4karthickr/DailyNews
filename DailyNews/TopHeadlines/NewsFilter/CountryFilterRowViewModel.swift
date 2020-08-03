//
//  NewsFilterRowViewModel.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/26/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import Combine
import Defaults

extension Defaults.Keys {
    static let selectedCountry = Key<String>("selectedCountry", default: Country.unitedStates.rawValue)
}

class CountryFilterRowViewModel: ObservableObject {
    @Published var isSelected: Bool = false
    var bag = Set<AnyCancellable>()
    
    init() {
        let countrySelected = countrySelectedSubject
            .withLatestFrom(onAppearSubject)
            
        countrySelected
            .sink(receiveValue: { country in
                Defaults[.selectedCountry] = country
            })
            .store(in: &bag)
        
        let storedCountry = Defaults.publisher(.selectedCountry)
            .map { $0.newValue }
            .handleEvents(receiveOutput: {
                print("Val is \($0)")
            })

        onAppearSubject
            .combineLatest(storedCountry)
            .map { $0.0 == $0.1 ? true : false }
            .assign(to: \.isSelected, on: self)
            .store(in: &bag)
    }
    
    let onAppearSubject = PassthroughSubject<String, Never>()
    func onAppear(country: String) {
        onAppearSubject.send(country)
    }
    
    let countrySelectedSubject = PassthroughSubject<Void, Never>()
    func countrySelected() {
        countrySelectedSubject.send()
    }
}
