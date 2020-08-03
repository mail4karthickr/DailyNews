//
//  TopHeadLines.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/16/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct News: Codable {
     let status: String
     let totalResults: Int
     let articles: [Article]
}

// MARK: - Article
struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let articleDescription: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
    
    init(source: Source, author: String?, title: String,
         articleDescription: String?, url: String,
         urlToImage: String?, publishedAt: String, content: String?) {
        self.source = source
        self.author = author
        self.title = title
        self.articleDescription = articleDescription
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
    
    init(managedObject: FavoriteArticleManagedObject) {
        self.source = Source(id: managedObject.source?.id, name: managedObject.source?.name)
        self.author = managedObject.author
        self.title = managedObject.title ?? ""
        self.articleDescription = managedObject.articleDescription
        self.url = managedObject.url ?? ""
        self.urlToImage = managedObject.urlToImage
        self.publishedAt = managedObject.publishedAt ?? ""
        self.content = managedObject.content
    }
}

extension Article: Identifiable {
    var id: UUID {
        UUID()
    }
}

public struct Source: Codable {
    let id: String?
    let name: String?
    let sourceDescription: String?
    let url: String?
    let category: String?
    let language: String?
    let country: Country?

    enum CodingKeys: String, CodingKey {
         case sourceDescription = "description"
         case id, name, url, category, language, country
    }

    init(id: String? = nil,
         name: String? = nil,
         sourceDescription: String? = nil,
         url: String? = nil,
         category: String? = nil,
         language: String? = nil,
         country: Country? = nil) {
        self.id = id
        self.name = name
        self.sourceDescription = sourceDescription
        self.url = url
        self.category = category
        self.language = language
        self.country = country
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }
    
    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
