//
//  PrResponse.swift
//  GithubPR
//
//  Created by Amirthy Tejeshwar Rao on 10/11/22.
//

import Foundation

/// This represents the github list item from response
struct PrResponse: Decodable {
    let title: String
    let number: Int
    let state: PrState
    let draft: Bool
    let body: String
    let createdAt: String?
    let updatedAt: String?
    let assignee: Assignee?
    let issueLabel: IssueLabel?
    
    enum CodingKeys: String, CodingKey {
        case title
        case number
        case state
        case draft
        case body
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case assignee
        case labels
    }
    
    init(title: String,
         number: Int,
         state: PrState,
         draft: Bool,
         body: String,
         createdAt: String? = nil,
         updatedAt: String? = nil,
         assignee: Assignee? = nil,
         issueLabel: IssueLabel? = nil) {
        self.title = title
        self.number = number
        self.state = state
        self.draft = draft
        self.body = body
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.assignee = assignee
        self.issueLabel = issueLabel
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        self.title = (try? container?.decode(String.self, forKey: .title)) ?? ""
        self.number = (try? container?.decode(Int.self, forKey: .number)) ?? 0
        self.state = (try? container?.decode(PrState.self, forKey: .state)) ?? .open
        self.draft = (try? container?.decode(Bool.self, forKey: .draft)) ?? false
        self.body = (try? container?.decode(String.self, forKey: .body)) ?? ""
        self.createdAt = try? container?.decodeIfPresent(String.self, forKey: .createdAt)
        self.updatedAt = try? container?.decodeIfPresent(String.self, forKey: .updatedAt)
        self.assignee = try? container?.decodeIfPresent(Assignee.self, forKey: .assignee)
        self.issueLabel = (try? container?.decodeIfPresent([IssueLabel].self, forKey: .labels))?.first
    }
}

struct IssueLabel: Decodable, Equatable {
    let name: String?
    let color: String?
}
