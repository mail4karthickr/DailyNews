//
//  TopHeadlinesRowViewModel.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/21/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Combine
import SwiftUI
import CombineExt

extension UserDefaults {
    @objc dynamic var test: Int {
        return integer(forKey: "test")
    }
}

class ArticleRowViewModel: ObservableObject {
    private var bag = Set<AnyCancellable>()
    private var fileManager: ImageFileManagerType
    
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var image: UIImage
    @Published var isFavorite: Bool = false
    
    init(fileManager: ImageFileManagerType) {
        self.image = UIImage(named: "notfound.jpg")!
        self.fileManager = fileManager
        
        onViewAppearSubject
            .map(\.title)
            .assign(to: \.title, on: self)
            .store(in: &bag)
        
        onViewAppearSubject
            .map(\.articleDescription)
            .unwrap()
            .assign(to: \.description, on: self)
            .store(in: &bag)
        
        let imageUrl = onViewAppearSubject
            .map(\.urlToImage)
            .unwrap()
            .map { URL(string: $0) }
            .unwrap()
        
       let imageExists = imageUrl
            .map { ImageFileManager.imageExists(name: $0.lastPathComponent) }
        
        let imageDetails = imageUrl.combineLatest(imageExists) { url, exists in
            return (imageUrl: url, imageExists: exists)
        }
        
       let imageFromStorage = imageDetails
            .filter { $0.imageExists }
            .map { ImageFileManager.imageWith(name: $0.imageUrl.lastPathComponent) }
            .unwrap()
    
        let imageDataFromNetwork = imageDetails
            .filter { !$0.imageExists }
            .flatMap { URLSession.shared.dataTaskPublisher(for: $0.imageUrl)
                .materialize()
            }
            .share(replay: 1)
        
       let networkImageData = imageDataFromNetwork
            .values()
            .map(\.data)
            
       let networkImage = networkImageData
            .map { UIImage(data: $0) }
            .unwrap()
        
        networkImageData.combineLatest(imageUrl)
            .map { ($0.1.lastPathComponent, $0.0) }
            .receive(subscriber: fileManager.saveImage)
        
        let notFoundImage = imageDataFromNetwork
            .failures()
            .map { _ in UIImage(named: "notfound") }
            .unwrap()
        
        imageFromStorage.merge(with: networkImage, notFoundImage)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
            .store(in: &bag)
        
        let isFavorite = onViewAppearSubject
            .map { article in
                FavoriteArticleManagedObject.articleExists(article)
            }
               
       let markAsFavorite = markAsFavoriteSubject
            .withLatestFrom(onViewAppearSubject)
            .handleEvents(receiveOutput: { article in
               let exists = FavoriteArticleManagedObject.articleExists(article)
               if exists {
                   FavoriteArticleManagedObject.delete(article: article)
               } else {
                   FavoriteArticleManagedObject.save(article: article)
               }
            })
            .map { FavoriteArticleManagedObject.articleExists($0) }
        
        Publishers.Merge(markAsFavorite, isFavorite)
            .assign(to: \.isFavorite, on: self)
            .store(in: &bag)
    }
    
    let onViewAppearSubject = PassthroughSubject<Article, Never>()
    func onViewAppear(article: Article) {
        onViewAppearSubject.send(article)
    }
    
    let filterByCategorySubject = PassthroughSubject<Category, Never>()
    func filterByCategory(category: Category) {
        filterByCategorySubject.send(category)
    }
    
    let markAsFavoriteSubject = PassthroughSubject<Void, Never>()
    func markAsFavorite() {
        markAsFavoriteSubject.send()
    }
}
