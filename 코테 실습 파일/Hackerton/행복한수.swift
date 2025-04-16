//
//  행복한수.swift
//  preview
//
//  Created by 박신영 on 4/14/25.
//

import Foundation

func 행복한수() {
    var happyCount = 0
    
    // 1부터 1000까지 반복
    for num in 1...1000 {
        var current = num
        var visited = [Int]()
        
        //무한 반복
        while true {
            //이미 나온 숫자라면 탈출
            if visited.contains(current) {
                break
            }
            //제시된 순환(4, 16, 37, 58, 89, 145, 42, 20)에 포함되면 행복X
            if [4, 16, 37, 58, 89, 145, 42, 20].contains(current) {
                break
            }
            //결과가 1이면 행복O
            if current == 1 {
                happyCount += 1
                break
            }
            //중간 결과 기록
            visited.append(current)
            
            //자릿수의 제곱 합 계산
            var sum = 0
            while current > 0 {
                let digit = current % 10
                sum += digit * digit
                current /= 10
            }
            current = sum
        }
    }
    
    print(happyCount)
}
