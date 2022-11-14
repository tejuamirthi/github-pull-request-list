//
//  Strings.swift
//  GithubPR
//
//  Created by Amirthy Tejeshwar Rao on 10/11/22.
//

import Foundation

/// This enum represnts the localized string format
/// Should be customized later on for supporting localization
enum LocalizedString: String {
    case emptyPulls = "No pull requests found"
    case oopsError = "Something went wrong"
    case parseFailure = "Failed to parse model"
    case ok = "Ok"
    
    var localized: String {
        return rawValue
    }
}
