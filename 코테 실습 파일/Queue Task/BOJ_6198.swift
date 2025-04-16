//
//  BOJ_6198.swift
//  preview
//
//  Created by 박신영 on 4/7/25.
//

/// 입력: 건물 개수, 각 옥상의 높이 입력받기

/// 조건
/// - 오른쪽으로만 볼 수 있고, 높이가 보다 낮은 곳만 벤치마킹 가능
/// 방식
///- 2493과 동일

/// 출력: 각 옥상에서 오른쪽 기준 볼 수 있던 건물 개수

import Foundation

func boj_6198() {
    let N = Int(readLine()!)!
    var heights = [Int]()
    
    for _ in 0..<N {
        let input = Int(readLine()!)!
        heights.append(input)
    }
    
    //스택: (인덱스, 높이) 쌍을 저장
    var stack = [(index: Int, height: Int)](repeating: (0, 0), count: N)
    var top = -1 //스택의 유효한 마지막 인덱스
    
    //반환 값
    var totalCount = 0
    
    //빌딩을 하나씩 처리
    for i in 0..<N {
        let currentHeight = heights[i]
        
        //스택의 맨 위 빌딩이 현재 빌딩보다 낮거나 같으면 제거
        while top >= 0 && stack[top].height <= currentHeight {
            top -= 1 //스택에서 제거 (top 감소)
        }
        
        let visibleCount = top + 1
        totalCount += Int(visibleCount)
        
        top += 1
        stack[top] = (index: i, height: currentHeight)
    }
    
    //결과 출력
    print(totalCount)
}
