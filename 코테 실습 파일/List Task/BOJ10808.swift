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
