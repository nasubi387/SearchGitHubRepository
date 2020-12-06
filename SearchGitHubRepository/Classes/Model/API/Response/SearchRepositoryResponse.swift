//
//  SearchRepositoryResponse.swift
//  SearchGitHubRepository
//
//  Created by Ishida Naoya on 2020/12/06.
//

import Foundation

struct SearchRepositoryResponse: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Repository]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items = "items"
    }
}
