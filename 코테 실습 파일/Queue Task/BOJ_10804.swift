//
//  BOJ_10804.swift
//  preview
//
//  Created by 박신영 on 4/7/25.
//

///입력: 총 10개 readline [ai, bi]
///조건
///- ai부터 bi까지 역순으로 뒤집어 같은 자리에 넣어두기
///출력: separator " "

import Foundation

func boj_10804() {
    var cards = Array(0...20)
    
    for _ in 0..<10 {
        let input = readLine()!.split(separator: " ").map { Int(String($0))! }
        let (a, b) = (input[0], input[1])
        
        let range = a...b
        let reversedSegment = cards[range].reversed()
        cards.replaceSubrange(range, with: reversedSegment)
    }
    
    let result = cards[1...20].map { String($0) }.joined(separator: " ")
    print(result)
}
