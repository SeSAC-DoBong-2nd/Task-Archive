//
//  요세푸스 문제.swift
//  preview
//
//  Created by 박신영 on 3/28/25.
//

import Foundation

func 요세푸스문제() {
    let input = readLine()!.split(separator: " ").map{Int(String($0))!}
    let (N, K) = (input[0], input[1])
    
    var arr = Array(1...N)
    var result = [Int]()
    var index = 0

    //모든 사람이 제거될 때까지 반복
    while !arr.isEmpty {
        //K번째 사람에게 인덱스 이동
        index = (index + (K - 1)) % arr.count
        //제거 및 추가
        result.append(arr.remove(at: index))
        //인덱스 조정: 제거 후 배열이 바뀌었으니
        if index == arr.count && !arr.isEmpty {
            index = 0
        }
    }
    
    let output = result.map { String($0) }.joined(separator: ", ")
    print("<\(output)>")
}
