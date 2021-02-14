//
//  File.swift
//  SearchGitHubRepository
//
//  Created by 薩佳史 on 2021/02/14.
//

import Foundation

public struct User: Decodable{
    public var id: Int
    public var login: String
}

public struct Repository: Decodable{
    public var id: Int
    public var name: String
    public var fullName: String
    public var owner: User
    
    public enum CodingKeys: String, CodingKey{
        case id
        case name
        case fullName = "full_name"
        case owner
    }
}

public struct SearchResponse<Item: Decodable>: Decodable{
    public var totalCount: Int
    public var items: [Item]
    
    public enum Codingkeys: String, CodingKey{
        case totalCount = "total_count"
        case items
    }
}

public protocol GitHubRequest{
    associatedtype Response: Decodable
    
    var baseURL: URL{get}
    var path: String{get}
    var method: HTTPMethod{get}
    var queryItems: [URLQueryItem]{get}
}

public extension GitHubRequest{
    var baseURL: URL{
        return URL(string: "http://spi.github.com")!
    }
    
    func buildURLRequest() -> URLRequest{
        let url = baseURL.appendingPathComponent(path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        switch method {
        case .get: components?.queryItems = queryItems
        default: fatalError()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.url = components?.url
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}

public enum HTTPMethod: String{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case head = "HEAD"
    case delete = "DELETE"
    case patch = "PATCH"
    case trace = "TRACE"
    case options = "OPTIONS"
    case connect = "CONNECT"
}

public final class GitHubAPI{
    public struct SearchRepositories: GitHubRequest{
        public let keyword: String
        
        public typealias Response = SearchResponse<Repository>
        
        public var method: HTTPMethod{
            return .get
        }
        
        public var path: String{
            return "/search/repositories"
        }
        
        public var queryItems: [URLQueryItem]{
            return [URLQueryItem(name: "q", value: keyword)]
        }
    }
}
