//
//  Colors.swift
//  GithubPR
//
//  Created by Amirthy Tejeshwar Rao on 10/11/22.
//

import UIKit

// MARK: - Colors used in this application
extension UIColor {
    static let shamrockColor: UIColor = UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1)
    static let mergedPurple: UIColor = UIColor(red: 127/255, green: 0/255, blue: 232/255, alpha: 1.0) /* #7f00e8 */
    static let closedRed: UIColor = UIColor(red: 214/255, green: 62/255, blue: 50/255, alpha: 1.0) /* #d63e32 */
}

// MARK: - Hex to UIColor
extension UIColor {
    convenience init?(hexColor: String?) {
        guard let color = hexColor,
              let hex = UInt(color, radix: 16) else {
            return nil
        }
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0xFF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0xFF) / 255.0,
            alpha: 1.0
        )
    }
}
