//
//  BOJ_1475.swift
//  preview
//
//  Created by 박신영 on 4/21/25.
//

/*
 문제:
 - 다솜이 방 번호가 주어질 때, 해당 방 번호 표시하는데 필요한 세트 개수 최솟값 출력
 - (6, 9는 서로 대체 가능)
 
 풀이:
    1. 6과 9를 제외한 숫자의 중복된 개수 중 최댓값 만큼 가지기
    2. 6과 9는 합친 이후 2로 나누고, ceil함수로 소수점 값이 있다면 올림 진행
    3. 1과 2의 값중 최댓값 출력
 */

import Foundation

func boj_1475() {
    let N = readLine()!
    
    //0~9 숫자 담는 배열
    var count = [Int](repeating: 0, count: 10)
    
    for char in N {
        let num = Int(String(char))!
        count[num] += 1
    }
    
    //6과 9는 합쳐서 처리
    let sixNine = count[6] + count[9]
    count[6] = 0
    count[9] = 0
    
    //2로나눈 값에 소숫점이 존재한다면 올림 처리
    let setsForSixNine = Int(ceil(Double(sixNine)/2))
    
    //나머지 숫자(0~5, 7, 8)의 최대 등장 횟수
    let maxOther = count.max()!
    
    //위 2개를 비교하여 최댓가
    let result = max(setsForSixNine, maxOther)
    print(result)
}
