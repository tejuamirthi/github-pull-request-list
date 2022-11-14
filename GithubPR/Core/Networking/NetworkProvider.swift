//
//  NetworkProvider.swift
//  GithubPR
//
//  Created by Amirthy Tejeshwar Rao on 10/11/22.
//

import Foundation
import Moya
import Alamofire
import RxMoya
import RxSwift

/// This class is used as the network session provider for the application
/// Wrapper around moya provider
class NetworkProvider {
    /// This property represents the moya network provider
    private var moyaProvider: MoyaProvider<MultiTarget>

    init(session: Session = Alamofire.Session.default) {
        moyaProvider = MoyaProvider<MultiTarget>(session: session)
    }
    
    /// This method is used to make api calls based on various target types
    /// - Parameter service: target type that confirms to moya
    /// - Returns: Observable sequence of the response
    func makeRequest<A: Decodable>(_ service: MultiTarget) -> Observable<A> {
        return moyaProvider.rx.request(service)
            .asObservable()
            .mapModel(A.self)
    }
}

// MARK: - Network Provider singleton
extension NetworkProvider {
    static let shared: NetworkProvider = NetworkProvider()
}
