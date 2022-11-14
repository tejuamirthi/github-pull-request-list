//
//  LoaderCell.swift
//  GithubPR
//
//  Created by Amirthy Tejeshwar Rao on 10/11/22.
//

import UIKit

/// Loader cell for the reached bottom call
final class LoaderCell: UITableViewCell {
    /// activity indicator for the loader
    private let loadingIndicator: UIActivityIndicatorView = {
        if #available(iOS 13.0, *) {
            return UIActivityIndicatorView(style: .medium)
        } else {
            return UIActivityIndicatorView(style: .gray)
        }
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// helper function to start animating/stop the loader
    func animateLoader(shouldAnimate: Bool = false) {
        if shouldAnimate {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
    
    /// This method is used to setup the loader cell
    private func setupViews() {
        contentView.addSubviews(views: loadingIndicator)
        loadingIndicator.addConstarint(top: contentView.topAnchor,
                                       bottom: contentView.bottomAnchor,
                                       paddingTop: 16,
                                       paddingBottom: 16)
        
        loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
