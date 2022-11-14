//
//  ListServiceable.swift
//  GithubPR
//
//  Created by Amirthy Tejeshwar Rao on 10/11/22.
//

import Foundation
import RxSwift

/// This is the list service protocol which can be mocked and injected into viewmodel
protocol ListServiceable {
    func getPullRequests(page: Int) -> Observable<[PrResponse]>
}
