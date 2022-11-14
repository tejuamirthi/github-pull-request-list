//
//  UIScrollView+Extensions.swift
//  GithubPR
//
//  Created by Amirthy Tejeshwar Rao on 10/11/22.
//

import UIKit
import RxSwift
import RxCocoa

extension UIScrollView {
    /// Returns if the scroll view has reached bottom in the specified direction
    /// - Returns: if the scroll view has reached the bottom
    func isReachedBottom() -> Bool {
        let contentOffset = contentOffset.y
        let contentSize = contentSize.height
        let frameSize = frame.size.height
        let translation = panGestureRecognizer.translation(in: superview)
        let isScrollBottom: Bool = translation.y < 0

        /// content offset including the frame size
        let maxContentOffset = contentOffset + frameSize
        /// if the contentSize is less than framesize it's at bottom already
        if contentSize > 0, contentSize < frameSize {
            return true
        }
        /// Reach bottom is true maximum offset is greater than or equal to contentSize
        return isScrollBottom && maxContentOffset >= contentSize
    }
}

extension Reactive where Base: UIScrollView {
    
    /// Returns Observable triggering reached bottom events
    /// - Returns: Observable which emits events whenever scrollview reaches the bottom
    func reachedBottom() -> Observable<Void> {
        /// check to trigger reached bottom with method invoke of content size
        /// covers some corners not included from dragging and decelerating triggers
        let contentSizeTrigger = base.rx.methodInvoked(#selector(setter: UIScrollView.contentSize))
            .map { [base] _ -> CGSize in
                base.contentSize
            }
            .distinctUntilChanged()
            .filter { [base] _ -> Bool in
                base.isReachedBottom()
            }
            .map { _ in }
        
        /// check to trigger reached bottom after dragging
        let draggingTrigger = base.rx.didEndDragging.asObservable()
            .filter { [base] _ -> Bool in
                base.isReachedBottom()
            }
            .map { _ in }
        
        /// check to trigger reached bottom after decelerating
        let deceleratingTrigger = base.rx.didEndDecelerating.asObservable()
            .filter { [base] _ -> Bool in
                base.isReachedBottom()
            }
            .map { _ in }
        
        return Observable.merge(contentSizeTrigger, draggingTrigger, deceleratingTrigger)
    }
}
