//
//  UI+Extensions.swift
//  GithubPR
//
//  Created by Amirthy Tejeshwar Rao on 10/11/22.
//

import UIKit
import SDWebImage

// MARK: - UIImageView
extension UIImageView {
    /// This method is used to set image from url
    /// - Parameter url: URL of the image
    func setImage(with url: URL) {
        sd_setImage(with: url)
    }
}

// MARK: - UIImage
extension UIImage {
    /// Helper method to get image from Images enum
    /// - Parameter image: images enum value
    /// - Returns: UIImage
    static func getImage(_ image: Images) -> UIImage? {
        return UIImage(named: image.rawValue)
    }
    
    /// Helper method to get the system image from respective enum
    /// - Parameter image: System Images enum value
    /// - Returns: UIImage
    static func getSystemImage(_ image: SystemImages) -> UIImage? {
        return UIImage(systemName: image.rawValue)
    }
}

// MARK: - View Shimmer extension
extension UIView {
    // Shimmer animator key
    enum AnimatorKeys: String {
        case customShimmer
    }
    
    /// This method is used to start shimmer animation
    /// - Parameters:
    ///   - width: width to be considered for the gradient, default is view's width
    ///   - height: height to be considered for the gradient, default is view's height
    func startShimmering(width: CGFloat? = nil, height: CGFloat? = nil) {
        let white = UIColor.white.cgColor
        let alpha = UIColor.white.withAlphaComponent(0.6).cgColor
        let width = width ?? bounds.width
        let height = height ?? bounds.height
        
        let gradient = CAGradientLayer()
        gradient.colors = [ alpha, white, alpha ]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.4)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.6)
        gradient.locations = [0.4, 0.5, 0.6]
        gradient.frame = CGRect(x: -1 * width, y: 0, width: width * 3, height: height)
        layer.mask = gradient
        
        let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 1.25
        animation.repeatCount = .infinity
        gradient.add(animation, forKey: AnimatorKeys.customShimmer.rawValue)
    }
    
    /// Used to stop shimmer animation
    func stopShimmering() {
        layer.mask = nil
    }
}

// MARK: - UIView subviews
extension UIView {
    
    /// This method is used to add multiple sub views from a single helper method
    /// - Parameter views: list of views to be added as subviews
    func addSubviews(views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
// MARK: - UIView Constraints
extension UIView {
    /// This method is used to add constraints for uiview
    /// - Parameters:
    ///   - top: top anchor for constraint
    ///   - leading: leading anchor for constraint
    ///   - bottom: bottom anchro for constraint
    ///   - trailing: trailing anchor for constraint
    ///   - paddingTop: padding respective to the top anchor if applicable
    ///   - paddingLeft: padding respective to the leading anchor if applicable
    ///   - paddingBottom: padding respective to the bottom anchor if applicable
    ///   - paddingRight: padding respective to the trailing anchor if applicable
    ///   - width: width of the view
    ///   - height: height of the view
    func addConstarint(top: NSLayoutYAxisAnchor? = nil,
                       leading: NSLayoutXAxisAnchor? = nil,
                       bottom: NSLayoutYAxisAnchor? = nil,
                       trailing: NSLayoutXAxisAnchor? = nil,
                       paddingTop: CGFloat = .zero,
                       paddingLeft: CGFloat = .zero,
                       paddingBottom: CGFloat = .zero,
                       paddingRight: CGFloat = .zero,
                       width: CGFloat? = nil,
                       height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let top = top {
            self.topAnchor.constraint(equalTo: top,
                                      constant: paddingTop).isActive = true
        }
        if let leading = leading {
            self.leadingAnchor.constraint(equalTo: leading,
                                          constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom,
                                         constant: -1 * paddingBottom).isActive = true
        }
        if let trailing = trailing {
            self.trailingAnchor.constraint(equalTo: trailing,
                                           constant: -1 * paddingRight).isActive = true
        }
    }
}

// MARK: - Shadow
extension UIView {
    /// This method is used to add shadow for a view
    /// - Parameter view: any view for whom shadow has to be added
    /// else the self view will be added with shadow
    func addShadow(view: UIView?) {
        let view: UIView = view ?? self
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 6
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
}
