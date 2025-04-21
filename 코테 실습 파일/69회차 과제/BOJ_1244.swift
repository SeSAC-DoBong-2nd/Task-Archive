//
//  BOJ_1244.swift
//  preview
//
//  Created by 박신영 on 4/21/25.
//

/*
 문제:
 - 스위치 개수, 각 스위치 상태, 학생 수를 입력 받은 다음 남학생이 받은 수, 여학생이 받은 수 역시 입력 받는다.
 - 이후 남학생이 스위치를 바꾸고, 여학생이 스위치를 바꾼 결과의 스위치들의 상태를 출력
 
 풀이:
    1. 남학생의 로직, 여학생의 로직에 맞게 스위치 상태 재정비 후 출력하기
 
 - 풀이 실패하고, 답안을 보며 이해하였습니다..
 */

import Foundation

func boj_1244() {
    // 스위치 개수
    let n = Int(readLine()!)!
    
    // 스위치 상태 (1-based 입력을 0-based로 저장)
    var switches = readLine()!.split(separator: " ").map { Int($0)! }
    
    // 학생 수
    let m = Int(readLine()!)!
    
    // 학생 정보 처리
    for _ in 0..<m {
        let input = readLine()!.split(separator: " ").map { Int($0)! }
        let gender = input[0] // 1: 남학생, 2: 여학생
        let k = input[1]      // 받은 숫자
        
        if gender == 1 {
            // 남학생: k의 배수 스위치 토글
            for i in stride(from: k, through: n, by: k) {
                switches[i - 1] ^= 1 // 1-based → 0-based
            }
        } else {
            // 여학생: k를 중심으로 대칭 구간 토글
            let center = k - 1 // 1-based → 0-based
            switches[center] ^= 1 // 중심 스위치 토글
            
            // 좌우 대칭 구간 탐색
            var left = center - 1
            var right = center + 1
            while left >= 0 && right < n && switches[left] == switches[right] {
                switches[left] ^= 1
                switches[right] ^= 1
                left -= 1
                right += 1
            }
        }
    }
    
    //출력: 20개씩 나누어 출력
    for i in 0..<n {
        print(switches[i], terminator: i % 20 == 19 || i == n - 1 ? "\n" : " ")
    }
}
