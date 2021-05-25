//
//  DateFormatter+Memo.swift
//  SwiftUIMemo
//
//  Created by 김문옥 on 2020/07/12.
//  Copyright © 2020 MunokKim. All rights reserved.
//

import Foundation

extension DateFormatter {
    static let memoDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "Ko_kr")
        
        return formatter
    }()
}

extension DateFormatter: ObservableObject {}
