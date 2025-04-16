//
//  BOJ_2493.swift
//  preview
//
//  Created by 박신영 on 4/7/25.
//

/// 입력: 탑의 개수, 각 탑의 높이 입력받기

/// 조건
/// - 역순으로 레이저 쏘고, 더 큰 값이 값을 수신
/// 방식
///- 각 탑 인덱스, 높이 담은 스택과 top의 유효 인덱스 담아두고 반복문으로 처리

/// 출력: 각 송신탑의 신호를 수신 받는 인덱스 출력

/*
 모든 문제를 링크드리스트를 활용하여 제대로 풀었어야 했는데 여기서 눈치채버렸습니다..
 */

import Foundation

func boj_2493() {
    let N = Int(readLine()!)!
    let heights = readLine()!.split(separator: " ").map { Int(String($0))! }
    
    var stack = [(index: Int, height: Int)](repeating: (0, 0), count: N)
    var top = -1 //스택의 유효한 마지막 인덱스
    
    var result = [Int](repeating: 0, count: N)
    
    //탑을 하나씩 처리
    for i in 0..<N {
        let currentHeight = heights[i]
        
        //스택의 맨 위 탑이 현재 탑보다 낮으면 제거
        while top >= 0 && stack[top].height < currentHeight {
            top -= 1 //스택에서 제거 (top 감소)
        }
        
        //스택이 비어 있지 않으면, 맨 위 탑이 신호를 수신
        if top >= 0 {
            result[i] = stack[top].index + 1 // 1-based 인덱스
        }
        
        //현재 탑을 스택에 추가
        top += 1
        stack[top] = (index: i, height: currentHeight)
    }
    
    let output = result.map { String($0) }.joined(separator: " ")
    print(output)
}
