//
//  ListService.swift
//  GithubPR
//
//  Created by Amirthy Tejeshwar Rao on 10/11/22.
//

import Foundation
import RxSwift
import Moya

/// This is the list service used for fetching github pull requests list
final class ListService: ListServiceable {
    /// Github personal access token
    /// Required for seamless usage of app.
    /// Using for personal use only a basic token for the app
    static let GithubPAT: String? = ""
    
    /// Network provider instance injected for list service
    private let networkManager: NetworkProvider
    
    init(networkProvider: NetworkProvider = .shared) {
        self.networkManager = networkProvider
    }
    
    /// This method is used to get the pull requests on basis of page
    /// - Parameter page: page number
    /// - Returns: Observable of Pull request list
    func getPullRequests(page: Int) -> Observable<[PrResponse]> {
        return networkManager
            .makeRequest(
                .target(
                    ListServiceEndPoint.appleRepoPulls(page: page)
                )
            )
    }
}

/// This is the moya target type helper used for the service fetching github pull requests
enum ListServiceEndPoint: TargetType {
    case appleRepoPulls(page: Int)
    // add more cases of different pull request list paths
    
    /// Api request base url
    var baseURL: URL {
        return URL(string: "https://api.github.com/repos/")!
    }
    
    /// Api request path
    var path: String {
        switch self {
        case .appleRepoPulls:
            return "apple/swift/pulls"
        }
    }
    
    /// Api request type
    var method: Moya.Method {
        switch self {
        case .appleRepoPulls:
            return .get
        }
    }
    
    /// Api request task to be prepared
    var task: Moya.Task {
        switch self {
        case .appleRepoPulls:
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    /// Api request headers
    var headers: [String : String]? {
        if let pat = ListService.GithubPAT {
            return ["Authorization": "Bearer \(pat)"]
        }
        return [:]
    }
    
    /// Params used in api, helper computed property
    var params: [String: Any] {
        switch self {
        case .appleRepoPulls(let page):
            return [
                "page": page,
                "per_page": 10
            ]
        }
    }
}
