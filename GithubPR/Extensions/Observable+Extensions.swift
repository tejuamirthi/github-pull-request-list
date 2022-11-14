//
//  Observable+Extensions.swift
//  GithubPR
//
//  Created by Amirthy Tejeshwar Rao on 10/11/22.
//

import RxSwift
import Moya

extension ObservableType where Element == Response {
    /// This method is used to map the model from the caller method from response
    /// - Parameter _:  Decodable model type
    /// - Returns: Observable of the Decodable model
    func mapModel<T: Decodable>(_: T.Type) -> Observable<T> {
        return flatMap { response -> Observable<T> in
            if (200..<300) ~= response.statusCode {
                do {
                    let responseModel = try response.map(T.self)
                    return .just(responseModel)
                } catch let error {
                    return .error(GithubError.parsing(error.localizedDescription))
                }
            } else {
                // more network errors can be parsed here
                return .error(GithubError.networkError)
            }
        }
    }
}

