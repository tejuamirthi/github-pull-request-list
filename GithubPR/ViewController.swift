//
//  ViewController.swift
//  GithubPR
//
//  Created by Amirthy Tejeshwar Rao on 10/11/22.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let button: UIButton = UIButton()
    let disposeBag: DisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button)
        button.addConstarint(leading: view.leadingAnchor,
                             trailing: view.trailingAnchor,
                             paddingLeft: 16,
                             paddingRight: 16,
                             height: 50)
        
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        button.setTitle("Open pr list", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        
        button.backgroundColor = .secondarySystemBackground
        button.rx
            .tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let viewController = ListViewController(viewModel: ListViewModel())
                viewController.modalPresentationStyle = .fullScreen
                viewController.modalTransitionStyle = .coverVertical
                owner.present(viewController, animated: true)
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: { [weak self] in
//                    viewController.dismiss(animated: true)
//                })
            }).disposed(by: disposeBag)
    }
}
