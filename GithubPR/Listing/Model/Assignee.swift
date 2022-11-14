//
//  Assignee.swift
//  GithubPR
//
//  Created by Amirthy Tejeshwar Rao on 10/11/22.
//

import Foundation

/// This represents the assignee for github pull request - from response
struct Assignee: Decodable {
    let login: String?
    let avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.login = try? container?.decodeIfPresent(String.self, forKey: .login)
        self.avatarUrl = try? container?.decodeIfPresent(String.self, forKey: .avatarUrl)
    }
}
