//
//  개수 세기.swift
//  preview
//
//  Created by 박신영 on 3/28/25.
//

import Foundation

//어째서 런타임 에러가..2
func 개수세기() {
    let n = Int(readLine()!)!
    var input = readLine()!.split(separator: " ").map{Int(String($0))!}
    let v = Int(readLine()!)!
    var cnt: [Int] = .init(repeating: 0, count: 100 + 2)
    
    for element in input {
        cnt[element] += 1
    }

    print(cnt[v])
}
