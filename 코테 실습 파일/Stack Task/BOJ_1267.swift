//
//  BOJ_1267.swift
//  preview
//
//  Created by 박신영 on 4/1/25.
//

import Foundation

func boj_1267() {
    let _ = Int(readLine()!)!
    let calls = readLine()!.split(separator: " ").map{Int(String($0))!}
    
    var y = 0
    var m = 0
    
    for call in calls {
        y += ((call / 30) + 1) * 10
        m += ((call / 60) + 1) * 15
    }
    
    if y > m {
        print("M \(m)")
    } else if y < m {
        print("Y \(y)")
    } else {
        print("Y M \(y)")
    }
}
