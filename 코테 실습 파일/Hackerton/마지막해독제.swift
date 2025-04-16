//
//  마지막해독제.swift
//  preview
//
//  Created by 박신영 on 4/14/25.
//

import Foundation

func 마지막해독제() {
    var times = [7, 3, 15, 2, 9, 11, 6, 13, 5, 8, 14, 1, 19, 4, 21, 17, 12, 10, 18, 20, 16, 22, 25, 23, 24]
    times.sort()
    
    var totalWaitTime = 0
    var currentTime = 0
    
    for time in times {
        currentTime += time
        totalWaitTime += currentTime
    }
    
    print(totalWaitTime)
}
