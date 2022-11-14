//
//  MockListService.swift
//  GithubPRTests
//
//  Created by Amirthy Tejeshwar Rao on 11/11/22.
//

import RxSwift
@testable import GithubPR

class MockListService: ListServiceable {
    var isError: Bool = false
    func getPullRequests(page: Int) -> Observable<[PrResponse]> {
        if isError {
            return .error(GithubError.parsingError)
        }
        if page == 1 {
            return .just([.mockResponse])
        }
        return .just([])
    }
}

extension PrResponse {
    static let mockResponse = PrResponse(title: "Pr title",
                                         number: 1234,
                                         state: .open,
                                         draft: true,
                                         body: "Pr body")
}
