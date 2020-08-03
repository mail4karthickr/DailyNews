//
//  RequestBuilder.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/19/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case get = "Get"
    case post = "Post"
}

enum NewsApiRequests {
    case getTopHeadlines(HeadlinesReqParams)
    case getTopHeadlinesFromSources(HeadlinesFromSourcesReqParams)
    case getNewsSources(NewsSourcesReqParams)
    case searchNews(String)
    
    var apiKey: String {
        return "36abe08b45174f0fa75b3d03bfac2c4f"
    }
    
    var httpMethod: HttpMethod {
        return .get
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = postBody
        return request
    }
    
    var url: URL {
       var urlComponents = URLComponents()
       urlComponents.scheme = "https"
       urlComponents.host = "newsapi.org"
       urlComponents.path = self.path
        urlComponents.queryItems = self.queryItems?.filter { $0.value != nil } ?? []
       urlComponents.queryItems?.append(URLQueryItem(name: "apiKey", value: apiKey))
       return urlComponents.url!
    }
    
    var path: String {
        switch self {
        case .getTopHeadlines(_),
             .getTopHeadlinesFromSources(_):
            return "/v2/top-headlines"
        case .getNewsSources(_):
            return "/v2/sources"
        case .searchNews(_):
            return "/v2/everything"
        }
    }
    
    var postBody: Data? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .getTopHeadlines(let params):
            return [
                URLQueryItem(name: "country", value: params.country.code),
                URLQueryItem(name: "category", value: params.category?.rawValue),
                URLQueryItem(name: "q", value: params.keyword),
                URLQueryItem(name: "pageSize", value: params.pageSize),
                URLQueryItem(name: "pageSize", value: params.page)
            ]
        case .getTopHeadlinesFromSources(let params):
            return [
                URLQueryItem(name: "sources", value: params.sources.joined(separator: ",")),
                URLQueryItem(name: "pageSize", value: params.pageSize),
                URLQueryItem(name: "page", value: params.page)
            ]
        case .getNewsSources(let params):
            return [
                URLQueryItem(name: "category", value: params.category?.rawValue),
                URLQueryItem(name: "language", value: params.language?.rawValue),
                URLQueryItem(name: "country", value: params.country?.rawValue)
            ]
        case .searchNews(let searchText):
            return [
                URLQueryItem(name: "q", value: searchText)
            ]
        }
    }
}
