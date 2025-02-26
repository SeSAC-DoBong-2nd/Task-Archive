//
//  DateFormatterManager.swift
//  RxPractice
//
//  Created by 박신영 on 2/25/25.
//

import Foundation

final class DateFormatterManager {
    
    static let shard = DateFormatterManager()
    
    private init() {}
    
    func setDecimalNumber(num: Int) -> String {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .decimal
        return numFormatter.string(for: num) ?? "error"
    }
    
}
