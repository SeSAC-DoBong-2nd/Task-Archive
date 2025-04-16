//
//  책페이지.swift
//  preview
//
//  Created by 박신영 on 4/14/25.
//

/*
 [Question]
 1페이지부터 999,456,789페이지까지, 각 숫자 0부터 9는 과연 몇 번씩 등장하는지 확인할 수 있는 알고리즘을 작성하세요

 [Answer]
 0, 2, 7이 등장하는 숫자를 공백을 기준으로 작성해주세요!
 
 [풀이방법]
 1. 0~9가 나온 횟수를 담을 배열 생성 및 for 문으로 마지막 페이지까지 설정
 2. 해당 페이지를 split으로 자르고 Int 변환 및 해당 숫자의 인덱스에 맞는 배열 값 증가
 3. 0, 2, 7 인덱스에 맞는 값 출력
 */

import Foundation

//근데 연산이 너무 많습니다..
func 책페이지() {
    var counts = [Int](repeating: 0, count: 10)
    
    for page in 1...999456789 {
        let pageStr = String(page)
        for char in pageStr {
            let digit = Int(String(char))!
            counts[digit] += 1
        }
    }
    
    print("\(counts[0]) \(counts[2]) \(counts[7])")
}
