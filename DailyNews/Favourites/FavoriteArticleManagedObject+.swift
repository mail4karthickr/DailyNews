//
//  FavoriteArticleManagedObject+.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 8/2/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import CoreData
import Combine

extension FavoriteArticleManagedObject {
    static func save(article: Article) {
        let newArticle = self.init(context: CoreDataStack.viewContext)
        newArticle.author = article.author
        newArticle.articleDescription = article.articleDescription
        newArticle.content = article.content
        newArticle.source?.id = article.source.id
        newArticle.source?.name = article.source.name
        newArticle.publishedAt = article.publishedAt
        newArticle.title = article.title
        newArticle.url = article.url
        newArticle.urlToImage = article.urlToImage
        
        do {
            try CoreDataStack.viewContext.save()
        } catch {
            fatalError("\(#file), \(#function), \(error.localizedDescription)")
        }
    }
    
    static func favoriteArticles() -> [Article] {
        return favoriteArticlesMangedObjects()
            .map { Article(managedObject: $0) }
    }
    
    static func favoriteArticlesMangedObjects() -> [FavoriteArticleManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteArticleManagedObject")
        do {
            let results = try CoreDataStack.viewContext.fetch(fetchRequest)
            let articles = results
                .compactMap { $0 as? FavoriteArticleManagedObject }
            return articles
           } catch {
            print("\(error)")
            return []
        }
    }
    
    static func articleExists(_ article: Article) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteArticleManagedObject")
        let predicate = NSPredicate(format: "url == %@", article.url)
        fetchRequest.predicate = predicate
        do {
            let results = try CoreDataStack.viewContext.fetch(fetchRequest)
            return results.count > 0
           } catch {
            print("\(error)")
            return false
        }
    }
    
    static func fetchMangedObject(forArticle article: Article) -> [FavoriteArticleManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteArticleManagedObject")
        let predicate = NSPredicate(format: "url == %@", article.url)
        fetchRequest.predicate = predicate
        do {
            let results = try CoreDataStack.viewContext.fetch(fetchRequest)
            let articles = results
                .compactMap { $0 as? FavoriteArticleManagedObject }
            return articles
           } catch {
            print("\(error)")
            return []
        }
    }
    
    static func delete(article: Article) {
        let managedObjects = fetchMangedObject(forArticle: article)
        for managedObject in managedObjects {
            CoreDataStack.viewContext.delete(managedObject)
        }
        do {
            try CoreDataStack.viewContext.save()
        } catch {
            fatalError("\(#file), \(#function), \(error.localizedDescription)")
        }
    }
}
