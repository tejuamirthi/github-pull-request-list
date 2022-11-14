//
//  TagLabel.swift
//  GithubPR
//
//  Created by Amirthy Tejeshwar Rao on 12/11/22.
//

import UIKit

/// A view for showing text in label with background, padding and corner radius
final class TagLabel: UIView {
    /// Config required for the tag label
    struct Config {
        var text: String = ""
        var font: UIFont = UIFont.preferredFont(forTextStyle: .caption1)
        var textColor: UIColor = .label
        var backgroundColor: UIColor = .gray
        var verticalPadding: CGFloat = 4
        var horizontalPadding: CGFloat = 0
        var cornerRadius: CGFloat = 8
    }
    
    /// The label itself to show the text
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    /// Config used by the view for the properties
    var config: Config = Config() {
        didSet {
            setupText(config: config)
        }
    }
    
    /// Vertical - top, bottom constraints for label
    private var verticalConstraints: [NSLayoutConstraint] = []
    
    /// Horizontal - leading, trailing constraints for label
    private var horizontalConstraints: [NSLayoutConstraint] = []
    
    init() {
        super.init(frame: .zero)
        setupViews()
        setupText()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Setup view method for creating the layout
    private func setupViews() {
        addSubview(label)
        translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        verticalConstraints.append(
            label.topAnchor.constraint(equalTo: topAnchor, constant: config.verticalPadding)
        )
        
        verticalConstraints.append(
            bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: config.verticalPadding)
        )
        
        horizontalConstraints.append(
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: config.horizontalPadding)
        )
        
        horizontalConstraints.append(
            trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: config.horizontalPadding)
        )
        
        verticalConstraints.forEach { $0.isActive = true }
        horizontalConstraints.forEach { $0.isActive = true }
        layer.masksToBounds = true
    }
    
    /// This method is used to setup the view based on config
    private func setupText(config: Config = Config()) {
        label.text = config.text
        label.textColor = config.textColor
        label.font = config.font
        backgroundColor = config.backgroundColor
        horizontalConstraints.forEach { $0.constant = config.horizontalPadding }
        verticalConstraints.forEach { $0.constant = config.verticalPadding }
        layer.cornerRadius = config.cornerRadius
    }
}

