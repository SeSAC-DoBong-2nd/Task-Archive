//
//  알파벳 개수.swift
//  preview
//
//  Created by 박신영 on 3/28/25.
//

import Foundation

func 알파벳개수() {
    // 입력 받기
    let s = readLine()!
    var count: [Int] = Array(repeating: 0, count: 26)

    for char in s {
        let index = Int(char.asciiValue! - Character("a").asciiValue!)
        count[index] += 1
    }

    let result = count.map { String($0) }.joined(separator: " ")
    print(result)
}

func boj_10808() {
    let str = readLine()!
    
    // a(97) ~ z
    // 0 ~ 25
    // 문자를 이진수로 표현 = 아스키 코드
    // beakjoon
    // n = 98 - "a".아스키코드값 (97) = 1
    var vis: [Int] = .init(repeating: 0, count: 26)
    for element in str {
        vis[Int(element.asciiValue!) - Int(UnicodeScalar("a").value)] += 1
    }
    print(vis.map { String($0) }.joined(separator: " "))
}
