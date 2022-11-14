//
//  GithubError.swift
//  GithubPR
//
//  Created by Amirthy Tejeshwar Rao on 10/11/22.
//

import Foundation

/// This represents the error in application
enum GithubError: Error, Decodable {
    case parsing(String)
    case network(String)
    
    /// This represents the localized description for the error
    var localizedDescription: String {
        switch self {
        case .parsing(let error), .network(let error):
            return error
        }
    }
    
    /// Current error types available
    static let parsingError: GithubError = .parsing(LocalizedString.parseFailure.localized)
    static let networkError: GithubError = .network(LocalizedString.oopsError.localized)
}
