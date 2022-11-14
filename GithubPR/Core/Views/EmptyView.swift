//
//  EmptyView.swift
//  GithubPR
//
//  Created by Amirthy Tejeshwar Rao on 10/11/22.
//

import UIKit

/// This view is used as an empty state view
final class EmptyView: UIView {
    /// This property represents the empty document image
    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// This property represents the label which shows the empty state message
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
    
    init(title: String, image: Images) {
        super.init(frame: .zero)
        setupViews()
        self.image.image = .getImage(image)
        self.label.text = title
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// This method is used to setup views
    private func setupViews() {
        addSubviews(views: image, label)
        
        image.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50).isActive = true
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.addConstarint(width: 200, height: 200)
        
        image.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16).isActive = true
        trailingAnchor.constraint(greaterThanOrEqualTo: image.trailingAnchor, constant: 16).isActive = true
        
        
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.addConstarint(top: image.bottomAnchor,
                            leading: leadingAnchor,
                            trailing: trailingAnchor,
                            paddingTop: 16,
                            paddingLeft: 16,
                            paddingRight: 16)
        bottomAnchor.constraint(greaterThanOrEqualTo: label.bottomAnchor, constant: 16).isActive = true
    }
}
