//
//  Formatter+AU.swift
//  delivery-tracking-ios
//
//  Created by Niño Christian on 4/24/26.
//

import Foundation

extension Formatter {
    static let auTime: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss"
        f.locale = Locale(identifier: "en_AU")
        return f
    }()

    static let auDate: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yy"
        f.locale = Locale(identifier: "en_AU")
        return f
    }()
}
