//
//  BOJ_9375.swift
//  preview
//
//  Created by 박신영 on 4/21/25.
//

import Foundation

/*
 문제:
 - 테스트 케이스 개수 입력 받고, 그 개수만큼 출력을 진행한다.
 - 이후 의상 수를 입력 받고, 해당 의상들을 사용하여 알몸이 아닐 때까지 며칠을 버틸 수 있나 출력
 
 풀이:
    1. index 1에 해당하는 의상 카데고리 별 key 값으로 나누고 해당 key 값에 +1 진행
    2. 이후 해당 딕셔너리 values 값을 반복문으로 돌리고 각 해당 카테고리 중 착용하지 않는 경우를 감안하여 value + 1의 값을 최종 출력 값에 곱해줌
    3. 알몸인 경우는 제외해야 하기에 -1을 적용한 값을 출력
 */

func boj_9375() {
    //테스트 케이스 수
    let T = Int(readLine()!)!
    
    for _ in 0..<T {
        //의상 수
        let n = Int(readLine()!)!
        
        //종류별 의상 수 저장 딕셔너리
        var clothes: [String: Int] = [:]
        
        //의상 입력 처리
        for _ in 0..<n {
            let input = readLine()!.split(separator: " ").map { String($0) }
            let category = input[1]
            clothes[category, default: 0] += 1
        }
        
        //조합 수 계산
        var combinations = 1
        for count in clothes.values {
            combinations *= (count + 1) //의상 개수 + 1(안 입는 경우)
        }
        
        //전부 다 안 입는 경우 제외
        combinations -= 1
        
        print(combinations)
    }
}
