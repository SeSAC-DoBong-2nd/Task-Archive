//
//  BOJ_2309.swift
//  preview
//
//  Created by 박신영 on 4/7/25.
//

/// 입력: 9개 readline으로 입력 받기.
/// 조건
/// - 9개 중 7개의 합이 100
/// 출력: 일곱 난쟁이 키 오름차순.

/// 2개빼고 다 합치고, 조건 만족 안하면 1개씩 미뤄서 더하면 좋을듯
///
import Foundation

func boj_2309() {
    var people = [Int]()
    for _ in 0..<9 {
        let input = Int(readLine()!)!
        people.append(input)
    }
    
    let totalSum = people.reduce(0, +)
    
    var result = [Int]()
    outerLoop: for i in 0..<8 {
        for j in (i + 1)..<9 {
            // i와 j 인덱스의 값을 제외한 나머지 합
            let excludeSum = totalSum - people[i] - people[j]
            if excludeSum == 100 {
                // 100이면 result에 추가
                for k in 0..<9 {
                    if k != i && k != j {
                        result.append(people[k])
                    }
                }
                break outerLoop // 조건 만족했으니 루프 종료
            }
        }
    }
    
    for height in result.sorted() {
        print(height)
    }
}
