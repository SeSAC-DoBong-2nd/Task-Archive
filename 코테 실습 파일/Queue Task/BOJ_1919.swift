//
//  BOJ_1919.swift
//  preview
//
//  Created by 박신영 on 4/7/25.
//

///입력: 글자 2개 입력받기
///조건
///- 2개의 글자 각 몇개를 제거 해야 서로 에너그램(?)
///방식
///- 각 글자를 알파벳 배열에 대입하고 맞는 개수 추출, 이후 return 값 만들기
///출력: 각 글자에서 제거한 글자 수 합

import Foundation

func boj_1919() {
    let A = readLine()!
    let B = readLine()!
    
    //각 알파벳 배열
    var freqA = [Int](repeating: 0, count: 26)
    var freqB = [Int](repeating: 0, count: 26)
    
    //A 문자 알파벳 나누기
    for char in A {
        let index = Int(char.asciiValue! - Character("a").asciiValue!)
        freqA[index] += 1
    }
    
    //B 문자 알파벳 나누기
    for char in B {
        let index = Int(char.asciiValue! - Character("a").asciiValue!)
        freqB[index] += 1
    }
    
    var commonCount = 0
    for i in 0..<26 {
        commonCount += min(freqA[i], freqB[i])
    }
    
    let deleteCount = (A.count - commonCount) + (B.count - commonCount)
    
    print(deleteCount)
}
