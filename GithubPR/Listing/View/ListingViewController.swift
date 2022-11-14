//
//  ListingViewController.swift
//  GithubPR
//
//  Created by Amirthy Tejeshwar Rao on 10/11/22.
//

import UIKit
import RxSwift
import RxCocoa

/// This class represents the pull requests list
final class ListViewController: UIViewController {
    /// These constants are used as reuse identifiers for the table view
    private enum Constants: String {
        case pullRequestTableViewCell
        case emptyTableViewCell
        case loaderCell
    }
    
    /// This view is used to display all the pr items
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(PullRequestTableViewCell.self,
                           forCellReuseIdentifier: Constants.pullRequestTableViewCell.rawValue)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: Constants.emptyTableViewCell.rawValue)
        tableView.register(LoaderCell.self,
                           forCellReuseIdentifier: Constants.loaderCell.rawValue)
        return tableView
    }()
    
    /// This is used to show refresh icon when we try to drag and refresh tableviw
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    /// This view used to show emtpy view when the table view items are empty
    private lazy var emptyView: EmptyView = EmptyView(title: LocalizedString.emptyPulls.localized,
                                                      image: .emptyImage)
    
    /// This is used to show list of items in table view
    private var items: [ListSectionItem] = []
    
    /// This represents the view model where this controller fetches data
    private let viewModel: ListViewModel
    
    /// This is used to store the disposables for attaching subscriptions to this controller
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// This method is called as a part of lifecycle when the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubviews(views: tableView, emptyView)
        tableView.addConstarint(top: view.safeAreaLayoutGuide.topAnchor,
                                leading: view.safeAreaLayoutGuide.leadingAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                trailing: view.safeAreaLayoutGuide.trailingAnchor)
        emptyView.addConstarint(top: view.safeAreaLayoutGuide.topAnchor,
                                leading: view.safeAreaLayoutGuide.leadingAnchor,
                                bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                trailing: view.safeAreaLayoutGuide.trailingAnchor)
        emptyView.isHidden = true
        tableView.backgroundColor = .systemBackground
        emptyView.backgroundColor = .systemBackground
        
        
        tableView.refreshControl = refreshControl
        
        tableView.delegate = self
        tableView.dataSource = self
        
        bindViewModel()
    }
    
    /// This method is used to bind the view model with this controller
    private func bindViewModel() {
        let loadListObservable = Observable.merge(
            // initial view did load call to make api call
            // added debounce here to make the shimmer visible, on production env we can remove it.
            Observable<Bool>.just(true)
                .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance),
            // pagination call
            tableView.rx.reachedBottom()
                .map { _ in false },
            // refresh
            refreshControl.rx.controlEvent(.valueChanged)
                .map { _ in true }
        ).throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
        
        let output = viewModel.transform(input: ListViewModel.Input(loadList: loadListObservable))
        
        output.sections
            .distinctUntilChanged()
            .drive(onNext: { [weak self] items in
                self?.items = items
                self?.tableView.separatorStyle = .none
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }).disposed(by: disposeBag)
        
        output.showEmptyState
            .distinctUntilChanged()
            .drive(onNext: { [weak self] show in
                self?.tableView.isHidden = show
                self?.emptyView.isHidden = !show
            }).disposed(by: disposeBag)
        
        output.apiProgress
            .drive(onNext: { [weak self] inProgress in
                if !inProgress {
                    self?.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
        
        output.errorMessage
            .drive(onNext: { [weak self] message in
                self?.showAlert(title: LocalizedString.oopsError.localized,
                                message: message)
            }).disposed(by: disposeBag)
    }
}

// MARK: - Table view datasource, delegate
extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    /// This method is used to get the row count for the table view list
    /// - Parameters:
    ///   - tableView: table view
    ///   - section: Int - items in this section number
    /// - Returns: Int - items count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    /// This method is used to populate the pr cell
    /// - Parameters:
    ///   - tableView: tableview
    ///   - indexPath: indexpath for the cell
    /// - Returns: pr cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard items.count > indexPath.row else {
            return tableView.dequeueReusableCell(withIdentifier: Constants.emptyTableViewCell.rawValue,
                                                 for: indexPath)
        }
        let item = items[indexPath.row]
        switch item {
        case .listItem(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.pullRequestTableViewCell.rawValue,
                                                     for: indexPath)
            (cell as? PullRequestTableViewCell)?.setupCell(model: model)
            return cell
        case .loader:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.pullRequestTableViewCell.rawValue,
                                                     for: indexPath)
            (cell as? PullRequestTableViewCell)?.startShimmeringCell()
            return cell
        }
    }
}
