//
//  ListSectionItem.swift
//  GithubPR
//
//  Created by Amirthy Tejeshwar Rao on 10/11/22.
//

import Foundation

/// This is the pull request table view item model
enum ListSectionItem: Equatable {
    case listItem(PullRequestCellModel)
    case loader
    
    var value: ListSectionItem? {
        switch self {
        case .listItem:
            return self
        case .loader:
            return nil
        }
    }
}

/// This is the pr cell model
struct PullRequestCellModel: Equatable {
    let status: PrState
    let title: String
    let body: String?
    let number: String
    let lastUpdated: String?
    let assigneeImage: String?
    let isDraft: Bool
    let issueLabel: IssueLabel?
    
    init(status: PrState,
         title: String,
         body: String?,
         number: String,
         lastUpdated: String?,
         assigneeImage: String?,
         isDraft: Bool,
         issueLabel: IssueLabel?) {
        self.status = status
        self.title = title
        self.body = body
        self.number = number
        self.lastUpdated = lastUpdated
        self.assigneeImage = assigneeImage
        self.isDraft = isDraft
        self.issueLabel = issueLabel
    }
    
    init(from response: PrResponse) {
        self.init(status: response.state,
                  title: response.title,
                  body: response.body,
                  number: "\(response.number)",
                  lastUpdated: response.updatedAt,
                  assigneeImage: response.assignee?.avatarUrl,
                  isDraft: response.draft,
                  issueLabel: response.issueLabel)
    }
    
}

/*
 
extension PullRequestCellModel {
    static let model = PullRequestCellModel(status: .open,
                                            title: "Title of the pr\nTitle of the pr. Title of the pr",
                                            body: "Body of the pr",
                                            number: "12345",
                                            lastUpdated: "2022-11-10T03:41:38Z",
                                            assigneeImage: "https://avatars.githubusercontent.com/u/29634986?v=4",
                                            isDraft: false,
                                            issueLabel: IssueLabel(name: "Bug", color: "f39b2d"))
}
*/
