//
//  KeyboardObserver.swift
//  SwiftUIMemo
//
//  Created by 김문옥 on 2020/07/12.
//  Copyright © 2020 MunokKim. All rights reserved.
//

import UIKit
import Combine

class KeyboardObserver: ObservableObject {
    struct Context {
        let animationDuration: TimeInterval
        let height: CGFloat
        
        static let hide = Self(animationDuration: 0.25, height: 0)
    }
    
    @Published var context = Context.hide
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
        
        willShow.merge(with: willHide)
            .compactMap(parse)
            .assign(to: \.context, on: self)
            .store(in: &cancellables)
    }
    
    func parse(notification: Notification) -> Context? {
        guard let userInfo = notification.userInfo else { return nil }
        
        let safeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets
        let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
        
        var height: CGFloat = 0.0
        
        if let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let frame = value.cgRectValue
            
            if frame.origin.y < UIScreen.main.bounds.height {
                height = frame.height - (safeAreaInsets?.bottom ?? 0)
            }
        }
        
        return Context(animationDuration: animationDuration, height: height)
    }
}
