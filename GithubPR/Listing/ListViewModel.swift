//
//  ListViewModel.swift
//  GithubPR
//
//  Created by Amirthy Tejeshwar Rao on 10/11/22.
//

import Foundation
import RxSwift
import RxCocoa

/// This view model is used for showing pull requests list in ListViewController
final class ListViewModel: ViewModel {
    /// Input actions
    struct Input {
        let loadList: Observable<Bool>
    }

    /// Output updates
    struct Output {
        let sections: Driver<[ListSectionItem]>
        let errorMessage: Driver<String>
        let apiProgress: Driver<Bool>
        let showEmptyState: Driver<Bool>
    }

    /// This service is required to get the pull requests list from api
    let service: ListServiceable

    init(service: ListServiceable = ListService()) {
        self.service = service
    }

    /// Processing and generating output from the given input
    func transform(input: Input) -> Output {
        var page: Int = 1
        var paginationEnded: Bool = false
        let errorObservable: PublishSubject<String> = PublishSubject()
        let apiInProgress: BehaviorRelay<Bool> = BehaviorRelay(value: false)

        var items: [PullRequestCellModel] = []

        let listItems = input.loadList
            .withLatestFrom(apiInProgress, resultSelector: { refresh, apiInProgress in
                return (isRefresh: refresh, apiInProgress: apiInProgress)
            })
            .withUnretained(self)
            .flatMap { owner, request -> Observable<(Bool?, [PrResponse])> in
                guard !request.apiInProgress, (request.isRefresh || !paginationEnded)
                else { return .empty() }
                apiInProgress.accept(true)
                return owner.service.getPullRequests(page: request.isRefresh ? 1 : page)
                    .map { (request.isRefresh, $0) }
            }
            .catch { error in
                let githubErrorMessage: String? = (error as? GithubError)?.localizedDescription
                // decrement page number to negate the addition in the failed api flow
                errorObservable.onNext(githubErrorMessage ?? error.localizedDescription)
                apiInProgress.accept(false)
                return .just((nil, []))
            }
            .do(onNext: { refresh, response in
                // refresh is nil when there is an error - just return
                guard let refresh = refresh else {
                    return
                }

                // updating the data below, only once the api call is successful
                
                // check if it was a refresh call and reset the data
                if refresh {
                    items = []
                    page = 1
                    paginationEnded = false
                }
                // increment page number for the next api call
                page += 1
                
                // adding response items to array
                items.append(contentsOf: response.map { PullRequestCellModel(from: $0) })
                
                // pagination ended check
                paginationEnded = response.isEmpty

                // api call completed
                apiInProgress.accept(false)
            })

        let resultsSection: Driver<[ListSectionItem]> = listItems
            .map { refresh, _ -> [ListSectionItem] in
                let loaderItem: [ListSectionItem] = paginationEnded ? [] : [ListSectionItem.loader]
                let resultItems = items.map { ListSectionItem.listItem($0) } + loaderItem
                return refresh != nil ? resultItems : resultItems.compactMap(\.value)
            }
            .startWith(Array(repeating: .loader, count: 10))
            .asDriver(onErrorDriveWith: .empty())

        let emptyState = resultsSection
            .map(\.isEmpty)

        return Output(
            sections: resultsSection,
            errorMessage: errorObservable.asDriver(onErrorDriveWith: .empty()),
            apiProgress: apiInProgress.asDriver(onErrorDriveWith: .empty()),
            showEmptyState: emptyState
        )
    }
}
