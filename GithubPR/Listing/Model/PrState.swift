//
//  PrState.swift
//  GithubPR
//
//  Created by Amirthy Tejeshwar Rao on 10/11/22.
//

import Foundation

/// This repesents the pr state from response
enum PrState: String, CaseIterable, Decodable, Equatable {
    case open
    case merged
    case closed
    
    /// This method is used to get the image name for the respective type
    /// - Returns: image name
    func getImage() -> Images {
        switch self {
        case .open:
            return Images.pullRequest
        case .merged:
            return Images.mergedRequest
        case .closed:
            return Images.closedRequest
        }
    }
}
