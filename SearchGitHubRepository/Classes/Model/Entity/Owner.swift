//
//  Owner.swift
//  SearchGitHubRepository
//
//  Created by Ishida Naoya on 2020/12/06.
//

import Foundation

class Owner: Codable {
    let login: String
    let id: Int
    let avatarUrl: String?
    let gravatarId: String
    let url: String
    let htmlUrl: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case id = "id"
        case avatarUrl = "avatar_url"
        case gravatarId = "gravatar_id"
        case url = "url"
        case htmlUrl = "html_url"
        case type = "type"
    }
}
