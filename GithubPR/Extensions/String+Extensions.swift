//
//  String+Extensions.swift
//  GithubPR
//
//  Created by Amirthy Tejeshwar Rao on 10/11/22.
//

import Foundation

extension String {
    static let isoDateTimeSecFormat: String = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    /// This method is used to get the date from string using the format in parameter
    /// - Parameter format: date format string
    /// - Returns: Date object if format and string are valid
    func toDate(using format: String = .isoDateTimeSecFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}
