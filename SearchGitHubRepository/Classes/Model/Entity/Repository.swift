//
//  Repository.swift
//  SearchGitHubRepository
//
//  Created by Ishida Naoya on 2020/12/06.
//

import Foundation

struct Repository: Codable {
    let id: Int
    let name: String
    let fullName: String
    let owner: Owner
    let isPrivate: Bool
    let htmlUrl: String
    let description: String?
    let fork: Bool
    let url: String
    let createdAt: String
    let updatedAt: String
    let pushedAt: String
    let homepage: String?
    let size: Int
    let stargazersCount: Int
    let watchersCount: Int
    let language: String?
    let forksCount: Int
    let openIssuesCount: Int
    let forks: Int
    let watchers: Int
    let defaultBranch: String
    let score: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case fullName = "full_name"
        case owner = "owner"
        case isPrivate = "private"
        case htmlUrl = "html_url"
        case description = "description"
        case fork = "fork"
        case url = "url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case pushedAt = "pushed_at"
        case homepage = "homepage"
        case size = "size"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case language = "language"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case forks = "forks"
        case watchers = "watchers"
        case defaultBranch = "default_branch"
        case score = "score"
    }
}

