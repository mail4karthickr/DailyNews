//
//  Services.swift
//  DailyNews
//
//  Created by Karthick Ramasamy on 7/13/20.
//  Copyright © 2020 Karthick Ramasamy. All rights reserved.
//

import Foundation
import Combine

enum ServiceError: Error {
    case networkError(URLError)
    case parsingError(String)
    case apiError(ApiError)
    case unknown
}

extension ServiceError {
    var localizedDescription: String {
        switch self {
        case .networkError(_):
            return "Network Error. Please try again later."
        case .parsingError(_), .apiError(_):
            return "Network Error. Please contact support at 1800034567"
        default:
            return "An error occurred. Please contact support at 1800034567"
        }
    }
}

enum ArticlesSortBy {
    case relevancy, popularity, publishedAt
}

enum ResponseType {
    case error
    case ok
}

struct ApiError: Error {
    let code: ApiErrorCode
    let message: String
    
    init(code: String, message: String) {
        self.code = ApiErrorCode(rawValue: code) ?? .unknown
        self.message = message
    }
}

enum ApiErrorCode: String {
    case apiKeyDisabled
    case apiKeyExhausted
    case apiKeyInvalid
    case apiKeyMissing
    case parameterInvalid
    case parametersMissing
    case rateLimited
    case sourcesTooMany
    case sourceDoesNotExist
    case unexpectedError
    case unknown
}

struct ErrorResponse {
    var status: ResponseType
    var message: String
    var code: ApiErrorCode
}

protocol ServiceType {
    func getTopHeadlines(params: HeadlinesReqParams) -> AnyPublisher<News, ServiceError>
    
    func getTopHeadlines(params:HeadlinesFromSourcesReqParams) -> AnyPublisher<News, ServiceError>
    
    func getNewsSources(params: NewsSourcesReqParams) -> AnyPublisher<[String], ServiceError>
    
    func searchNews(text: String) -> AnyPublisher<News, ServiceError>
}

class Service {
    fileprivate func makeRequest<T: Codable>(request: URLRequest) -> AnyPublisher<T, ServiceError> {
        return URLSession
            .shared
            .dataTaskPublisher(for: request)
            .tryMap { data, _ in
                guard let obj = try? JSONSerialization.jsonObject(with: data),
                    let dict = obj as? [String: Any],
                    dict["status"] as? String == "Error" else {
                        return data
                }
                let code = dict["code"] as? String ?? ""
                let message = dict["message"] as? String ?? ""
                throw ApiError(code: code, message: message)
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> ServiceError in
                switch error {
                case is DecodingError:
                    let decodingError = error as! DecodingError
                    return .parsingError(decodingError.errorDescription ?? "")
                case is ApiError:
                    return .apiError(error as! ApiError)
                case is URLError:
                    return .networkError(error as! URLError)
                default:
                    return .unknown
                }
        }
        .eraseToAnyPublisher()
    }
}

extension Service: ServiceType {
    func getTopHeadlines(params: HeadlinesReqParams) -> AnyPublisher<News, ServiceError> {
        let request = NewsApiRequests.getTopHeadlines(params).urlRequest
        return makeRequest(request: request)
    }
    
    func getTopHeadlines(params:HeadlinesFromSourcesReqParams) -> AnyPublisher<News, ServiceError> {
        let request = NewsApiRequests.getTopHeadlinesFromSources(params).urlRequest
        return makeRequest(request: request)
    }
    
    func getNewsSources(params: NewsSourcesReqParams) -> AnyPublisher<[String], ServiceError> {
        let request = NewsApiRequests.getNewsSources(params).urlRequest
        return makeRequest(request: request)
    }

    func searchNews(text: String) -> AnyPublisher<News, ServiceError> {
        let request = NewsApiRequests.searchNews(text).urlRequest
        return makeRequest(request: request)
    }
}
