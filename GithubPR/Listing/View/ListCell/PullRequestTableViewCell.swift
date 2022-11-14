//
//  PullRequestTableViewCell.swift
//  GithubPR
//
//  Created by Amirthy Tejeshwar Rao on 10/11/22.
//

import UIKit

/// This class represents the cell used to show github pull request cell
final class PullRequestTableViewCell: UITableViewCell {
    /// This label represents the title of the pull request
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 2
        label.textColor = .label
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    /// This label represents the body of the pull request
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 1
        label.textColor = .label.withAlphaComponent(0.9)
        return label
    }()
    
    /// This image represents the status image of the pull request
    private let statusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// This label represents the pr number
    private let issueNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .label.withAlphaComponent(0.7)
        return label
    }()
    
    /// This label represents the last updated time for this pr
    private let lastUpdatedLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .label.withAlphaComponent(0.7)
        return label
    }()
    
    /// This property is used to show the assignee of the pull request
    private let assigneeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// This view is as the contianer view for shadow and padding
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    /// This property is used to check if the shadow is setup
    private var isShadowSetup: Bool = false
    
    private let tagLabel: TagLabel = TagLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// This method is used to setup views
    private func setupViews() {
        let issueContainerView = UIView()
        
        contentView.addSubview(containerView)
        
        containerView.addConstarint(top: contentView.topAnchor,
                                    leading: contentView.leadingAnchor,
                                    bottom: contentView.bottomAnchor,
                                    trailing: contentView.trailingAnchor,
                                    paddingTop: 8,
                                    paddingLeft: 16,
                                    paddingBottom: 8,
                                    paddingRight: 16)
        
        issueContainerView.addSubviews(views: issueNumberLabel,
                                       lastUpdatedLabel,
                                       assigneeImage, tagLabel)

        containerView.addSubviews(
            views: titleLabel,
            bodyLabel,
            statusImage,
            issueContainerView
        )
        
        statusImage.addConstarint(top: containerView.topAnchor,
                                  leading: containerView.leadingAnchor,
                                  paddingTop: 16,
                                  paddingLeft: 16,
                                  width: 44,
                                  height: 44)
        
        issueContainerView.bottomAnchor.constraint(greaterThanOrEqualTo: statusImage.bottomAnchor,
                                                   constant: 16).isActive = true
        
        titleLabel.addConstarint(top: containerView.topAnchor,
                                 leading: statusImage.trailingAnchor,
                                 trailing: containerView.trailingAnchor,
                                 paddingTop: 16,
                                 paddingLeft: 16,
                                 paddingRight: 16)
        
        bodyLabel.addConstarint(top: titleLabel.bottomAnchor,
                                leading: titleLabel.leadingAnchor,
                                trailing: titleLabel.trailingAnchor,
                                paddingTop: 8)
        
        issueNumberLabel.centerYAnchor.constraint(equalTo: assigneeImage.centerYAnchor).isActive = true
        
        
        lastUpdatedLabel.centerYAnchor.constraint(equalTo: assigneeImage.centerYAnchor).isActive = true
        
        issueNumberLabel.addConstarint(leading: issueContainerView.leadingAnchor)
        
        assigneeImage.addConstarint(top: issueContainerView.topAnchor,
                                    leading: tagLabel.trailingAnchor,
                                    bottom: issueContainerView.bottomAnchor,
                                    paddingLeft: 8,
                                    width: 20,
                                    height: 20)
        
        tagLabel.addConstarint(leading: issueNumberLabel.trailingAnchor, paddingLeft: 8)
        tagLabel.centerYAnchor.constraint(equalTo: assigneeImage.centerYAnchor).isActive = true
        tagLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 30).isActive = true
        tagLabel.isHidden = true
        
        assigneeImage.layer.masksToBounds = true
        assigneeImage.layer.cornerRadius = 10
        
        lastUpdatedLabel.addConstarint(trailing: issueContainerView.trailingAnchor)
        
        lastUpdatedLabel.leadingAnchor.constraint(greaterThanOrEqualTo: assigneeImage.trailingAnchor,
                                                  constant: 16).isActive = true
        
        issueContainerView.clipsToBounds = false
        issueContainerView.addConstarint(top: bodyLabel.bottomAnchor,
                                         leading: titleLabel.leadingAnchor,
                                         bottom: containerView.bottomAnchor,
                                         trailing: titleLabel.trailingAnchor,
                                         paddingTop: 8,
                                         paddingBottom: 16, height: 20)
        if !isShadowSetup {
            isShadowSetup = !isShadowSetup
            containerView.layer.masksToBounds = true
            containerView.layer.cornerRadius = 16
            addShadow(view: containerView)
            containerView.backgroundColor = .secondarySystemBackground
        }
    }
    
    /// This method is called before reusing this cell for clean up
    override func prepareForReuse() {
        super.prepareForReuse()
        statusImage.image = nil
        bodyLabel.text = nil
        titleLabel.text = nil
        issueNumberLabel.text = nil
        lastUpdatedLabel.text = nil
        assigneeImage.image = nil
        tagLabel.isHidden = true
        tagLabel.config = .init()
        containerView.stopShimmering()
    }
    
    /// This method is used to setup the cell
    /// - Parameter model: pr model
    func setupCell(model: PullRequestCellModel) {
        let tintColor: UIColor
        let image: UIImage?
        if model.isDraft {
            image = .getImage(.draftRequest)?.withRenderingMode(.alwaysTemplate)
            tintColor = .systemGray2
        } else {
            image = .getImage(model.status.getImage())?.withRenderingMode(.alwaysTemplate)
            tintColor = .shamrockColor
        }
        statusImage.image = image
        statusImage.tintColor = tintColor

        titleLabel.text = model.title

        if let attributedString = try? AttributedString(markdown: "\(model.body ?? "")",
                                                        options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)) {
            bodyLabel.attributedText = NSAttributedString(attributedString)
        } else {
            bodyLabel.text = model.body
        }

        issueNumberLabel.text = "#\(model.number)"

        if let updatedDate = model.lastUpdated?.toDate() {
            lastUpdatedLabel.text = Date().offset(from: updatedDate)
        }

        assigneeImage.image = nil
        if let assignee = model.assigneeImage,
           let url = URL(string: assignee) {
            assigneeImage.setImage(with: url)
        }
        
        if let name = model.issueLabel?.name,
           let color = UIColor(hexColor: model.issueLabel?.color) {
            tagLabel.isHidden = false
            var config = tagLabel.config
            config.text = name
            config.backgroundColor = color
            config.horizontalPadding = 8
            tagLabel.config = config
        }
    }
    
    /// This method is used for shimmering effect over the cell while loading
    func startShimmeringCell() {
        containerView.startShimmering(width: frame.width, height: 100)
    }
    
    /// This method is used to get the tint color for the
    /// - Parameter state: pull request state
    /// - Returns: color of the respective state's pr
    private func tintColor(state: PrState) -> UIColor {
        switch state {
        case .open:
            return .shamrockColor
        case .merged:
            return .mergedPurple
        case .closed:
            return .closedRed
        }
    }
}
