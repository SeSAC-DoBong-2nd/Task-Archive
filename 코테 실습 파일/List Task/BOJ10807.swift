//
//  개수 세기.swift
//  preview
//
//  Created by 박신영 on 3/28/25.
//

import Foundation

//어째서 런타임 에러가..2
//  -> v의 범위가 -100부터인데 나는 0~100까지만 고려하였다.
func 개수세기() {
    let _ = Int(readLine()!)!
    let input = readLine()!.split(separator: " ").map{Int(String($0))!}
    let v = Int(readLine()!)!
    var cnt: [Int] = .init(repeating: 0, count: 100 + 2)
    
    for element in input {
        cnt[element] += 1
    }

    print(cnt[v])
}

func boj_10807() {
    let _ = Int(readLine()!)!
    let arr = readLine()!.split(separator: " ").map{Int(String($0))!}
    let v = Int(readLine()!)!
    
    //v = -100 ~ 100 = 201개 +2는 여유주기
    var vis: [Int] = .init(repeating: 0, count: 201 + 2)
    for element in arr {
        vis[element + 100] += 1
    }
    
    print(vis[v+100])
}
