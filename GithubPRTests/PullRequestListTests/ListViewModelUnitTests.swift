//
//  ListViewModelUnitTests.swift
//  GithubPRTests
//
//  Created by Amirthy Tejeshwar Rao on 11/11/22.
//

import XCTest
import RxTest
import RxSwift
@testable import GithubPR

final class ListViewModelUniTests: XCTestCase {

    private var viewModel : ListViewModel!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var listService: ListServiceable!
    private let loaderItems: [ListSectionItem] = Array(repeating: .loader, count: 10)
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        listService = MockListService()
        viewModel = ListViewModel(service: listService)
    }
    
    override func tearDown() {
        viewModel = nil
        listService = nil
        super.tearDown()
    }
    
    func testGetPullsList() {
        let (showEmptyState,
             listItems,
             apiInProgress,
             errorMessage,
             loadObservable) = getObservables(scheduler: scheduler)
        
        scheduler.createColdObservable([.next(1, true)])
            .bind(to: loadObservable)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(errorMessage.events, [])
        XCTAssertEqual(showEmptyState.events, [.next(0, false), .next(1, false)])
        XCTAssertEqual(apiInProgress.events,
                       [
                        .next(0, false),
                        .next(1, true),
                        .next(1, false)
                       ])
        
        XCTAssertEqual(
            listItems.events,
            [
                .next(
                    0, loaderItems
                ),
                .next(
                    1, [.listItem(PullRequestCellModel(from: .mockResponse)), .loader]
                )
            ]
        )
    }
    
    func testPaginationEnded() {
        let (showEmptyState,
             listItems,
             apiInProgress,
             errorMessage,
             loadObservable) = getObservables(scheduler: scheduler)
        
        scheduler.createColdObservable([.next(1, true), .next(2, false)])
            .bind(to: loadObservable)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(errorMessage.events, [])
        XCTAssertEqual(showEmptyState.events, [.next(0, false),
                                               .next(1, false),
                                               .next(2, false)])
        XCTAssertEqual(apiInProgress.events,
                       [
                        // initial result as we are observing a behaviour relay
                        .next(0, false),
                        // first api mock call
                        .next(1, true),
                        .next(1, false),
                        // second api mock call
                        .next(2, true),
                        .next(2, false)
                       ])
        
        XCTAssertEqual(
            listItems.events,
            [
                .next(
                    0, loaderItems
                ),
                .next(
                    1, [.listItem(PullRequestCellModel(from: .mockResponse)), .loader]
                ),
                .next(
                    2, [.listItem(PullRequestCellModel(from: .mockResponse))]
                )
            ]
        )
    }
    
    func testGetPullsError() {
        let (showEmptyState,
             listItems,
             apiInProgress,
             errorMessage,
             loadObservable) = getObservables(scheduler: scheduler)
        
        (listService as? MockListService)?.isError = true
        
        scheduler.createColdObservable([.next(1, true)])
            .bind(to: loadObservable)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(errorMessage.events,
                       [.next(1, GithubError.parsingError.localizedDescription)])
        
        XCTAssertEqual(showEmptyState.events, [.next(0, false),
                                               .next(1, true),
                                               .completed(1)])
        XCTAssertEqual(apiInProgress.events,
                       [
                        // initial result as we are observing a behaviour relay
                        .next(0, false),
                        // first api mock call
                        .next(1, true),
                        .next(1, false)
                       ])
        
        XCTAssertEqual(
            listItems.events,
            [
                .next(
                    0, loaderItems
                ),
                .next(
                    1, []
                ),
                .completed(1)
            ]
        )
    }
}

extension ListViewModelUniTests {
    func getObservables(scheduler: TestScheduler) -> (TestableObserver<Bool>,
                                                      TestableObserver<[ListSectionItem]>,
                                                      TestableObserver<Bool>,
                                                      TestableObserver<String>,
                                                      PublishSubject<Bool>) {
        let showEmptyState = scheduler.createObserver(Bool.self)
        let listItems = scheduler.createObserver([ListSectionItem].self)
        let apiInProgress = scheduler.createObserver(Bool.self)
        let errorMessage = scheduler.createObserver(String.self)
        
        let loadObservable: PublishSubject<Bool> = PublishSubject()
        let output = viewModel.transform(
            input: ListViewModel.Input(
                loadList: loadObservable.asObservable()
            )
        )
        output.errorMessage
            .drive(errorMessage)
            .disposed(by: disposeBag)
        
        output.sections
            .drive(listItems)
            .disposed(by: disposeBag)
        
        output.showEmptyState
            .drive(showEmptyState)
            .disposed(by: disposeBag)
        
        output.apiProgress
            .drive(apiInProgress)
            .disposed(by: disposeBag)
        
        return (showEmptyState,
                listItems,
                apiInProgress,
                errorMessage,
                loadObservable)
    }
}
