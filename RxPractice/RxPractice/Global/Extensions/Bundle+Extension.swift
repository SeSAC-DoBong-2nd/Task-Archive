//
//  Bundle+Extension.swift
//  DailyTask_week4
//
//  Created by 박신영 on 1/15/25.
//

import Foundation

extension Bundle {
    
    var naverClientId: String? {
        return infoDictionary?["ClIENT_ID"] as? String
    }
    
    var naverClientSecret: String? {
        return infoDictionary?["ClIENT_SECRET"] as? String
    }
    
}
