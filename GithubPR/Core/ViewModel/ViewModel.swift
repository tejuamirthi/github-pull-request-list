//
//  ViewModel.swift
//  GithubPR
//
//  Created by Amirthy Tejeshwar Rao on 10/11/22.
//

import Foundation

/// This represents the view model skeletion structure type to be confirmed and used in all the screens
protocol ViewModel {
    /// This represents the Input actions
    associatedtype Input
    
    /// This represents the output reactions kind of similar to state updates
    associatedtype Output
    
    /// This method is used to transform the input to output values
    /// Basically using the input actions, we are generating output reactions
    func transform(input: Input) -> Output
}
