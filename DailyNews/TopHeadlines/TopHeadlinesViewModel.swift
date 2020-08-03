//
//  SettingsViewModel.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/13/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import Combine
import CombineExt

enum SettingsItems {
    case country
    case category
}

enum NewsCategory {
    case entertainment
    case general
    case health
    case science
    case sports
    case technology
}

enum Country: String, CaseIterable, Identifiable {
    case argentina = "Argentina"
    case austria = "Austria"
    case australia = "Australia"
    case belgium = "Belgium"
    case brazil = "Brazil"
    case canada = "Canada"
    case china = "China"
    case france = "France"
    case germany = "Germany"
    case hongKong = "HongKong"
    case india = "India"
    case ireland = "Ireland"
    case israel = "Israel"
    case italy = "Italy"
    case malaysia = "Malaysia"
    case mexico = "Mexico"
    case netherlands = "Netherlands"
    case newZealand = "NewZealand"
    case norway = "Norway"
    case philippines = "Philippines"
    case singaporev = "Singaporev"
    case southAfrica = "SouthAfrica"
    case southKorea = "SouthKorea"
    case swedon = "Swedon"
    case switzerland = "Switzerland"
    case taiwan = "Taiwan"
    case thailand = "Thailand"
    case uae = "Uae"
    case unitedKingdom = "UnitedKingdom"
    case unitedStates = "UnitedStates"
    case venuzuela = "Venuzuela"
    
    var id: UUID { UUID() }
    
    var code: String {
        switch self {
        case .argentina: return "ar"
        case .australia: return "au"
        case .austria: return "at"
        case .belgium: return "be"
        case .brazil: return "br"
        case .canada: return "ca"
        case .china: return "cn"
        case .france: return "fr"
        case .germany: return "de"
        case .hongKong: return "hk"
        case .india: return "in"
        case .ireland: return "ie"
        case .israel: return "il"
        case .italy: return "it"
        case .malaysia: return "my"
        case .mexico: return "mx"
        case .netherlands: return "nl"
        case .newZealand: return "nz"
        case .norway: return "no"
        case .philippines: return "ph"
        case .singaporev: return "sg"
        case .southAfrica: return "za"
        case .southKorea: return "kr"
        case .swedon: return "se"
        case .switzerland: return "ch"
        case .taiwan: return "tw"
        case .thailand: return "th"
        case .uae: return "ae"
        case .unitedKingdom: return "gb"
        case .unitedStates: return "us"
        case .venuzuela: return "ve"
        }
    }
}

struct CountryInfo {
    var title: String
    var description: String
    var selectedCountry: Country
}

class TopHeadlinesViewModel: ObservableObject {
    private var service: Service
    private var bag = Set<AnyCancellable>()
    
    @Published var showActivityIndicator = false
    @Published var articles: [Article] = []
    @Published var errorMessage: String? = nil
    @Published var selectedArticle: Article?
    
    private let errorSubject = PassthroughSubject<ServiceError, Never>()
    
    init(service: Service) {
        self.service = service
        
        let startNewsDownload = viewAppearSubject
            .merge(with: applyFilterSubject)
    
        let fetchedHeadlines = startNewsDownload
            .map {
                (category: UserDefaults.standard.string(forKey: "selectedCategory") ?? Category.business.rawValue,
                 country: UserDefaults.standard.string(forKey: "selectedCountry") ?? Country.unitedStates.rawValue)
            }
            .print()
            .flatMap { self.service.getTopHeadlines(params:
                HeadlinesReqParams(
                    country: Country(rawValue: $0.country) ?? .unitedStates,
                    category: Category(rawValue: $0.category) ?? .business
                )
            )
            .materialize()
            .share(replay: 1) }
        
        openNewsContentSubject
            .map { Optional.some($0) }
            .assign(to: \.selectedArticle, on: self)
            .store(in: &bag)
        
        let articles = fetchedHeadlines
            .values()
            .map(\.articles)
        
        let serviceError = fetchedHeadlines
            .failures()
            .map { $0.localizedDescription }
            .map { Optional.some($0) }
        
        articles
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { val in
                print("Articles -- \(val)")
            })
            .assign(to: \.articles, on: self)
            .store(in: &bag)
        
        serviceError
            .receive(on: DispatchQueue.main)
            .assign(to: \.errorMessage, on: self)
            .store(in: &bag)
        
        Publishers.Merge(startNewsDownload.map { _ in true },
                         fetchedHeadlines.map { _ in false })
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput:{ val in
                print(val)
            })
            .assign(to: \.showActivityIndicator, on: self)
            .store(in: &bag)
    }
    
    let fetchHeadlinesSubject = PassthroughSubject<Void, Never>()
    func fetchTopHeadlines() {
        fetchHeadlinesSubject.send()
    }
    
    let viewAppearSubject = PassthroughSubject<Void, Never>()
    func onViewAppear() {
        viewAppearSubject.send()
    }
    
    private let openNewsContentSubject = PassthroughSubject<Article, Never>()
    func openNewsContent(article: Article) {
        openNewsContentSubject.send(article)
    }
    
    private let applyFilterSubject = PassthroughSubject<Void, Never>()
    func applyFilter() {
        applyFilterSubject.send()
    }
}
