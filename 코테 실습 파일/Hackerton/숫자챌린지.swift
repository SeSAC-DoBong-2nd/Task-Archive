//
//  숫자챌린지.swift
//  preview
//
//  Created by 박신영 on 4/14/25.
//

import Foundation

//혼자 시도하다 cpu와 메모리가 숨이 안 쉬어진다고 하여 ai와 함께 풀이하였습니다..
func 숫자챌린지() {
    let target = 777
    var totalNumbers = 0
    var digits = 1
    
    // 1. 777번째 수가 몇 자리 수인지 찾기
    while totalNumbers < target {
        let count = 1 << digits // 2^digits
        totalNumbers += count
        if totalNumbers >= target {
            break
        }
        digits += 1
    }
    
    // 2. 9자리 수에서 몇 번째인지 계산
    let previousTotal = totalNumbers - (1 << digits)
    let positionInDigits = target - previousTotal // 1-based index
    let binaryIndex = positionInDigits - 1 // 0-based index
    
    // 3. 2진수로 변환 (9자리로 맞춤)
    var binary = [Int](repeating: 0, count: digits)
    var num = binaryIndex
    for i in (0..<digits).reversed() {
        binary[i] = num % 2
        num /= 2
    }
    
    // 4. 2진수를 4와 7로 변환
    var result = ""
    for bit in binary {
        if bit == 0 {
            result += "4"
        } else {
            result += "7"
        }
    }
    
    print(result)
}
